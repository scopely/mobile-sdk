//
//  SPProviderFlurry.m
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 02/01/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPFlurryNetwork.h"
#import "SPFlurryRewardedVideoAdapter.h"
#import "SPLogger.h"
#import "Flurry.h"

static NSString *const SPProviderName = @"SPProviderName";
static NSString *const SPFlurryApiKey = @"SPFlurryApiKey";

#pragma mark - Class Extension Category
@interface SPFlurryNetwork()

@property (nonatomic, assign, readwrite) SPNetworkSupport supportedServices;

@property (nonatomic, strong, readwrite) SPFlurryRewardedVideoAdapter *rewardedVideoAdapter;
@property (nonatomic, copy, readwrite) NSString *name;

@end

#pragma mark - Class Implementation
@implementation SPFlurryNetwork

@synthesize supportedServices;
@synthesize rewardedVideoAdapter;
@synthesize name;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rewardedVideoAdapter = [[SPFlurryRewardedVideoAdapter alloc] init];
    }
    return self;
}

- (BOOL)startSDK:(NSDictionary *)data
{
    //TODO: Remove it once we have a better idea about how to implement video + interstitials with Flurry. The provider probably won't be the same.
    self.name = @"flurryappcircleclips";
    NSString *apiKey = data[SPFlurryApiKey];
    if (!apiKey.length) {
        SPLogError(@"Could not start %@ Provider. %@ empty or missing.", self.name, SPFlurryApiKey);
        return NO;
    }
    [Flurry startSession:apiKey];

    return YES;
}

@end
