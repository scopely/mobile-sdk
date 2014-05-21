//
//  SPAppiaProvider.m
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 14/01/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import <AppiaSDK/Appia.h>

#import "SPAppiaNetwork.h"
#import "SPAppiaInterstitialAdapter.h"
#import "SPLogger.h"
#import "SPSemanticVersion.h"


static NSString *const SPAppiaSiteId = @"SPAppiaSiteId";

// Adapter versioning - Remember to update the header
static const NSInteger SPAppiaVersionMajor = 2;
static const NSInteger SPAppiaVersionMinor = 0;
static const NSInteger SPAppiaVersionPatch = 0;

@interface SPAppiaNetwork()

@property (nonatomic, strong) SPAppiaInterstitialAdapter *interstitialAdapter;

@end

@implementation SPAppiaNetwork

@synthesize interstitialAdapter;

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPAppiaVersionMajor minor:SPAppiaVersionMinor patch:SPAppiaVersionPatch];
}

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
