//
//  SPUnityAdsAdapter.h
//  SponsorPaySample
//
//  Created on 10/1/13.
//  Copyright (c) 2013 Fyber. All rights reserved.
//

@class SPUnityAdsRewardedVideoAdapter;
@compatibility_alias SPApplifierRewardedVideoAdapter SPUnityAdsRewardedVideoAdapter;

#import <Foundation/Foundation.h>
#import "SPRewardedVideoNetworkAdapter.h"


#import "UnityAds.h"

@class SPUnityAdsNetwork;

@interface SPUnityAdsRewardedVideoAdapter : NSObject<SPRewardedVideoNetworkAdapter, UnityAdsDelegate>

@property (nonatomic, weak) SPUnityAdsNetwork *network;

@end