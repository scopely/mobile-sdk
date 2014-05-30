//
//  SPAdMobInterstitialAdapter.h
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 01/04/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPInterstitialNetworkAdapter.h"

@class SPAdMobNetwork;

@interface SPAdMobInterstitialAdapter : NSObject <SPInterstitialNetworkAdapter>

@property (weak, nonatomic) SPAdMobNetwork *network;
@property (strong, nonatomic) NSArray *testDevices;

@end
