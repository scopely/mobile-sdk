//
//  SPAdMobNetwork.m
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 01/04/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "GADRequest.h"

#import "SPAdMobNetwork.h"
#import "SPAdMobInterstitialAdapter.h"
#import "SPSemanticVersion.h"
#import "SPLogger.h"


// Adapter versioning - Remember to update the header
static const NSInteger SPAdMobVersionMajor = 2;
static const NSInteger SPAdMobVersionMinor = 0;
static const NSInteger SPAdMobVersionPatch = 0;

static NSString *const SPAdMobCoppaCompliance = @"SPAdMobIsCOPPACompliant";

static NSString *const SPAdMobTestDevices = @"SPAdMobTestDevices";

@interface SPAdMobNetwork()

@end

@implementation SPAdMobNetwork

@synthesize interstitialAdapter = _interstitialAdapter;

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPAdMobVersionMajor minor:SPAdMobVersionMinor patch:SPAdMobVersionPatch];
}

- (id)init
{
    self = [super init];
    if (self) {
        _coppaComplicanceStatus = SPAdmobCoppaComplianceUnknown;
        _interstitialAdapter = [[SPAdMobInterstitialAdapter alloc] init];
    }
    return self;
}

- (BOOL)startSDK:(NSDictionary *)data
{
    if (data[SPAdMobCoppaCompliance]) {
        BOOL isCOPPACompliant = [data[SPAdMobCoppaCompliance] boolValue];
        self.coppaComplicanceStatus = isCOPPACompliant ? SPAdmobCoppaComplianceEnabled : SPAdmobCoppaComplianceDisabled;
    }
    self.testDevices = [self processTestDevices:data[SPAdMobTestDevices]];

    return YES;
}

// Checks if GAD_SIMULATOR_ID is contained in the test devices.
// Likely to happen due to AdMob warning message
- (NSArray *)processTestDevices:(NSArray *)testDevices
{
    if (!testDevices) {
        return nil;
    }

    NSUInteger indexOfSimulator = [testDevices indexOfObject:@"GAD_SIMULATOR_ID"];
    if (indexOfSimulator == NSNotFound) {
        return testDevices;
    }

    NSMutableArray *mutableTestDevices = [NSMutableArray arrayWithArray:testDevices];
    mutableTestDevices[indexOfSimulator] = GAD_SIMULATOR_ID;
    return [mutableTestDevices copy];
}
@end
