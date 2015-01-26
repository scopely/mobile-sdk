//
//  SPInMobiInterstitialAdapter.h
//
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPInterstitialNetworkAdapter.h"
@class SPInMobiNetwork;


/**
 Implementation of InMobi network for Intersitital demand

 ## Version compatibility

 - Adapter version: 3.0.0
 - Fyber SDK version: 7.0.3
 - InMobi SDK version: 4.5.1

 */

@interface SPInMobiInterstitialAdapter : NSObject<SPInterstitialNetworkAdapter>

@property (weak, nonatomic) SPInMobiNetwork *network;

@end
