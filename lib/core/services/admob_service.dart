import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// ============================================================================
/// Family Finance Manager
/// AdMob Service
/// ----------------------------------------------------------------------------
/// Centralized wrapper around Google Mobile Ads.
///
/// Responsibilities:
/// • Initialize Google Mobile Ads
/// • Banner Ads
/// • Interstitial Ads
/// • Rewarded Ads
/// • App Open Ads (future)
///
/// NOTE:
/// This service only manages loading/showing ads.
/// Business logic (Premium users, frequency, etc.) belongs elsewhere.
/// ============================================================================
class AdMobService {
  AdMobService();

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool _initialized = false;

  /// Initialize Google Mobile Ads SDK.
  Future<InitializationStatus> initialize() async {
    if (_initialized) {
      return MobileAds.instance.initialize();
    }

    final status = await MobileAds.instance.initialize();
    _initialized = true;
    return status;
  }

  /// Banner Ad Unit ID
  String get bannerAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }

    // TODO: Replace with your production Banner IDs.
    return Platform.isAndroid
        ? 'YOUR_ANDROID_BANNER_ID'
        : 'YOUR_IOS_BANNER_ID';
  }

  /// Interstitial Ad Unit ID
  String get interstitialAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910';
    }

    // TODO: Replace with your production Interstitial IDs.
    return Platform.isAndroid
        ? 'YOUR_ANDROID_INTERSTITIAL_ID'
        : 'YOUR_IOS_INTERSTITIAL_ID';
  }

  /// Rewarded Ad Unit ID
  String get rewardedAdUnitId {
    if (kDebugMode) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313';
    }

    // TODO: Replace with your production Rewarded IDs.
    return Platform.isAndroid
        ? 'YOUR_ANDROID_REWARDED_ID'
        : 'YOUR_IOS_REWARDED_ID';
  }

  /// Loads a banner ad.
  Future<BannerAd> loadBannerAd({
    required AdSize size,
    VoidCallback? onLoaded,
    Function(LoadAdError error)? onFailed,
  }) async {
    _bannerAd?.dispose();

    final banner = BannerAd(
      adUnitId: bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          onLoaded?.call();
        },
        onAdFailedToLoad: (_, error) {
          onFailed?.call(error);
        },
      ),
    );

    await banner.load();
    _bannerAd = banner;

    return banner;
  }

  BannerAd? get bannerAd => _bannerAd;

  /// Loads an interstitial ad.
  Future<void> loadInterstitialAd({
    VoidCallback? onLoaded,
    Function(LoadAdError error)? onFailed,
  }) async {
    _interstitialAd?.dispose();

    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          onLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          onFailed?.call(error);
        },
      ),
    );
  }

  /// Shows an interstitial ad.
  Future<bool> showInterstitialAd() async {
    final ad = _interstitialAd;

    if (ad == null) {
      return false;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _interstitialAd = null;
      },
    );

    ad.show();
    return true;
  }

  /// Loads a rewarded ad.
  Future<void> loadRewardedAd({
    VoidCallback? onLoaded,
    Function(LoadAdError error)? onFailed,
  }) async {
    _rewardedAd?.dispose();

    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          onLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          onFailed?.call(error);
        },
      ),
    );
  }

  /// Shows a rewarded ad.
  Future<bool> showRewardedAd({
    required void Function(RewardItem reward) onRewardEarned,
  }) async {
    final ad = _rewardedAd;

    if (ad == null) {
      return false;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _rewardedAd = null;
      },
    );

    await ad.show(
      onUserEarnedReward: (_, reward) {
        onRewardEarned(reward);
      },
    );

    return true;
  }

  /// Dispose all loaded ads.
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();

    _bannerAd = null;
    _interstitialAd = null;
    _rewardedAd = null;
  }
}
