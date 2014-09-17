//
//  SPProviderFlurry.m
//  SponsorPay iOS SDK - Flurry Adapter v.2.1.0
//
//  Created by Daniel Barden on 02/01/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SponsorPaySDK.h"

#import "SPFlurryNetwork.h"
#import "SPFlurryRewardedVideoAdapter.h"
#import "SPLogger.h"
#import "Flurry.h"
#import "SPSemanticVersion.h"

static NSString *const SPProviderName = @"SPProviderName";
static NSString *const SPFlurryApiKey = @"SPFlurryApiKey";
static NSString *const SPFlurryLogLevel = @"SPFlurryLogLevel";

static NSString *const SPFlurryLogLevelNone = @"none";
static NSString *const SPFlurryLogLevelCriticalOnly = @"criticalOnly";
static NSString *const SPFlurryLogLevelDebug = @"debug";
static NSString *const SPFlurryLogLevelAll = @"all";

// Adapter versioning - Remember to update the header
static const NSInteger SPFlurryVersionMajor = 2;
static const NSInteger SPFlurryVersionMinor = 1;
static const NSInteger SPFlurryVersionPatch = 0;

@interface SPFlurryAppCircleClipsNetwork ()


@property (nonatomic, assign, readwrite) SPNetworkSupport supportedServices;

@property (nonatomic, strong, readwrite) SPFlurryAppCircleClipsRewardedVideoAdapter *rewardedVideoAdapter;
@property (nonatomic, copy, readwrite) NSString *name;

- (FlurryLogLevel)flurryLogLevel:(NSString *)logLevel;

@end

@implementation SPFlurryAppCircleClipsNetwork

@synthesize supportedServices;
@synthesize rewardedVideoAdapter;
@synthesize name;

#pragma mark - Class Methods

+ (SPSemanticVersion *)adapterVersion
{
    return
    [SPSemanticVersion versionWithMajor:SPFlurryVersionMajor minor:SPFlurryVersionMinor patch:SPFlurryVersionPatch];
}


#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];

    if (self) {
        self.rewardedVideoAdapter = [[SPFlurryAppCircleClipsRewardedVideoAdapter alloc] init];
    }

    return self;
}


- (BOOL)startSDK:(NSDictionary *)data
{
//    NSString *apiKey = [self valueFromKeychain:SPFlurryApiKey];
    NSString *apiKey = data[SPFlurryApiKey];
    if (!apiKey.length) {
        SPLogError(@"Could not start %@ Provider. %@ empty or missing.", self.name, SPFlurryApiKey);
        return NO;
    }
    NSString *logLevel = data[SPFlurryLogLevel];
    if (logLevel) {
        [Flurry setLogLevel:[self flurryLogLevel:logLevel]];
    }
    [Flurry startSession:apiKey];
    [Flurry addOrigin:@"SponsorPayIOS" withVersion:[SponsorPaySDK versionString]];

    return YES;
}

#pragma mark - Private

- (FlurryLogLevel)flurryLogLevel:(NSString *)logLevel
{
    if ([logLevel isEqualToString:SPFlurryLogLevelNone]) {
        return FlurryLogLevelNone;
    } else if ([logLevel isEqualToString:SPFlurryLogLevelCriticalOnly]) {
        return FlurryLogLevelCriticalOnly;
    } else if ([logLevel isEqualToString:SPFlurryLogLevelDebug]) {
        return FlurryLogLevelDebug;
    } else if ([logLevel isEqualToString:SPFlurryLogLevelAll]) {
        return FlurryLogLevelAll;
    }
    return FlurryLogLevelCriticalOnly;
}

@end
