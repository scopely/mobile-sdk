//
//  SPInMobiInterstitialAdapter.m
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 21/01/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPInMobiInterstitialAdapter.h"
#import "SPInMobiNetwork.h"
#import "IMInterstitial.h"
#import "IMInterstitialDelegate.h"
#import "SPLogger.h"

@interface SPInMobiInterstitialAdapter() <IMInterstitialDelegate>
@property (copy, nonatomic) NSString *networkName;
@property (weak, nonatomic) id<SPInterstitialNetworkAdapterDelegate> delegate;

@property (assign, nonatomic, getter = isInterstitialAvailable) BOOL interstitialAvailable;
@property (strong, nonatomic) IMInterstitial *interstitial;

@property (assign, nonatomic) BOOL userClickedAd;

@end

@implementation SPInMobiInterstitialAdapter

#pragma mark - Lifecycle

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - SPInterstitialNetworkAdapter Delegate methods

- (BOOL)startAdapterWithDict:(NSDictionary *)dict
{
    [self fetchInterstitial];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    return YES;
}

- (BOOL)canShowInterstitial
{
    if (!self.interstitialAvailable) {
        [self fetchInterstitial];
    }
    return self.interstitialAvailable;
}

- (void)showInterstitialFromViewController:(UIViewController *)viewController
{
    [self.interstitial presentInterstitialAnimated:YES];
}

- (void)fetchInterstitial
{
    SPLogDebug(@"%s: Fetching interstitial from InMobi", __PRETTY_FUNCTION__);
    IMInterstitial *interstitial = [[IMInterstitial alloc] initWithAppId:self.network.appId];
    interstitial.delegate = self;
    [interstitial loadInterstitial];
    self.interstitial = interstitial;
}
#pragma mark - IMInterstitial Delegate methods
- (void)interstitialDidReceiveAd:(IMInterstitial *)ad
{
    self.interstitialAvailable = YES;
    SPLogInfo(@"%s: Received Interstitial from InMobi", __PRETTY_FUNCTION__);
}

- (void)interstitial:(IMInterstitial *)ad
        didFailToReceiveAdWithError:(IMError *)error
{
    self.interstitialAvailable = NO;
    ad.delegate = nil;
    self.interstitial = nil;
    [self.delegate adapter:self didFailWithError:error];
    SPLogError(@"%s %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}

- (void)interstitialWillPresentScreen:(IMInterstitial *)ad
{
    [self.delegate adapterDidShowInterstitial:self];
    self.interstitialAvailable = NO;
}

- (void)interstitialDidDismissScreen:(IMInterstitial *)ad
{
    if (!self.userClickedAd) {
        [self.delegate adapter:self didDismissInterstitialWithReason:SPInterstitialDismissReasonUserClosedAd];
        [self fetchInterstitial];
    }
}

- (void)interstitialWillLeaveApplication:(IMInterstitial *)ad
{
    [self.delegate adapter:self didDismissInterstitialWithReason:SPInterstitialDismissReasonUserClickedOnAd];
    self.userClickedAd = YES;
}

- (void)interstitial:(IMInterstitial *)ad didFailToPresentScreenWithError:(IMError *)error
{
    [self.delegate adapter:self didFailWithError:error];
    SPLogError(@"%s %@", __PRETTY_FUNCTION__, [error localizedDescription]);
}

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    if (self.userClickedAd) {
        [self fetchInterstitial];
        self.userClickedAd = NO;
    }
}

@end
