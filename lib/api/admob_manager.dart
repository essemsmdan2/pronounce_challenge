import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pronounce_challenge/modals/user_preferences.dart';

class AdManager {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: Platform.isIOS
          ? "ca-app-pub-1426529590077720/6186803041"
          : "ca-app-pub-1426529590077720/4475842533",
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );

    _bannerAd?.load();
  }

  void loadRewardedAd() {
    RewardedAd.load(
        adUnitId: Platform.isIOS
            ? "ca-app-pub-1426529590077720/8213597940"
            : "ca-app-pub-1426529590077720/2622870669",
        request: const AdRequest(),
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          print(error);
          _rewardedAd = null;
        }));
    print('RewardedAd Loaded');
  }

  void loadInterstitialAd() {
    String interstitialAdId = Platform.isIOS
        ? "ca-app-pub-1426529590077720/1849679191"
        : "ca-app-pub-1426529590077720/9536597529";

    InterstitialAd.load(
        adUnitId: interstitialAdId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;

            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                ad.dispose();
                loadInterstitialAd();
              },
              onAdFailedToShowFullScreenContent:
                  (InterstitialAd ad, AdError error) {
                ad.dispose();
                loadInterstitialAd();
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  void addAds(bool interstitial, bool bannerAd, bool rewardedAd) {
    if (interstitial) {
      loadInterstitialAd();
    }

    if (bannerAd) {
      loadBannerAd();
    }

    if (rewardedAd) {
      loadRewardedAd();
    }
  }

  void showInterstitial() {
    _interstitialAd?.show();
  }

  BannerAd? getBannerAd() {
    return _bannerAd;
  }

  void showRewardedAd() {
    bool? _result = UserPreferences.getRemovalAdsBool();
    if (_result == null) {
      if (_rewardedAd != null) {
        _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (RewardedAd ad) {
          print("Ad onAdShowedFullScreenContent");
        }, onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          loadRewardedAd();
        }, onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          ad.dispose();
          loadRewardedAd();
        });

        _rewardedAd!.setImmersiveMode(true);
        _rewardedAd!.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print("${reward.amount} ${reward.type}");
        });
      }
    }
  }

  void disposeAds() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }

  Widget showBannerWidget(context) {
    bool? _result = UserPreferences.getRemovalAdsBool();

    return _result == null
        ? SizedBox(
            width: double.infinity,
            height: 55,
            child: AdWidget(ad: getBannerAd()!),
          )
        : Container(
            width: 200,
            height: 50,
          );
  }
}
