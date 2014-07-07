//
//  SPAppiaProvider.m
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 14/01/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPLogger.h"
#import "SPAppiaNetwork.h"
#import "SPAppiaInterstitialAdapter.h"
#import <AppiaSDK/Appia.h>

static NSString *const SPAppiaSiteId = @"SPAppiaSiteId";

@interface SPAppiaNetwork()

@property (nonatomic, strong) SPAppiaInterstitialAdapter *interstitialAdapter;

@end

@implementation SPAppiaNetwork

@synthesize interstitialAdapter;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.interstitialAdapter = [[SPAppiaInterstitialAdapter alloc] init];
    }
    return self;
}

- (BOOL)startSDK:(NSDictionary *)data
{
    NSString *siteId = data[SPAppiaSiteId];

    if (!siteId.length) {
        SPLogError(@"Could not start %@ Provider. %@ empty or missing.", self.name, SPAppiaSiteId);
        return NO;
    }

    AIAppia *appia = [AIAppia sharedInstance];
    appia.siteId = siteId;
    return YES;
}

@end
