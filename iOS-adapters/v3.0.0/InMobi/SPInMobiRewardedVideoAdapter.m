//
//  SPInMobiRewardedVideoAdapter.m
//
//  Created on 05.11.14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPInMobiRewardedVideoAdapter.h"
#import "SPInMobiNetwork.h"
#import "SPLogger.h"
#import "IMInterstitial.h"
#import "IMInterstitialDelegate.h"
#import "SponsorPaySDK.h"

static NSString *const kSPInMobiRewardedVideoErrorDomain = @"SPInmobiRewardedVideoErrorDomain";
static const NSInteger kSPInMobiRewardedVideoNotReadyErrorCode = -1;

@interface SPInMobiRewardedVideoAdapter () <IMInterstitialDelegate, IMIncentivisedDelegate>
@property (nonatomic, strong) IMInterstitial *incentivisedAd;
@property (nonatomic, assign) BOOL wasVideoFullyWatched;
@end

@implementation SPInMobiRewardedVideoAdapter

@synthesize delegate;

- (NSString *)networkName
{
    return self.network.name;
}

- (void)checkAvailability
{
    SPUser *user = [[SponsorPaySDK instance] user];
    CLLocation *userLocation = user.location;
    if (userLocation) {
        [InMobi setLocationWithLatitude:userLocation.coordinate.latitude
                              longitude:userLocation.coordinate.longitude
                               accuracy:userLocation.horizontalAccuracy];
    }
    
    if (!self.incentivisedAd || self.incentivisedAd.state == kIMInterstitialStateUnknown ||
        self.incentivisedAd.state == kIMInterstitialStateInit) {
        [self fetchIncentivisedInterstitial];
    } else if (self.incentivisedAd.state == kIMInterstitialStateReady) {
        [self.delegate adapter:self didReportVideoAvailable:YES];
    }
}

- (void)playVideoWithParentViewController:(UIViewController *)parentVC
{
    if (self.incentivisedAd.state == kIMInterstitialStateReady) {
        self.wasVideoFullyWatched = NO;
        [self.incentivisedAd presentInterstitialAnimated:YES];
    } else {
        [self.delegate adapter:self
              didFailWithError:[NSError errorWithDomain:kSPInMobiRewardedVideoErrorDomain
                                                   code:kSPInMobiRewardedVideoNotReadyErrorCode
                                               userInfo:@{
                                                   NSLocalizedDescriptionKey: @"InMobi rewarder video is not ready"
                                               }]];
    }
}

- (BOOL)startAdapterWithDictionary:(NSDictionary *)dict
{
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_6_0) {
        SPLogError(@"InMobi Rewarded videos require iOS 6 or later");
        return NO;
    }

    if (!self.network.rewardedVideoPropertyId.length || ![self.network.rewardedVideoPropertyId isKindOfClass:[NSString class]]) {
        SPLogError(@"SPInMobiRewardedVideoPropertyId missing or empty");
        return NO;
    }

    return YES;
}

- (void)fetchIncentivisedInterstitial
{
    IMInterstitial *incentivisedAd = [[IMInterstitial alloc] initWithAppId:self.network.rewardedVideoPropertyId];
    incentivisedAd.delegate = self;
    incentivisedAd.incentivisedDelegate = self;
    [incentivisedAd setAdditionaParameters:self.network.additionalParameters];
    [incentivisedAd loadInterstitial];
    self.incentivisedAd = incentivisedAd;
}

- (void)interstitialDidReceiveAd:(IMInterstitial *)ad
{
    [self.delegate adapter:self didReportVideoAvailable:YES];
}

- (void)interstitial:(IMInterstitial *)ad didFailToReceiveAdWithError:(IMError *)error
{
    SPLogError(@"InMobi error: %@", error.debugDescription);
    if (error.code == kIMErrorNoFill) {
        [self.delegate adapter:self didReportVideoAvailable:NO];
    } else {
        [self.delegate adapter:self didFailWithError:error];
    }
}

- (void)interstitialWillPresentScreen:(IMInterstitial *)ad
{
    [self.delegate adapterVideoDidStart:self];
}

- (void)interstitialDidDismissScreen:(IMInterstitial *)ad
{
    if (self.wasVideoFullyWatched) {
        [self.delegate adapterVideoDidClose:self];
    } else {
        [self.delegate adapterVideoDidAbort:self];
    }
    [self fetchIncentivisedInterstitial];
}

- (void)interstitial:(IMInterstitial *)ad didFailToPresentScreenWithError:(IMError *)error
{
    SPLogError(@"InMobi error: %@", error.debugDescription);
    [self.delegate adapter:self didFailWithError:error];
}

- (void)incentivisedAd:(IMInterstitial *)ad didCompleteWithParams:(NSDictionary *)params
{
    self.wasVideoFullyWatched = YES;
    [self.delegate adapterVideoDidFinish:self];
}

- (void)dealloc
{
    self.incentivisedAd.delegate = nil;
    self.incentivisedAd.incentivisedDelegate = nil;
}
@end
