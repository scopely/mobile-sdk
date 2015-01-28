//
//  SPHyprMXNetwork.m
//
//  Created on 22.05.14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPHyprMXNetwork.h"
#import "SPLogger.h"
#import "SPRandomID.h"
#import "SPSemanticVersion.h"
#import "SPTPNGenericAdapter.h"
#import "SPSystemVersionChecker.h"
#import "HyprMX.h"
#import "WBAdService+Internal.h"

static const NSInteger SPHyprMXVersionMajor = 2;
static const NSInteger SPHyprMXVersionMinor = 1;
static const NSInteger SPHyprMXVersionPatch = 3;

static NSString *const SPHyprMXDistributorID = @"SPHyprMXDistributorID";
static NSString *const SPHyprMXPropertyID = @"SPHyprMXPropertyID";
static NSString *const SPHyprMXUserID = @"SPHyprMXUserID";

static NSString *const SPRewardedVideoAdapterClassName = @"SPHyprMXRewardedVideoAdapter";


@interface SPHyprMXNetwork ()

@property (nonatomic, copy, readonly) NSString *HyprMXUserID;
@property (nonatomic, strong) id<SPTPNVideoAdapter> rewardedVideoAdapter;
@property (nonatomic, assign) BOOL sdkStarted;

@end


@implementation SPHyprMXNetwork

@synthesize rewardedVideoAdapter = _rewardedVideoAdapter;

#pragma mark - Class Methods

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion
            versionWithMajor:SPHyprMXVersionMajor
            minor:SPHyprMXVersionMinor
            patch:SPHyprMXVersionPatch];
}


#pragma mark - Custom Accessors

- (NSString *)HyprMXUserID
{
    NSUserDefaults *const defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *result = [defaults objectForKey:SPHyprMXUserID];
    
    if (![result isKindOfClass:[NSString class]] || ![result length]) {
        SPLogDebug(@"[HyprMX] Creating new user ID.");
        result = [SPRandomID randomIDString];
        
        [defaults setObject:result forKey:SPHyprMXUserID];
    } else {
        SPLogDebug(@"[HyprMX] Using existing user ID.");
    }
    
    return result;
}


#pragma mark - Public

- (BOOL)startSDK:(NSDictionary *)data
{
    if (self.sdkStarted) {
        SPLogInfo(@"SDK and mediation adapter for HyprMX Provider has already started");
        return YES;
    }
    
    [[HYPRManager sharedManager] initializeWithDistributorId:[[WBAdService sharedAdService] fullpageIdForAdId:WBAdIdHX]
                                                  propertyId:[[WBAdService sharedAdService] fullpageIdForAdId:WBAdIdHXPlacementId]
                                                      userId:self.HyprMXUserID];

    self.sdkStarted = YES;
    return YES;
}


- (void)startRewardedVideoAdapter:(NSDictionary *)data
{
    Class RewardedVideoAdapterClass = NSClassFromString(SPRewardedVideoAdapterClassName);
    if (!RewardedVideoAdapterClass) {
        return;
    }
    
    id<SPRewardedVideoNetworkAdapter> rewardedVideoAdapter = [RewardedVideoAdapterClass new];
    
    SPTPNGenericAdapter *rewardedVideoAdapterWrapper = [[SPTPNGenericAdapter alloc] initWithVideoNetworkAdapter:rewardedVideoAdapter];
    rewardedVideoAdapter.delegate = rewardedVideoAdapterWrapper;
    
    self.rewardedVideoAdapter = rewardedVideoAdapterWrapper;
    
    [super startRewardedVideoAdapter:data];
}

@end
