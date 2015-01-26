//
//  SPInMobiNetwork.m
//
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPLogger.h"
#import "SponsorPaySDK.h"
#import "SPInMobiNetwork.h"
#import "SPSemanticVersion.h"
#import "SPTPNGenericAdapter.h"
#import "SPRewardedVideoNetworkAdapter.h"

static NSString *const SPInMobiAppId = @"SPInMobiAppId";
static NSString *const SPInMobiRewardedVideoPropertyId = @"SPInMobiRewardedVideoPropertyId";
static NSString *const SPInMobiLogLevel = @"SPInMobiLogLevel";

static NSString *const SPInMobiLogLevelNone = @"none";
static NSString *const SPInMobiLogLevelDebug = @"debug";
static NSString *const SPInMobiLogLevelVerbose = @"verbose";

static NSString *const kInMobiThirdPartyParameter = @"tp";
static NSString *const kInMobiThirdPartyVersionParameter = @"tp-ver";
static NSString *const kInMobiThirdPartyParameterValue = @"c_sponsorpay";

static NSString *const SPInterstitialAdapterClassName = @"SPInMobiInterstitialAdapter";
static NSString *const SPRewardedVideoAdapterClassName = @"SPInMobiRewardedVideoAdapter";

// Adapter versioning - Remember to update the header
static const NSInteger SPInMobiVersionMajor = 3;
static const NSInteger SPInMobiVersionMinor = 0;
static const NSInteger SPInMobiVersionPatch = 0;

@interface SPInMobiNetwork ()

@property (strong, nonatomic) SPTPNGenericAdapter *rewardedVideoAdapter;
@property (strong, nonatomic) id<SPInterstitialNetworkAdapter> interstitialAdapter;
@property (weak, nonatomic) id<SPRewardedVideoNetworkAdapter> rewardedVideoNetworkAdapter;
@property (copy, nonatomic, readwrite) NSString *appId;
@property (nonatomic, copy, readwrite) NSString *rewardedVideoPropertyId;

@end

@implementation SPInMobiNetwork

@synthesize interstitialAdapter;
@synthesize rewardedVideoAdapter;
+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPInMobiVersionMajor minor:SPInMobiVersionMinor patch:SPInMobiVersionPatch];
}

- (id)init
{
    self = [super init];
    if (self) {
        Class RewardedVideoAdapterClass = NSClassFromString(SPRewardedVideoAdapterClassName);
        if (RewardedVideoAdapterClass) {
            id<SPRewardedVideoNetworkAdapter> inMobiRewardedVideoNetworkAdapter = [[RewardedVideoAdapterClass alloc] init];
            self.rewardedVideoNetworkAdapter = inMobiRewardedVideoNetworkAdapter;

            self.rewardedVideoAdapter = [[SPTPNGenericAdapter alloc] initWithVideoNetworkAdapter:inMobiRewardedVideoNetworkAdapter];
            inMobiRewardedVideoNetworkAdapter.delegate = self.rewardedVideoAdapter;
        }

        Class InterstitialAdapterClass = NSClassFromString(SPInterstitialAdapterClassName);
        if (InterstitialAdapterClass) {
            self.interstitialAdapter = [[InterstitialAdapterClass alloc] init];
        }
    }
    return self;
}

- (BOOL)startSDK:(NSDictionary *)data
{
    self.appId = data[SPInMobiAppId];
    self.rewardedVideoPropertyId = data[SPInMobiRewardedVideoPropertyId];

    if (!self.appId.length && !self.rewardedVideoPropertyId.length) {
        SPLogError(@"Could not start %@ network. %@ and %@ empty or missing.", self.name, SPInMobiAppId, SPInMobiRewardedVideoPropertyId);
        return NO;
    }
    IMLogLevel logLevel = [self inMobiLogLevel:data[SPInMobiLogLevel]];
    [InMobi setLogLevel:logLevel];

    if (self.appId.length) {
        [InMobi initialize:self.appId];
    } else {
        [InMobi initialize:self.rewardedVideoPropertyId];
    }

    return YES;
}

- (NSDictionary *)additionalParameters
{
    if (!_additionalParameters) {
        _additionalParameters = @{
            kInMobiThirdPartyParameter: kInMobiThirdPartyParameterValue,
            kInMobiThirdPartyVersionParameter: [SponsorPaySDK versionString]
        };
    }
    return _additionalParameters;
}

- (IMLogLevel)inMobiLogLevel:(NSString *)logLevel
{
    if ([logLevel isEqualToString:SPInMobiLogLevelVerbose]) {
        return IMLogLevelVerbose;
    } else if ([logLevel isEqualToString:SPInMobiLogLevelDebug]) {
        return IMLogLevelDebug;
    }
    return IMLogLevelNone;
}

@end
