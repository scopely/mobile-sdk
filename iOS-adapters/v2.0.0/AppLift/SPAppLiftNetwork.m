//
//  SPAppLiftNetwork.m
//  Fyber iOS SDK - AppLift Adapter v.2.2.1
//
//  Created on 14/01/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
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
static const NSInteger SPAppLiftVersionMinor = 2;
static const NSInteger SPAppLiftVersionPatch = 1;

@interface SPAppLiftNetwork ()

@property (nonatomic, strong, readonly) SPAppLiftInterstitialAdapter *interstitialAdapter;

@end


@implementation SPAppLiftNetwork {
    @private

    SPAppLiftInterstitialAdapter *interstitialAdapter;
}

@synthesize interstitialAdapter = interstitialAdapter;

#pragma mark - Class Methods

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion versionWithMajor:SPAppLiftVersionMajor minor:SPAppLiftVersionMinor patch:SPAppLiftVersionPatch];
}


#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        self->interstitialAdapter = [[SPAppLiftInterstitialAdapter alloc] init];
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
    
    if( NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_6_0){
        SPLogError(@"AppLift only supports iOS 6 or later");
        return NO;
    }

    NSAssert([self.interstitialAdapter isKindOfClass:[SPAppLiftInterstitialAdapter class]],
             @"Expecting a valid interstitial adapter kind of class %@.",
             NSStringFromClass([SPAppLiftInterstitialAdapter class]));

    [PlayAdsSDK startWithAppID:appId secretToken:secretToken delegate:self.interstitialAdapter];

    return YES;
}

#pragma mark NSObject: Creating, Copying, and Deallocating Objects

- (void)dealloc
{
    // This will reset the PlayAdsSDK's delegate.
    [PlayAdsSDK setDelegate:nil];
}

@end
