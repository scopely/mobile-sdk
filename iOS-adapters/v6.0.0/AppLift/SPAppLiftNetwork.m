//
//  SPAppLiftProvider.m
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 14/01/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPAppLiftNetwork.h"
#import "SPLogger.h"
#import "SPAppLiftInterstitialAdapter.h"
#import "PlayAdsSDK.h"

static NSString *const SPAppLiftAppId = @"SPAppLiftAppId";
static NSString *const SPAppLiftSecretToken = @"SPAppLiftSecretToken";

@interface SPAppLiftNetwork()

@property (nonatomic, strong) SPAppLiftInterstitialAdapter *interstitialAdapter;

@end

@implementation SPAppLiftNetwork

@synthesize interstitialAdapter;

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
