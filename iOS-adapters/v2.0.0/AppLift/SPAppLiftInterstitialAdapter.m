//
//  SPAppLiftInterstitialAdapter.m
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 20/11/13.
//  Copyright (c) 2013 SponsorPay. All rights reserved.
//

#import "SPAppLiftInterstitialAdapter.h"
#import "SPAppLiftNetwork.h"
#import "SPLogger.h"

//TODO: Define this macro inside SPLogger
#define LogInvocation NSLog(@"%s", __PRETTY_FUNCTION__)

@interface SPAppLiftInterstitialAdapter() {
    BOOL _adLoaded;
}

@property (weak, nonatomic) id<SPInterstitialNetworkAdapterDelegate> delegate;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *securityToken;

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

- (void)startWrappedSDK
{

}

- (void)setParameters:(NSDictionary *)parameters
{
    self.appId = parameters[@"appId"];
    self.securityToken = parameters[@"securityToken"];
}

- (BOOL)canShowInterstitial
{
    LogInvocation;
    if (!_adLoaded) {
        [PlayAdsSDK cache];
    }

    return _adLoaded;
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

- (void)playAdsInterstitialReady
{
    LogInvocation;
    _adLoaded = YES;
}

- (void)playAdsInterstitialDidShown
{
    LogInvocation;
    _adLoaded = NO;
    [self.delegate adapterDidShowInterstitial:self];
}

- (void)playAdsInterstitialDidFailWithError:(NSError*)error
{
    LogInvocation;
    [self.delegate adapter:self didFailWithError:error];
}

- (void)playAdsInterstitialDidClose
{
    LogInvocation;
    [self.delegate adapter:self didDismissInterstitialWithReason:SPInterstitialDismissReasonUserClosedAd];
    [PlayAdsSDK cache];
}

@end
