//
//  SPHyprMXRewardedVideoAdapter.m
//
//  Created on 22.05.14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPHyprMXRewardedVideoAdapter.h"
#import "SPHyprMXNetwork.h"
#import "SPLogger.h"
#import "HyprMX.h"

#ifndef LogInvocation
#define LogInvocation SPLogDebug(@"%s", __PRETTY_FUNCTION__)
#endif

@interface SPHyprMXRewardedVideoAdapter()

@property (nonatomic, assign, getter = isOfferReady) BOOL offerReady;

@end

@implementation SPHyprMXRewardedVideoAdapter

@synthesize delegate;

- (NSString *)networkName
{
    return self.network.name;
}

- (void)checkAvailability
{
    LogInvocation;
    
    [[HYPRManager sharedManager] checkInventory:^(BOOL isOfferReady) {
        self.offerReady = isOfferReady;
        [self.delegate adapter:self didReportVideoAvailable:isOfferReady];
        if (isOfferReady) {
            SPLogDebug(@"[HyprMX] HyprMX reported that offer is ready for display.");
        }
        else {
            SPLogWarn(@"[HyprMX] HyprMX reported that offer cannot be displayed.");
        }
    }];
}

- (void)playVideoWithParentViewController:(UIViewController *)parentVC
{
    LogInvocation;
    
    if (self.isOfferReady) {
        [self.delegate adapterVideoDidStart:self];
        [[HYPRManager sharedManager] displayOffer:^(BOOL completed, HYPROffer *offer) {
            self.offerReady = NO;
//Calling delegate events immidiately after callback from HyprMX may cause UI issues in Unity builds on iOS7 &iOS6
            if (NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self reportAdDidClose:completed];
                });
            }else{
                [self reportAdDidClose:completed];
            }
        }];
    }
}

- (BOOL)startAdapterWithDictionary:(NSDictionary *)dict
{
    // Sets the specific data for rewarded video, such as ad placements.
    // The data dictionary contains the SPNetworkParameters dictionary read from
    // the plist file
    
    return YES;
}

- (void)reportAdDidClose:(BOOL) completed
{
    if (completed) {
        SPLogDebug(@"[HyprMX] HyprMX reported that offer has been completed successfully.");
        [self.delegate adapterVideoDidFinish:self];
        [self.delegate adapterVideoDidClose:self];
    }
    else {
        SPLogWarn(@"[HyprMX] HyprMX reported that offer has been aborted.");
        [self.delegate adapterVideoDidAbort:self];
    }
}
@end
