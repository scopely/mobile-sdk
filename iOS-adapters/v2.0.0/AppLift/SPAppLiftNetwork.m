//
//  SPAppLiftProvider.m
//  SponsorPay iOS SDK - AppLift Adapter v.2.0.0
//
//  Created by Daniel Barden on 14/01/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPAppLiftNetwork.h"
#import "SPLogger.h"
#import "SPAppLiftInterstitialAdapter.h"
#import "PlayAdsSDK.h"
#import "SPSemanticVersion.h"

// Parsed keys from the configuration
static NSString *const SPAppLiftAppId = @"SPAppLiftAppId";
static NSString *const SPAppLiftSecretToken = @"SPAppLiftSecretToken";

// Adapter versioning - Remember to update the header
static const NSInteger SPAppLiftVersionMajor = 2;
static const NSInteger SPAppLiftVersionMinor = 0;
static const NSInteger SPAppLiftVersionPatch = 0;

@interface SPAppLiftNetwork()

@property (nonatomic, strong) SPAppLiftInterstitialAdapter *interstitialAdapter;

@end

@implementation SPAppLiftNetwork

@synthesize interstitialAdapter;

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPAppLiftVersionMajor minor:SPAppLiftVersionMinor patch:SPAppLiftVersionPatch];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.interstitialAdapter = [[SPAppLiftInterstitialAdapter alloc] init];
    }
    return self;
}

- (BOOL)startSDK:(NSDictionary *)data
{
    NSString *appId = data[SPAppLiftAppId];
    NSString *secretToken = data[SPAppLiftSecretToken];

    if (!appId.length || !secretToken.length) {
        SPLogError(@"Could not start %@ Provider. %@ or %@ empty or missing.", self.name, SPAppLiftAppId, SPAppLiftSecretToken);
        return NO;
    }
    [PlayAdsSDK startPlayAdsSDKForApp:appId secretToken:secretToken];

    return YES;
}

@end
