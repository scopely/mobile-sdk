//
//  SPInMobiInterstitialAdapter.h
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 21/01/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPInterstitialNetworkAdapter.h"
@class SPInMobiNetwork;

@interface SPInMobiInterstitialAdapter : NSObject <SPInterstitialNetworkAdapter>

@property (weak, nonatomic) SPInMobiNetwork *network;

@end
