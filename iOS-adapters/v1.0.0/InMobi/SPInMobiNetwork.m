//
//  SPInMobiNetwork.m
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 21/01/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPInMobiNetwork.h"
#import "SPInMobiInterstitialAdapter.h"
#import "SPLogger.h"

NSString *const SPInMobiAppId = @"SPInMobiAppId";

@interface SPInMobiNetwork()

@property (strong, nonatomic) SPInMobiInterstitialAdapter *interstitialAdapter;
@property (copy, nonatomic, readwrite) NSString *appId;

@end

@implementation SPInMobiNetwork

@synthesize interstitialAdapter;

- (id)init
{
    self = [super init];
    if (self) {
        self.interstitialAdapter = [[SPInMobiInterstitialAdapter alloc] init];
    }
    return self;
}

- (BOOL)startSDK:(NSDictionary *)data
{
    NSString *appId = data[SPInMobiAppId];
    if (!appId.length) {
        SPLogError(@"Could not start %@ network. %@ empty or missing.", self.name, SPInMobiAppId);
        return NO;
    }
    self.appId = appId;
    [InMobi initialize:self.appId];

    return YES;
}

@end
