import 'package:flutter/material.dart';
import 'package:yodo1mas/testmasfluttersdktwo.dart';

class YoDoAds extends StatefulWidget {
  const YoDoAds({Key? key}) : super(key: key);

  @override
  State<YoDoAds> createState() => _YoDoAdsState();
}

class _YoDoAdsState extends State<YoDoAds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Yodo1MASBannerAd(
        size: BannerSize.Banner,
        onLoad: () => print('Banner loaded:'),
        onOpen: () => print('Banner clicked:'),
        onClosed: () => print('Banner clicked:'),
        onLoadFailed: (message) => print('Banner Ad $message'),
        onOpenFailed: (message) => print('Banner Ad $message'),
      ),
    );
  }
}
