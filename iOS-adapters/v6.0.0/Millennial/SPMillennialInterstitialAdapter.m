//
//  SPMillenialInterstitialAdapter.m
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 18/02/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPLogger.h"
#import "SPMillennialInterstitialAdapter.h"
#import "SPMillennialNetwork.h"
#import <MillennialMedia/MMRequest.h>
#import <MillennialMedia/MMInterstitial.h>

@interface SPMillennialInterstitialAdapter ()

@property (weak, nonatomic) id<SPInterstitialNetworkAdapterDelegate> delegate;
@property (assign, nonatomic) BOOL adWasTapped;

@end

@implementation SPMillennialInterstitialAdapter

- (BOOL)startAdapterWithDict:(NSDictionary *)dict
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adWasTapped:)
                                                 name:MillennialMediaAdWasTapped
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adModalDidAppear:)
                                                 name:MillennialMediaAdModalDidAppear
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adModalDidDismiss:)
                                                 name:MillennialMediaAdModalDidDismiss
                                               object:nil];
    return YES;
}

- (NSString *)networkName
{
    return [self.network name];
}

- (BOOL)canShowInterstitial
{
    if ([MMInterstitial isAdAvailableForApid:self.network.apid]) {
        return YES;
    } else {
        [self fetchOffer];
        return NO;
    }
}

- (void)showInterstitialFromViewController:(UIViewController *)viewController
{
    if ([MMInterstitial isAdAvailableForApid:self.network.apid]) {
        [MMInterstitial displayForApid:self.network.apid
                    fromViewController:viewController
                       withOrientation:0
                          onCompletion:^(BOOL success, NSError *error) {
                              if (success) {
                                  [self fetchOffer];
                              }
                          }];
    } else {
        [self.delegate adapter:self didFailWithError:[NSError errorWithDomain:@"SPInterstitialDomain" code:-8 userInfo:@{NSLocalizedDescriptionKey: @"No interstitial available"}]];
    }

}

#pragma mark - Private Methods
- (void)fetchOffer
{
    if (![MMInterstitial isAdAvailableForApid:self.network.apid]) {
        MMRequest *request = [MMRequest request];

        [MMInterstitial fetchWithRequest:request apid:self.network.apid onCompletion:^(BOOL success, NSError *error) {
            if (error) {
                [self.delegate adapter:self didFailWithError:error];
            }
        }];
    }
}

#pragma mark - Notifications
- (void)adWasTapped:(NSNotification *)notification
{
    SPLogDebug(@"Millennial ad was tapped");
    self.adWasTapped = YES;
}

- (void)adModalDidAppear:(NSNotification *)notification
{
    SPLogDebug(@"Millennial Ad Did appear");
    self.adWasTapped = NO;
    [self.delegate adapterDidShowInterstitial:self];
}

- (void)adModalDidDismiss:(NSNotification *)notification
{
    SPLogDebug(@"Millennial Ad Did dismiss");
    [self.delegate adapter:self didDismissInterstitialWithReason:(self.adWasTapped ? SPInterstitialDismissReasonUserClickedOnAd : SPInterstitialDismissReasonUserClosedAd)];
}

@end
