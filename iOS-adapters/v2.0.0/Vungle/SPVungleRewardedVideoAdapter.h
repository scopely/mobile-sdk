//
// SPVungleAdapter.h
//
// Created on 5/30/13.
// Copyright 2011-2013 Fyber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <VungleSDK/VungleSDK.h>
#import "SPRewardedVideoNetworkAdapter.h"

@class SPVungleNetwork;

/**
 Implementation of Vungle network for Rewarded Video demand
 
 ## Version compatibility
 
 - Adapter version: 2.3.1
 - Fyber SDK version: 7.0.3
 - Vungle SDK version: 3.0.11
 
 */

@interface SPVungleRewardedVideoAdapter : NSObject<SPRewardedVideoNetworkAdapter, VungleSDKDelegate>

@property (nonatomic, weak) SPVungleNetwork *network;

@end
