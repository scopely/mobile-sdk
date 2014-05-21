//
//  SPVungleProvider.m
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 13/01/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import <vunglepub/vunglepub.h>

#import "SPVungleNetwork.h"
#import "SPVungleRewardedVideoAdapter.h"
#import "SPLogger.h"
#import "SPSemanticVersion.h"

static NSString *const SPVungleAppId = @"SPVungleAppId";

// Adapter versioning - Remember to update the header
static const NSInteger SPVungleVersionMajor = 2;
static const NSInteger SPVungleVersionMinor = 0;
static const NSInteger SPVungleVersionPatch = 0;

@interface SPVungleNetwork()

@property (nonatomic, assign) SPNetworkSupport supportedServices;
@property (nonatomic, copy) NSString *providerName;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, strong) SPVungleRewardedVideoAdapter *rewardedVideoAdapter;

@end

@implementation SPVungleNetwork

@synthesize supportedServices;
@synthesize rewardedVideoAdapter;

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPVungleVersionMajor minor:SPVungleVersionMinor patch:SPVungleVersionPatch];
}

- (instancetype)init
{
    self =[super init];
    if (self) {
        self.rewardedVideoAdapter = [[SPVungleRewardedVideoAdapter alloc] init];
    }
    return self;
}

- (BOOL)startSDK:(NSDictionary *)data
{
    NSString *appId = data[SPVungleAppId];

    if (!appId.length) {
        SPLogError(@"Could not start %@ Provider. %@ empty or missing.", self.name, SPVungleAppId);
        return NO;
    }

    self.appId = data[SPVungleAppId];
    [VGVunglePub startWithPubAppID:self.appId];
    return YES;
}

@end
