//
//  SPUnityAdsInterstitialAdapter.m
//
//  Created on 10/10/14.
//  Copyright (c) 2013 Fyber. All rights reserved.
//

#import "SPUnityAdsNetwork.h"
#import <UnityAds/UnityAds.h>

/**
 Implementation of Unity Ads network for Interstitial demand

 ## Version compatibility

 - Adapter version: 2.3.0
 - Fyber SDK version: 7.0.2
 - Unity Ads SDK version: 1.3.8

 */


@class SPUnityAdsInterstitialAdapter;

@interface SPUnityAdsInterstitialAdapter : NSObject<SPInterstitialNetworkAdapter, UnityAdsDelegate>

@property (weak, nonatomic) SPApplifierNetwork *network;

@end
