//
//  SPFlurryAdapter.m
//  SponsorPay iOS SDK
//
//  Created by David Davila on 6/17/13.
// Copyright 2011-2013 SponsorPay. All rights reserved.
//

#import "SPFlurryRewardedVideoAdapter.h"
#import "SPFlurryNetwork.h"
#import "SPLogger.h"

#import "FlurryAds.h"
static const NSInteger kFlurryNoAdsErrorCode = 104;
static NSString *const SPFlurryVideoAdSpace = @"SPFlurryAdSpaceVideo";

@interface SPFlurryRewardedVideoAdapter()

@property (nonatomic, copy) NSString *videoAdsSpace;
@property (copy) SPTPNValidationResultBlock validationResultsBlock;

@property (copy) SPTPNVideoEventsHandlerBlock videoEventsCallback; // TODO: move up
@property (assign, nonatomic) SPTPNProviderPlayingState playingState; // TODO: move up

@property (assign) BOOL playingDidTimeout;
@property (weak, readonly, nonatomic) UIWindow *mainWindow;

@end

@implementation SPFlurryRewardedVideoAdapter

- (BOOL)startAdapterWithDictionary:(NSDictionary *)dict
{
    NSString *videoAdSpace = dict[SPFlurryVideoAdSpace];
    if (!videoAdSpace) {
        SPLogError(@"Could not start %@ video Adapter. %@ empty or missing.", self.networkName, SPFlurryVideoAdSpace);
        return NO;
    }

    self.videoAdsSpace = dict[SPFlurryVideoAdSpace];
    [FlurryAds initialize:self.mainWindow.rootViewController];
#ifdef FLURRY_TEST_ADS_ENABLED
#warning Flurry Test Ads enabled
    [FlurryAds enableTestAds:YES];
#endif
    [FlurryAds setAdDelegate:self];

    return YES;
}

- (NSString *)networkName
{
    return self.network.name;
}

- (void)videosAvailable:(SPTPNValidationResultBlock)callback
{
    if ([FlurryAds adReadyForSpace:self.videoAdsSpace]) {
        self.validationResultsBlock = nil;
        callback(self.networkName, SPTPNValidationSuccess);
    } else {
        self.validationResultsBlock = callback;
        [self fetchFlurryAd];
        [self startValidationTimeoutChecker];
    }
}

- (void)fetchFlurryAd
{
    [FlurryAds fetchAdForSpace:self.videoAdsSpace
                         frame:self.mainWindow.rootViewController.view.frame
                          size:FULLSCREEN];
}

- (void)startValidationTimeoutChecker
{
    void(^timeoutBlock)(void) = ^(void) {
        if (self.validating) {
            [self notifyOfValidationResult:SPTPNValidationTimeout];
        }
    };
    // TODO: move up
    double delayInSeconds = SPTPNTimeoutInterval;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), timeoutBlock);
}


- (void)playVideoWithParentViewController:(UIViewController *)parentVC
                        notifyingCallback:(SPTPNVideoEventsHandlerBlock)eventsCallback
{
    self.videoEventsCallback = eventsCallback;
    self.playingState = SPTPNProviderPlayingStateWaitingForPlayStart;

    // According to the documentation, the view is not used by the Flurry SDK, but setting to nil causes an exception
    UIView *topView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
    [FlurryAds displayAdForSpace:self.videoAdsSpace onView:topView];

    [self startPlayingTimeoutChecker];
}

- (void)startPlayingTimeoutChecker
{
    self.playingDidTimeout = NO;

    void(^timeoutBlock)(void) = ^(void) {
        if (self.playingState == SPTPNProviderPlayingStateWaitingForPlayStart) {
            self.playingDidTimeout = YES;
            self.playingState = SPTPNProviderPlayingStateNotPlaying;
            self.videoEventsCallback(self.networkName, SPTPNVideoEventTimeout);
        }
    };

    double delayInSeconds = SPTPNTimeoutInterval;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), timeoutBlock);
}

- (UIWindow *)mainWindow
{
    return [UIApplication sharedApplication].windows[0];
}

#pragma mark - FlurryAdDelegate protocol implementation

- (void)spaceDidReceiveAd:(NSString*)adSpace
{
    if ([self isThisAdSpace:adSpace])
        if (self.validating)
            [self notifyOfValidationResult:SPTPNValidationSuccess];
}

- (void)spaceDidFailToReceiveAd:(NSString *)adSpace error:(NSError *)error
{
    if ([self isThisAdSpace:adSpace]) {
        SPLogDebug(@"Flurry's callback invoked: %s %@", __PRETTY_FUNCTION__, error);

        if (self.validating) {
            SPTPNValidationResult validationResult =
            (error.code == kFlurryNoAdsErrorCode ? SPTPNValidationNoVideoAvailable : SPTPNValidationError);
            [self notifyOfValidationResult:validationResult];
        }
    }
}

- (BOOL)spaceShouldDisplay:(NSString *)adSpace interstitial:(BOOL)interstitial
{
    if ([self isThisAdSpace:adSpace]) {
        if (self.playingDidTimeout) {
            return NO;
        } else {
            self.playingState = SPTPNProviderPlayingStatePlaying;
            self.videoEventsCallback(self.networkName, SPTPNVideoEventStarted);
            return YES;
        }
    }

    return YES;
}

- (void)spaceDidFailToRender:(NSString *)adSpace error:(NSError *)error
{
    SPLogError(@"Flurry failed to render ad: %@", [error localizedDescription]);
    if ([self isThisAdSpace:adSpace])
        if (self.playingState != SPTPNProviderPlayingStateNotPlaying)
            self.videoEventsCallback(self.networkName, SPTPNVideoEventError);
}

- (void)videoDidFinish:(NSString *)adSpace
{
    if (self.playingState == SPTPNProviderPlayingStatePlaying) {
        self.playingState = SPTPNProviderPlayingStateNotPlaying;
        self.videoEventsCallback(self.networkName, SPTPNVideoEventFinished);
    }
}

- (void)spaceDidDismiss:(NSString *)adSpace interstitial:(BOOL)interstitial
{
    if (self.playingState == SPTPNProviderPlayingStatePlaying) {
        self.playingState = SPTPNProviderPlayingStateNotPlaying;
        self.videoEventsCallback(self.networkName, SPTPNVideoEventAborted);
    } else {
        self.videoEventsCallback(self.networkName, SPTPNVideoEventClosed);
    }
}

#pragma mark -

- (BOOL)validating
{
    return self.validationResultsBlock != nil;
}

- (void)notifyOfValidationResult:(SPTPNValidationResult)result
{
    if (self.validationResultsBlock) {
        self.validationResultsBlock(self.networkName, result);
        self.validationResultsBlock = nil;
    }
}

- (BOOL)isThisAdSpace:(NSString *)adSpace
{
    return [self.videoAdsSpace isEqualToString:adSpace];
}

@end
