import 'package:flutter/material.dart';
import 'package:from_me/pages/home_page.dart';
import 'package:from_me/services/local_storage_service.dart';
import 'package:from_me/services/notification_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  // main() 함수에서 async를 쓰기 위해선 아래 코드를 추가해줘야합니다.
  WidgetsFlutterBinding.ensureInitialized();

  // AdMob 초기화
  MobileAds.instance.initialize();

  // SharedPreferences 인스턴스를 로드합니다.
  // 로딩이 완료된 뒤에 runApp을 호출하도록 await을 사용합니다.
  await LocalStorageService.init();

  // notification 초기화
  await NotificationService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Gaegu'),
      home: HomePage(),
    );
  }
}
