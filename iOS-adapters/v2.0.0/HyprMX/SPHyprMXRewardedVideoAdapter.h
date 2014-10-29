//
//  SPHyprMXRewardedVideoAdapter.m
//
//  Created on 22.05.14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPRewardedVideoNetworkAdapter.h"
#import "SPHyprMXNetwork.h"

/**
 Implementation of HyprMX network for Rewarded Video demand
 
 ## Version compatibility
 
 - Adapter version: 2.1.0
 - Fyber SDK version: 6.5.2
 - HyprMX SDK version: 17
 
 */

@interface SPHyprMXRewardedVideoAdapter : NSObject <SPRewardedVideoNetworkAdapter>

@property (nonatomic, weak) SPHyprMXNetwork *network;

@end

