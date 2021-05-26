import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBanner extends StatefulWidget {
  AdBanner({Key? key}) : super(key: key);

  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  // 광고 로드 여부
  bool isBannerAdLoaded = false;

  // 광고
  late BannerAd bannerAd;

  @override
  void initState() {
    super.initState();

    // BannerAd instance 생성
    bannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-2282734164072819/9481612815'
          : 'ca-app-pub-2282734164072819/7785387766',
      size: AdSize.fullBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          // 광고 로딩 완료시 setState
          setState(() {
            isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();

          print('배너 광고 불러오기 실패 (code=${error.code} message=${error.message})');
        },
      ),
    );

    // 광고 불러오기
    bannerAd.load();
  }

  @override
  void dispose() {
    if (isBannerAdLoaded) {
      bannerAd.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: isBannerAdLoaded ? 60 : 0, // 광고가 로드되면 높이를 지정해줍니다.
      child: isBannerAdLoaded
          ? AdWidget(ad: bannerAd)
          : Container(),
    );
  }
}
