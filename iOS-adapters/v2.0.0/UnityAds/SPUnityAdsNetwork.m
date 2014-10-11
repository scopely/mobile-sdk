//
//  SPUnityAdsProvider.m
//  SponsorPay iOS SDK - UnityAds Adapter v.2.1.0
//
//  Created on 13/01/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "UnityAds.h"

#import "SPUnityAdsNetwork.h"
#import "SPLogger.h"
#import "SPSemanticVersion.h"
#import "SPTPNGenericAdapter.h"
#import "SPRewardedVideoNetworkAdapter.h"

#import "WBAdService+Internal.h"

static NSString *const SPUnityAdsGameId = @"SPUnityAdsGameId";

static NSString *const SPRewardedVideoAdapterClassName = @"SPUnityAdsRewardedVideoAdapter";

// Adapter versioning - Remember to update the header
static const NSInteger SPUnityAdsVersionMajor = 2;
static const NSInteger SPUnityAdsVersionMinor = 1;
static const NSInteger SPUnityAdsVersionPatch = 0;

@interface SPUnityAdsNetwork ()

@property (nonatomic, strong) SPTPNGenericAdapter *rewardedVideoAdapter;
@property (nonatomic, copy, readwrite) NSString *name;

@end

@implementation SPUnityAdsNetwork

@synthesize rewardedVideoAdapter;
@synthesize name;

#pragma mark - Class Methods

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPUnityAdsVersionMajor
                                         minor:SPUnityAdsVersionMinor
                                         patch:SPUnityAdsVersionPatch];
}

#pragma mark - Initialization

- (BOOL)startSDK:(NSDictionary *)data
{
    self.name = @"Applifier";
    
//    NSString *gameId = data[SPUnityAdsGameId];
//
//    if (!gameId) {
//        SPLogError(@"Could not start %@ Provider. %@ empty or missing.", self.name, SPUnityAdsGameId);
//        return NO;
//    }

    NSString *gameId = [NSString stringWithFormat:@"%@-%@", [[WBAdService sharedAdService] fullpageIdForAdId:WBAdIdAF], [[WBAdService sharedAdService] fullpageIdForAdId:WBAdIdAFIncentivizedId]];
    
    [[UnityAds sharedInstance] startWithGameId:gameId];

#ifdef UNITY_ADS_TEST_MODE
#warning Unity Ads Test mode enabled
    [[UnityAds sharedInstance] setDebugMode:YES];
    [[UnityAds sharedInstance] setTestMode:YES];
#endif

    return YES;
}

- (void)startRewardedVideoAdapter:(NSDictionary *)data
{
    Class RewardedVideoAdapterClass = NSClassFromString(SPRewardedVideoAdapterClassName);
    if (!RewardedVideoAdapterClass) {
        return;
    }

    id<SPRewardedVideoNetworkAdapter> unityAdsAdapter = [[RewardedVideoAdapterClass alloc] init];

    SPTPNGenericAdapter *unityAdsAdapterWrapper = [[SPTPNGenericAdapter alloc] initWithVideoNetworkAdapter:unityAdsAdapter];
    unityAdsAdapter.delegate = unityAdsAdapterWrapper;

    self.rewardedVideoAdapter = unityAdsAdapterWrapper;

    [super startRewardedVideoAdapter:data];
}

@end
