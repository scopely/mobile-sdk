//
//  SPMillenialInterstitialAdapter.h
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 18/02/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPBaseNetwork.h"
#import "SPInterstitialNetworkAdapter.h"

@class SPMillennialNetwork;

@interface SPMillennialInterstitialAdapter : NSObject  <SPInterstitialNetworkAdapter>

@property (weak, nonatomic) SPMillennialNetwork *network;

@end
