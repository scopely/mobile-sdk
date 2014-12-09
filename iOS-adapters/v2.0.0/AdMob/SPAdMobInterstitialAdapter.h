//
//  SPAdMobInterstitialAdapter.h
//
//  Created on 01/04/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPInterstitialNetworkAdapter.h"

@class SPAdMobNetwork;

/**
 Implementation of AdMob network for interstitials demand
 
 ## Version compatibility
 
 - Adapter version: 2.0.2
 - Fyber SDK version: 7.0.2
 - AdMob SDK version: 6.12.2
 
 */

@interface SPAdMobInterstitialAdapter : NSObject<SPInterstitialNetworkAdapter>

@property (nonatomic, weak) SPAdMobNetwork *network;
@property (nonatomic, strong) NSArray *testDevices;

@end
