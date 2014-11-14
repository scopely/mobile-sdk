//
//  SPUnityAdsRewardedVideoAdapter.m
//
//  Created on 10/1/13.
//  Copyright (c) 2013 Fyber. All rights reserved.
//

#import "SPUnityAdsRewardedVideoAdapter.h"
#import "SPUnityAdsNetwork.h"
#import "SPLogger.h"

static NSString *const SPUnityAdsShowOffers = @"SPUnityAdsShowOffers";
static NSString *const SPUnityAdsRewardedVideoZoneId = @"SPUnityAdsRewardedVideoZoneId";

@interface SPUnityAdsRewardedVideoAdapter ()

@property (nonatomic, assign) BOOL videoFullyWatched;
@property (nonatomic, strong) NSMutableDictionary *showOptions;
@property (nonatomic, copy) NSString *zoneId;

@end

@implementation SPUnityAdsRewardedVideoAdapter

@synthesize delegate = _delegate;

- (NSString *)networkName
{
    return self.network.name;
}

- (BOOL)startAdapterWithDictionary:(NSDictionary *)dict
{
    self.zoneId = dict[SPUnityAdsRewardedVideoZoneId];
    if (self.zoneId.length == 0) {
        self.zoneId = nil;
    }

    self.showOptions = [[NSMutableDictionary alloc] initWithDictionary:@{
        kUnityAdsOptionVideoUsesDeviceOrientation: @YES,
        kUnityAdsOptionNoOfferscreenKey: @YES
    }];

    // It seems that kUnityAdsOptionNoOfferscreenKey option doesn't work anymore, but it wasn't removed from code, because this parameter is still available in UnityAds API.
    if (dict[SPUnityAdsShowOffers]) {
        BOOL hideOffers = ![dict[SPUnityAdsShowOffers] boolValue];
        self.showOptions[kUnityAdsOptionNoOfferscreenKey] = @(hideOffers);
    }

    return YES;
}

- (void)checkAvailability
{
    BOOL videoAvailable = [[UnityAds sharedInstance] canShow];
    [self.delegate adapter:self didReportVideoAvailable:videoAvailable];
}

- (void)playVideoWithParentViewController:(UIViewController *)parentVC
{
    [[UnityAds sharedInstance] setViewController:parentVC];
    if (self.zoneId.length) {
        [[UnityAds sharedInstance] setZone:self.zoneId];
    }
    [UnityAds sharedInstance].delegate = self;

    BOOL success = [[UnityAds sharedInstance] show:self.showOptions];
    SPLogDebug(@"%@", success ? @"Showing Unity Rewarded Video" : @"Error showing Unity Rewarded Video");
    if (!success) {
        // TODO provide error with the description
        [self.delegate adapter:self didFailWithError:nil];
    }
}

#pragma mark - UnityAdsDelegate selectors

- (void)unityAdsFetchCompleted
{
    SPLogInfo(@"UnityAds campaigns available");
}

- (void)unityAdsFetchFailed
{
    [self.delegate adapter:self didFailWithError:nil]; // TODO provide a meaningful error
}

- (void)unityAdsVideoStarted
{
    [self.delegate adapterVideoDidStart:self];
}

- (void)unityAdsVideoCompleted:(NSString *)rewardItemKey skipped:(BOOL)skipped
{
    if (skipped) {
        [self.delegate adapterVideoDidAbort:self];
        return;
    }

    self.videoFullyWatched = YES;
    [self.delegate adapterVideoDidFinish:self];
}

- (void)unityAdsDidHide
{
    if (self.videoFullyWatched) {
        [self.delegate adapterVideoDidClose:self];
    } else {
        [self.delegate adapterVideoDidAbort:self];
    }
    self.videoFullyWatched = NO;
}

@end
