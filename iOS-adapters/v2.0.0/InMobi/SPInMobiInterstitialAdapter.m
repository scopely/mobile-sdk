//
//  SPInMobiInterstitialAdapter.m
//
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPInMobiInterstitialAdapter.h"
#import "SPInMobiNetwork.h"
#import "IMInterstitial.h"
#import "IMInterstitialDelegate.h"
#import "SPLogger.h"
#import "SponsorPaySDK.h"

static NSString *const kInMobiThirdPartyParameter  = @"tp";
static NSString *const kInMobiThirdPartyVersionParameter  = @"tp-ver";
static NSString *const kInMobiThirdPartyParameterValue  = @"c_sponsorpay";

@interface SPInMobiInterstitialAdapter() <IMInterstitialDelegate>
@property (nonatomic, copy) NSString *networkName;
@property (nonatomic, weak) id<SPInterstitialNetworkAdapterDelegate> delegate;

@property (nonatomic, assign, getter=isInterstitialAvailable) BOOL interstitialAvailable;
@property (nonatomic, strong) IMInterstitial *interstitial;

@property (nonatomic, assign) BOOL userClickedAd;

// In cases when InMobi uses StoreKit, it uses the current interstitial as the delegate.
// But to maximize the fill rate, we are requesting another interstitial when the current one
// is dismissed, which causes the delegate of StoreKit to be niled and the user trapped.
// This property will hold a reference to the last interstitial provided, since the API
// does not provide any clue about what happening regarding StoreKit
@property (nonatomic, strong) IMInterstitial *dismissedInterstitial;

@end

@implementation SPInMobiInterstitialAdapter

@synthesize offerData;

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
    
    NSDictionary *additionalParameters = @{kInMobiThirdPartyParameter: kInMobiThirdPartyParameterValue, kInMobiThirdPartyVersionParameter: [SponsorPaySDK versionString]};
    
    [interstitial setAdditionaParameters:additionalParameters];
    [interstitial loadInterstitial];
    self.interstitial = interstitial;
}

#pragma mark - IMInterstitial Delegate methods
- (void)interstitialDidReceiveAd:(IMInterstitial *)ad
{
    self.interstitialAvailable = YES;
    SPLogDebug(@"%s: Received Interstitial from InMobi", __PRETTY_FUNCTION__);
}

- (void)interstitial:(IMInterstitial *)ad didFailToReceiveAdWithError:(IMError *)error
{
    self.interstitialAvailable = NO;
    ad.delegate = nil;
    self.interstitial = nil;
    if (error.code == kIMErrorNoFill) {
        SPLogInfo(@"%s %@", __PRETTY_FUNCTION__, [error localizedDescription]);
    } else {
        [self.delegate adapter:self didFailWithError:error];
        SPLogError(@"%s %@", __PRETTY_FUNCTION__, [error localizedDescription]);
    }
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
        self.dismissedInterstitial = ad;
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

#pragma mark - NSNotifications

- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    if (self.userClickedAd) {
        [self fetchInterstitial];
        self.userClickedAd = NO;
    }
}

@end
