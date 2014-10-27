//
//  SPAdMobInterstitialAdapter.h
//
//  Created on 01/04/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPInterstitialNetworkAdapter.h"

@class SPAdMobNetwork;

@interface SPAdMobInterstitialAdapter : NSObject<SPInterstitialNetworkAdapter>

@property (nonatomic, weak) SPAdMobNetwork *network;
@property (nonatomic, strong) NSArray *testDevices;

@end
