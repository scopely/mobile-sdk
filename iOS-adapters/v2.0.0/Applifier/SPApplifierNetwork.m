//
//  SPApplifierProvider.m
//  SponsorPay iOS SDK - Applifier Adapter v.2.0.0
//
//  Created by Daniel Barden on 13/01/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import <ApplifierImpact/ApplifierImpact.h>

#import "SPApplifierNetwork.h"
#import "SPApplifierRewardedVideoAdapter.h"
#import "SPLogger.h"
#import "SPSemanticVersion.h"
#import "SPTPNGenericAdapter.h"

static NSString *const SPApplifierGameId = @"SPApplifierGameId";

// Adapter versioning - Remember to update the header
static const NSInteger SPApplifierVersionMajor = 2;
static const NSInteger SPApplifierVersionMinor = 0;
static const NSInteger SPApplifierVersionPatch = 0;

@interface SPApplifierNetwork()

@property (nonatomic, strong) SPTPNGenericAdapter *rewardedVideoAdapter;

@end

@implementation SPApplifierNetwork

@synthesize rewardedVideoAdapter;

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPApplifierVersionMajor minor:SPApplifierVersionMinor patch:SPApplifierVersionPatch];
}

- (BOOL)startSDK:(NSDictionary *)data
{
    NSString *gameId = data[SPApplifierGameId];

    if (!gameId) {
        SPLogError(@"Could not start %@ Provider. %@ empty or missing.", self.name, SPApplifierGameId);
        return NO;
    }
    
    [[ApplifierImpact sharedInstance] startWithGameId:gameId];
    return YES;
}

- (void)startRewardedVideoAdapter:(NSDictionary *)data
{
    SPApplifierRewardedVideoAdapter *applifierAdapter = [[SPApplifierRewardedVideoAdapter alloc] init];

    SPTPNGenericAdapter *applifierAdapterWrapper = [[SPTPNGenericAdapter alloc] initWithVideoNetworkAdapter:applifierAdapter];
    applifierAdapter.delegate = applifierAdapterWrapper;

    self.rewardedVideoAdapter = applifierAdapterWrapper;

    [super startRewardedVideoAdapter:data];
}

@end
