//
//  SPInMobiNetwork.m
//  Fyber iOS SDK - InMobi Adapter v.2.0.2
//
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPInMobiNetwork.h"
#import "SPInMobiInterstitialAdapter.h"
#import "SPLogger.h"
#import "SPSemanticVersion.h"

NSString *const SPInMobiAppId = @"SPInMobiAppId";

// Adapter versioning - Remember to update the header
static const NSInteger SPInMobiVersionMajor = 2;
static const NSInteger SPInMobiVersionMinor = 0;
static const NSInteger SPInMobiVersionPatch = 2;

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
    self.appId = data[SPInMobiAppId];
    if (!self.appId.length) {
        SPLogError(@"Could not start %@ network. %@ empty or missing.", self.name, SPInMobiAppId);
        return NO;
    }
    
    [InMobi initialize:self.appId];

    return YES;
}

@end
