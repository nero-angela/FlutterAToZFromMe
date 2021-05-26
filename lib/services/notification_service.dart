import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:from_me/models/letter.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // 안드로이드에는 notification channel이라는 개념이 있습니다.
  static final String _androidChannelId = 'fromme';
  static final String _androidChannelName = 'fromme';
  static final String _androidChannelDesc = 'fromme notification channel';
  static final AndroidNotificationChannel _androidDefaultChannel = AndroidNotificationChannel(
    _androidChannelId,
    _androidChannelName,
    _androidChannelDesc,
  );

  // 초기화
  static init() async {
    _flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('trans_logo'), // android/app/src/main/res/drawable/trans_logo.png
        iOS: IOSInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
      ),
    );

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    if (Platform.isAndroid) {
      // create android default channel
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidDefaultChannel);
    }
  }

  // 편지 발송
  static sendLetter(Letter letter) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        letter.id, // 편지의 고유 아이디를 notification id로 전달합니다.
        '✉️ ${DateFormat('yy.MM.dd').format(letter.sendedAt)} 발송한 편지가 도착했어요.',
        letter.title,
        tz.TZDateTime.from(letter.arrivedAt, tz.local), // 알람이 뜨는 시간을 현재 타임존에 맞춤니다.
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannelId,
            _androidChannelName,
            _androidChannelDesc,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }

  // 편지 발송 취소
  static Future recallLetter(Letter letter) async {
    await _flutterLocalNotificationsPlugin.cancel(letter.id); // 편지의 고유 아이디로 notification을 예약했으므로, 취소도 동일합니다.
  }
}
