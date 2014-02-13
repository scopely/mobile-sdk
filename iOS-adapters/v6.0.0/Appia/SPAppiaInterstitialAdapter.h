//
//  SPAppiaInterstitialAdapter.h
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 04/12/13.
//  Copyright (c) 2013 SponsorPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPInterstitialNetworkAdapter.h"

@class SPAppiaNetwork;

@protocol SPAIBannerAdDelegate

- (void)bannerDidAppear;
- (void)bannerDidClose;

@end

@interface SPAppiaInterstitialAdapter : NSObject <SPInterstitialNetworkAdapter, SPAIBannerAdDelegate>

@property (weak, nonatomic) SPAppiaNetwork *network;

@end
