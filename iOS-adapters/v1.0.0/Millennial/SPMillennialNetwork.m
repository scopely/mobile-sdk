//
//  SPMillennialNetwork.m
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 18/02/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPMillennialNetwork.h"
#import "SPMillennialInterstitialAdapter.h"
#import "SPLogger.h"
#import <MillennialMedia/MMSDK.h>

static NSString *const SPMillennialApId = @"SPMillennialApid";

@interface SPMillennialNetwork()

@property (strong, nonatomic) SPMillennialInterstitialAdapter *interstitialAdapter;

@end

@implementation SPMillennialNetwork

@synthesize interstitialAdapter;

- (id)init
{
    self = [super init];
    if (self) {
        self.interstitialAdapter = [[SPMillennialInterstitialAdapter alloc] init];
    }
    return self;
}

- (BOOL)startSDK:(NSDictionary *)data
{
    NSString *apId = data[SPMillennialApId];
    if (!apId.length) {
        SPLogError(@"Could not start %@ Network. %@ empty or missing.", self.name, SPMillennialApId);
        return NO;
    }
    self.apid = apId;
    [MMSDK initialize];

    return YES;
}

@end
