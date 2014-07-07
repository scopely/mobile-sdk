//
//  SPVungleAdapter.m
//  SponsorPay iOS SDK
//
//  Created by David Davila on 5/30/13.
// Copyright 2011-2013 SponsorPay. All rights reserved.
//

#import "SPVungleRewardedVideoAdapter.h"
#import "SPVungleNetwork.h"
#import "SPLogger.h"

@interface SPVungleRewardedVideoAdapter()

@property (strong) NSString *appId;

@property (assign) SPTPNProviderPlayingState playingState;
@property (assign) BOOL videoDidPlayFull;
@property (copy) SPTPNVideoEventsHandlerBlock videoEventsCallback;

@property (assign) VGStatus lastReportedVungleStatus;

@end

@implementation SPVungleRewardedVideoAdapter

- (BOOL)startAdapterWithDictionary:(NSDictionary *)dict
{
    [VGVunglePub setDelegate:self];
    return YES;
}

- (NSString *)networkName
{
    return self.network.name;
}

- (void)videosAvailable:(SPTPNValidationResultBlock)callback
{
    SPTPNValidationResult validationResult;

    switch(self.lastReportedVungleStatus) {
        case VGStatusNetworkError:
            validationResult = SPTPNValidationNetworkError;
            break;
        case VGStatusDiskError:
            validationResult = SPTPNValidationDiskError;
            break;
        default:
        case VGStatusOkay:
            validationResult = [VGVunglePub adIsAvailable] ? SPTPNValidationSuccess : SPTPNValidationNoVideoAvailable;
            break;
    }

    callback(self.networkName, validationResult);
}

- (void)playVideoWithParentViewController:(UIViewController *)parentVC
                        notifyingCallback:(SPTPNVideoEventsHandlerBlock)eventsCallback
{
    self.videoDidPlayFull = NO;
    self.videoEventsCallback = eventsCallback;
    [VGVunglePub playIncentivizedAd:parentVC animated:YES showClose:NO userTag:nil];
    self.playingState = SPTPNProviderPlayingStateWaitingForPlayStart;
}

#pragma mark - VGVunglePubDelegate protocol implementation

// Called immeddiately before Vungle's ad view controller appears.
// It's the closest we have to the video started event
- (void)vungleViewWillAppear:(UIViewController *)viewController
{
    SPLogDebug(@"%s", __PRETTY_FUNCTION__);
    self.videoEventsCallback(self.networkName, SPTPNVideoEventStarted);
    self.playingState = SPTPNProviderPlayingStatePlaying;
}

// Called when a video ad has finished playing
- (void)vungleMoviePlayed:(VGPlayData *)playData
{
    SPLogDebug(@"%s", __PRETTY_FUNCTION__);

    self.videoDidPlayFull = playData.playedFull;

    SPTPNVideoEvent event = self.videoDidPlayFull ? SPTPNVideoEventFinished : SPTPNVideoEventAborted;
    self.videoEventsCallback(self.networkName, event);
    self.playingState = SPTPNProviderPlayingStateNotPlaying;
}

- (void)vungleViewDidDisappear:(UIViewController *)viewController
{
    SPLogDebug(@"%s", __PRETTY_FUNCTION__);
    if (self.videoDidPlayFull)
        self.videoEventsCallback(self.networkName, SPTPNVideoEventClosed);
}

- (void)vungleStatusUpdate:(VGStatusData *)statusData
{
    self.lastReportedVungleStatus = statusData.status;

    if (self.lastReportedVungleStatus != VGStatusOkay) {
        BOOL isPlayingOrWaitingToPlay =
        self.playingState == SPTPNProviderPlayingStateWaitingForPlayStart
        || self.playingState == SPTPNProviderPlayingStatePlaying;
        if (isPlayingOrWaitingToPlay) {
            self.videoEventsCallback(self.networkName, SPTPNVideoEventError);
        }
    }
}

@end
