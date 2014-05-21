//
//  SPAppiaInterstitialAdapter.m
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 04/12/13.
//  Copyright (c) 2013 SponsorPay. All rights reserved.
//

#import "SPAppiaInterstitialAdapter.h"
#import "SPSystemVersionChecker.h"
#import "SPAppiaNetwork.h"
#import "SPLogger.h"
#import <objc/runtime.h>
#import <AppiaSDK/Appia.h>

static NSString *const SPAppiaPlacementId = @"SPAppiaPlacementIdInterstitial";

// Customizations for AIBannerAd
@interface SPAIBannerAd : AIBannerAd

@property (weak, nonatomic) id<SPAIBannerAdDelegate> delegate;
@end

@implementation SPAIBannerAd

- (void)presentFromMainWindow
{
    [self.delegate bannerDidAppear];
    [super presentFromMainWindow];
}

- (void)dismiss
{
    [super dismiss];
    [self.delegate bannerDidClose];
}

@end

// Adapter implementation
@interface SPAppiaInterstitialAdapter ()
{
    BOOL _shouldRestoreStatusBar;
}

@property (weak, nonatomic) id<SPInterstitialNetworkAdapterDelegate> delegate;
@property (copy, nonatomic) NSString *placementId;
@property (strong, nonatomic) SPAIBannerAd *ad;

@end

@implementation SPAppiaInterstitialAdapter

@synthesize offerData;

# pragma mark - SPInterstitialNetworkAdapter methods
- (BOOL)startAdapterWithDict:(NSDictionary *)dict
{
    NSString *placementId = dict[SPAppiaPlacementId];
    if (!placementId) {
        SPLogError(@"Could not start %@ video Adapter. %@ empty or missing.", self.networkName, SPAppiaPlacementId);
        return NO;
    }

    self.placementId = dict[SPAppiaPlacementId];
    return YES;
}

- (NSString *)networkName
{
    return [self.network name];
}

- (BOOL)canShowInterstitial
{
    if (!self.ad) {
        AIAdParameters *adParameters = [[AIAdParameters alloc] init];
        [adParameters setAppiaParameters:@{@"placementId": self.placementId}];
        SPAIBannerAd *ad = (SPAIBannerAd *)[[AIAppia sharedInstance] createBannerAdWithSize:AIBannerAdFullScreen parameters:adParameters];
        object_setClass(ad, [SPAIBannerAd class]);
        ad.delegate = self;

        self.ad = ad;
    }
    return YES;
}

- (void)showInterstitialFromViewController:(UIViewController *)viewController
{
    if (![UIApplication sharedApplication].statusBarHidden) {
        _shouldRestoreStatusBar = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }

    if (viewController && [SPSystemVersionChecker runningOniOS6OrNewer]) {
        [self.ad useInAppAppStoreWithViewController:viewController];
    }

    [self.ad presentFromMainWindow];
}

#pragma mark - SPAIBannerDelegate Methods
- (void)bannerDidAppear
{
    [self.delegate adapterDidShowInterstitial:self];
}

- (void)bannerDidClose
{
    [self.delegate adapter:self didDismissInterstitialWithReason:SPInterstitialDismissReasonUserClosedAd];
    if (_shouldRestoreStatusBar) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    self.ad = nil;
}

@end
