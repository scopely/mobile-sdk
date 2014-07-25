//
//  SPHyprMXNetwork.m
//  SponsorPayTestApp
//
//  Created by Pierre Bongen on 22.05.14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

// Adapter versioning - Remember to update the header

#import "SPHyprMXNetwork.h"

// SponsorPay SDK.
#import "SPHyprMXRewardedVideoAdapter.h"
#import "SPLogger.h"
#import "SPRandomID.h"
#import "SPSemanticVersion.h"
#import "SPTPNGenericAdapter.h"

#import <HyprMX/HyprMX.h>


static const NSInteger SPHyprMXVersionMajor = 2;
static const NSInteger SPHyprMXVersionMinor = 0;
static const NSInteger SPHyprMXVersionPatch = 1;

static NSString *const SPHyprMXDistributorID = @"SPHyprMXDistributorID";
static NSString *const SPHyprMXPropertyID = @"SPHyprMXPropertyID";

static NSString *const SPHyprMXUserID = @"SPHyprMXUserID";


@interface SPHyprMXNetwork ()

@property (nonatomic, strong) SPHyprMXRewardedVideoAdapter *HyprMXRewardedVideoAdapter;
@property (nonatomic, copy, readonly) NSString *HyprMXUserID;
@property (nonatomic, strong) id<SPTPNVideoAdapter> rewardedVideoAdapter;

@end


@implementation SPHyprMXNetwork

@synthesize HyprMXRewardedVideoAdapter = HyprMXRewardedVideoAdapter;
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
        SPLogDebug(@"[HYPR] Creating new user ID.");
        result = [SPRandomID randomIDString];

        [defaults setObject:result forKey:SPHyprMXUserID];
    } else {
        SPLogDebug(@"[HYPR] Using existing user ID.");
    }

    return result;
}


#pragma mark - Public

- (BOOL)startSDK:(NSDictionary *)data
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        SPLogError(@"data parameter is nil or not a dictionary.");
        return NO;
    }

    NSString *const distributorID = data[SPHyprMXDistributorID];

    if (![distributorID isKindOfClass:[NSString class]] || ![distributorID length]) {
        SPLogError(@"No or empty value given for key %@.", SPHyprMXDistributorID);

        return NO;
    }


    NSString *const propertyID = data[SPHyprMXPropertyID];

    if (![propertyID isKindOfClass:[NSString class]] || ![propertyID length]) {
        SPLogError(@"No or empty value given for key %@.", SPHyprMXPropertyID);

        return NO;
    }

    [[HYPRManager sharedManager] initializeWithDistributorId:distributorID propertyId:propertyID userId:self.HyprMXUserID];

    return YES;
}


- (void)startRewardedVideoAdapter:(NSDictionary *)data
{
    self.HyprMXRewardedVideoAdapter = [SPHyprMXRewardedVideoAdapter new];

    SPTPNGenericAdapter *const videoAdapterWrapper = [[SPTPNGenericAdapter alloc] initWithVideoNetworkAdapter:self.HyprMXRewardedVideoAdapter];

    self.HyprMXRewardedVideoAdapter.delegate = videoAdapterWrapper;
    self.rewardedVideoAdapter = videoAdapterWrapper;

    [super startRewardedVideoAdapter:data];
}

@end
