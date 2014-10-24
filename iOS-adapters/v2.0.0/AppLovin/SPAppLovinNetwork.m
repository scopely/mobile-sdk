//
//  SPProviderAppLovin.m
//  Fyber iOS SDK - AppLovin Adapter v.2.1.0
//
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPAppLovinNetwork.h"
#import "SPTPNGenericAdapter.h"
#import "SPInterstitialNetworkAdapter.h"
#import "SPRewardedVideoNetworkAdapter.h"
#import "SPSemanticVersion.h"
#import "SPLogger.h"

static NSString *const SPAppLovinSDKKey                 = @"SPAppLovinSdkKey";
static NSString *const SPInterstitialAdapterClassName   = @"SPAppLovinInterstitialAdapter";
static NSString *const SPRewardedVideoAdapterClassName  = @"SPAppLovinRewardedVideoAdapter";

// Adapter versioning - Remember to update the header
static const NSInteger SPAppLovinVersionMajor = 2;
static const NSInteger SPAppLovinVersionMinor = 1;
static const NSInteger SPAppLovinVersionPatch = 0;

@interface SPAppLovinNetwork()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign, readwrite) SPNetworkSupport supportedServices;

@property (nonatomic, strong) SPTPNGenericAdapter *rewardedVideoAdapter;
@property (nonatomic, strong) id<SPInterstitialNetworkAdapter> interstitialAdapter;

@end

@implementation SPAppLovinNetwork

@synthesize name;
@synthesize supportedServices;
@synthesize rewardedVideoAdapter;
@synthesize interstitialAdapter;

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPAppLovinVersionMajor
                                         minor:SPAppLovinVersionMinor
                                         patch:SPAppLovinVersionPatch];
}

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        Class RewardedVideoAdapterClass = NSClassFromString(SPRewardedVideoAdapterClassName);
        if (RewardedVideoAdapterClass) {
            self.rewardedVideoAdapter = [[SPTPNGenericAdapter alloc] init];
        }

        Class InterstitialAdapterClass = NSClassFromString(SPInterstitialAdapterClassName);
        if (InterstitialAdapterClass) {
            self.interstitialAdapter = [[InterstitialAdapterClass alloc] init];
        }
    }
    return self;
}

#pragma mark - Public

- (BOOL)startSDK:(NSDictionary *)data
{
    return YES;
}

- (void)startRewardedVideoAdapter:(NSDictionary *)data
{
    Class RewardedVideoAdapterClass = NSClassFromString(SPRewardedVideoAdapterClassName);
    if (!RewardedVideoAdapterClass) {
        return;
    }

    id<SPRewardedVideoNetworkAdapter> appLovinRewardedVideoAdapter = [[RewardedVideoAdapterClass alloc] init];

    SPTPNGenericAdapter *appLovinRewardedVideoAdapterWrapper = [[SPTPNGenericAdapter alloc] initWithVideoNetworkAdapter:appLovinRewardedVideoAdapter];
    appLovinRewardedVideoAdapter.delegate = appLovinRewardedVideoAdapterWrapper;

    self.rewardedVideoAdapter = appLovinRewardedVideoAdapterWrapper;

    [super startRewardedVideoAdapter:data];
}

@end
