import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper{

  //Test IDs
  //Banner	        ca-app-pub-3940256099942544/6300978111
  //Interstitial	  ca-app-pub-3940256099942544/1033173712
  //Rewarded	      ca-app-pub-3940256099942544/5224354917

  //Replace with your IDs

  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else {

    }
  }

  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else {
    }
  }

  static String? get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else {
    }
  }


  static InterstitialAd? interstitialAd;

  static void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) => interstitialAd = null,
      ),
    );
  }

  static void showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
          }, onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
          });
      interstitialAd!.show();
    }
  }

  static RewardedAd? rewardedAd;
  static final AdRequest request = AdRequest(nonPersonalizedAds: true,);

  static void createRewardedAd() {

    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId!,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            rewardedAd = ad;
            showRewardedAd();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            rewardedAd = null;
          },
        ));
  }

  static void showRewardedAd() {

    if (rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) =>
            print('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          print('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
        }
    );

    rewardedAd!.setImmersiveMode(true);
    rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print("Rewarded");
        });
    rewardedAd = null;
  }

}

class AdmobBanner extends StatefulWidget {
  const AdmobBanner({super.key});

  @override
  State<AdmobBanner> createState() => _AdmobBannerState();
}

class _AdmobBannerState extends State<AdmobBanner> {

  late BannerAd bannerAd;
  bool isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.bannerAdUnitId!,
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState(() {
                isAdLoaded = true;
              });
            },
            onAdFailedToLoad: (ad,error){
              ad.dispose();
            }
        ),
        request: const AdRequest()

    );
    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.parse(bannerAd.size.height.toString()),
      width: double.parse(bannerAd.size.width.toString()),
      child: isAdLoaded
        ? AdWidget(ad: bannerAd)
        : Stack()
    );
  }
}
