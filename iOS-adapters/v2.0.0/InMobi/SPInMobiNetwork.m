//
//  SPInMobiNetwork.m
//  SponsorPay iOS SDK - InMobi Adapter v.2.0.0
//
//  Created by Daniel Barden on 21/01/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPInMobiNetwork.h"
#import "SPInMobiInterstitialAdapter.h"
#import "SPLogger.h"
#import "SPSemanticVersion.h"

NSString *const SPInMobiAppId = @"SPInMobiAppId";

// Adapter versioning - Remember to update the header
static const NSInteger SPInMobiVersionMajor = 2;
static const NSInteger SPInMobiVersionMinor = 0;
static const NSInteger SPInMobiVersionPatch = 0;

@interface SPInMobiNetwork()

@property (strong, nonatomic) SPInMobiInterstitialAdapter *interstitialAdapter;
@property (copy, nonatomic, readwrite) NSString *appId;

@end

@implementation SPInMobiNetwork

@synthesize interstitialAdapter;

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPInMobiVersionMajor minor:SPInMobiVersionMinor patch:SPInMobiVersionPatch];
}

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
