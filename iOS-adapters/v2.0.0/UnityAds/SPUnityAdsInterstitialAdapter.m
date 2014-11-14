//
//  SPUnityAdsInterstitialAdapter.m
//
//  Created on 10/10/14.
//  Copyright (c) 2013 Fyber. All rights reserved.
//

#import "SPUnityAdsInterstitialAdapter.h"
#import "SPUnityAdsNetwork.h"
#import "SPLogger.h"

static NSString *const SPUnityAdsInterstitialZoneId = @"SPUnityAdsInterstitialZoneId";

@interface SPUnityAdsInterstitialAdapter ()

@property (nonatomic, weak) id<SPInterstitialNetworkAdapterDelegate> delegate;
@property (nonatomic, assign) BOOL userClickedAd;
@property (nonatomic, copy) NSString *zoneId;
@end

@implementation SPUnityAdsInterstitialAdapter

@synthesize offerData;

- (NSString *)networkName
{
    return [self.network name];
}

- (BOOL)startAdapterWithDict:(NSDictionary *)dict
{
    self.zoneId = dict[SPUnityAdsInterstitialZoneId];
    return YES;
}

#pragma mark - SPInterstitialNetworkAdapter protocol
- (BOOL)canShowInterstitial
{
    return [[UnityAds sharedInstance] canShow];
}

- (void)showInterstitialFromViewController:(UIViewController *)viewController
{
    [[UnityAds sharedInstance] setViewController:viewController];
    if (self.zoneId.length) {
        [[UnityAds sharedInstance] setZone:self.zoneId];
    }
    
    [UnityAds sharedInstance].delegate = self;
    BOOL success = [[UnityAds sharedInstance] show];
    SPLogDebug(@"%@", success ? @"Showing Unity Ad" : @"Error showing Unity Ad");
    if (!success) {
        // TODO provide error with the description
        [self.delegate adapter:self didFailWithError:nil];
    }
}

#pragma mark - UnityAdsDelegate protocol

- (void)unityAdsVideoCompleted:(NSString *)rewardItemKey skipped:(BOOL)skipped
{
    SPLogDebug(@"Unity Video completed: %@", skipped ? @"skipped" : @"watched");
}

- (void)unityAdsDidShow
{
    [self.delegate adapterDidShowInterstitial:self];
}

- (void)unityAdsWillLeaveApplication
{
    self.userClickedAd = YES;
}

- (void)unityAdsDidHide
{
    SPInterstitialDismissReason dismissReason = self.userClickedAd ? SPInterstitialDismissReasonUserClickedOnAd : SPInterstitialDismissReasonUserClosedAd;
    [self.delegate adapter:self didDismissInterstitialWithReason:dismissReason];
}

@end
