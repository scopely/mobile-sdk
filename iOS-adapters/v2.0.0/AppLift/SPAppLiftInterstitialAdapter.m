//
//  SPAppLiftInterstitialAdapter.m
//  Fyber iOS SDK - AppLift Adapter v.2.2.1
//
//  Created on 20/11/13.
//  Copyright (c) 2013 Fyber. All rights reserved.
//

#import "SPAppLiftInterstitialAdapter.h"
#import "SPAppLiftNetwork.h"
#import "SPLogger.h"

// TODO: Define this macro inside SPLogger
#define LogInvocation NSLog(@"%s", __PRETTY_FUNCTION__)

@interface SPAppLiftInterstitialAdapter ()

@property (nonatomic, weak) id<SPInterstitialNetworkAdapterDelegate> delegate;
@property (nonatomic, assign) BOOL isInterstitialAvailable;

@end

@implementation SPAppLiftInterstitialAdapter

@synthesize offerData;

#pragma mark - SPInterstitialNetworkAdapter delegate methods
- (BOOL)startAdapterWithDict:(NSDictionary *)dict
{
    return YES;
}

- (NSString *)networkName
{
    return [self.network name];
}

- (BOOL)canShowInterstitial
{
    LogInvocation;
    if (!self.isInterstitialAvailable) {
        [PlayAdsSDK cache];
    }

    return self.isInterstitialAvailable;
}

- (void)showInterstitialFromViewController:(UIViewController *)viewController
{
    LogInvocation;
    [PlayAdsSDK show];
}

#pragma mark - AppLift delegate methods
- (void)playAdsStartDidEnd
{
    [PlayAdsSDK cache];
}

- (void)playAdsAdReady
{
    LogInvocation;
    self.isInterstitialAvailable = YES;
}

- (void)playAdsAdDidShow
{
    LogInvocation;
    self.isInterstitialAvailable = NO;
    [self.delegate adapterDidShowInterstitial:self];
}

- (void)playAdsAdDidFailWithError:(NSError *)error
{
    LogInvocation;
    [self.delegate adapter:self didFailWithError:error];
}

- (void)playAdsAdDidClose
{
    LogInvocation;
    [self.delegate adapter:self didDismissInterstitialWithReason:SPInterstitialDismissReasonUserClosedAd];
    [PlayAdsSDK cache];
}

@end
