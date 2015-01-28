//
//  SPAppLovingInterstitialAdapter.m
//
//  Copyright (c) 2013 Fyber. All rights reserved.
//

#import "SPAppLovinInterstitialAdapter.h"
#import "SPAppLovinNetwork.h"
#import "ALInterstitialAd.h"
#import "SPLogger.h"

#import "ALSdk+SharedSdk.h"

NSString *const SPAppLovinSDKAppKey = @"SPAppLovinSDKAppKey";

@interface SPAppLovinInterstitialAdapter ()

@property (nonatomic, weak, ) id<SPInterstitialNetworkAdapterDelegate> delegate;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, strong) ALAd *lastLoadedAd;
@property (nonatomic, assign) BOOL adWasClicked;

@end

@implementation SPAppLovinInterstitialAdapter

@synthesize offerData;

- (NSString *)appKey
{
    return self.parameters[SPAppLovinSDKAppKey];
}

- (NSString *)networkName
{
    return [self.network name];
}

- (BOOL)startAdapterWithDict:(NSDictionary *)dict
{
    ALSdkSettings *alSDKSettings = [[ALSdkSettings alloc] init];
    alSDKSettings.isVerboseLogging = NO;
    [self cacheInterstitial];
    return YES;
}

- (void)cacheInterstitial
{
    self.lastLoadedAd = nil;

    ALAdService *adService = [[ALSdk sharedSdk] adService];
    [adService loadNextAd:[ALAdSize sizeInterstitial] andNotify:self];
}

- (BOOL)canShowInterstitial
{
    if (!self.lastLoadedAd) {
        [self cacheInterstitial];
        return NO;
    }

    return YES;
}

- (void)showInterstitialFromViewController:(UIViewController *)viewController
{
    self.adWasClicked = NO;

    ALInterstitialAd *interstitialAd = [[ALInterstitialAd alloc] initWithSdk:[ALSdk sharedSdk]];
    [interstitialAd setAdDisplayDelegate:self];
    UIWindow *window = viewController.view.window;
    [interstitialAd showOver:window andRender:self.lastLoadedAd];
}

#pragma mark - ALAdLoadDelegate

- (void)adService:(ALAdService *)adService didLoadAd:(ALAd *)ad;
{
    self.lastLoadedAd = ad;
}

- (void)adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code
{
    if (code == kALErrorCodeNoFill) {
        SPLogDebug(@"AppLovin returned no fill");
        return;
    }

    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"AppLovin returned code %d", code]};
    NSError *error = [NSError errorWithDomain:@"com.sponsorpay.interstitialError" code:code userInfo:userInfo];
    
    [self.delegate adapter:self didFailWithError:error];
}

#pragma mark - ALAdDisplayDelegate

- (void)ad:(ALAd *)ad wasDisplayedIn:(UIView *)view
{
    [self.delegate adapterDidShowInterstitial:self];
}

- (void)ad:(ALAd *)ad wasClickedIn:(UIView *)view;
{
    self.adWasClicked = YES;
}

- (void)ad:(ALAd *)ad wasHiddenIn:(UIView *)view;
{
    SPInterstitialDismissReason reason = self.adWasClicked ? SPInterstitialDismissReasonUserClickedOnAd : SPInterstitialDismissReasonUserClosedAd;

    [self.delegate adapter:self didDismissInterstitialWithReason:reason];

    [self cacheInterstitial];
}

@end
