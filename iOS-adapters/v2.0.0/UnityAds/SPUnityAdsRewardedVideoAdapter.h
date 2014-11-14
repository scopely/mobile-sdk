//
//  SPUnityAdsRewardedVideoAdapter.h
//
//  Created on 10/1/13.
//  Copyright (c) 2013 Fyber. All rights reserved.
//

@class SPUnityAdsRewardedVideoAdapter;
@compatibility_alias SPApplifierRewardedVideoAdapter SPUnityAdsRewardedVideoAdapter;

#import <Foundation/Foundation.h>
#import "SPRewardedVideoNetworkAdapter.h"
#import "UnityAds.h"

/**
 Implementation of Unity Ads network for Rewarded Video demand
 
 ## Version compatibility
 
 - Adapter version: 2.2.0
 - Fyber SDK version: 6.5.2
 - Unity Ads SDK version: 1.3.8
 
 */

@class SPUnityAdsNetwork;

@interface SPUnityAdsRewardedVideoAdapter : NSObject<SPRewardedVideoNetworkAdapter, UnityAdsDelegate>

@property (nonatomic, weak) SPUnityAdsNetwork *network;

@end