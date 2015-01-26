//
//  SPInMobiRewardedVideoAdapter.h
//
//  Created on 05.11.14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPRewardedVideoNetworkAdapter.h"
#import "SPInMobiNetwork.h"

/**
 Implementation of InMobi network for Rewarded Video demand

 ## Version compatibility

 - Adapter version: 3.0.0
 - Fyber SDK version: 7.0.3
 - InMobi SDK version: 4.5.1

 */

@interface SPInMobiRewardedVideoAdapter : NSObject<SPRewardedVideoNetworkAdapter>

@property (nonatomic, weak) SPInMobiNetwork *network;

@end
