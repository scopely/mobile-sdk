//
//  SPVungleAdapter.h
//  Fyber iOS SDK
//
//  Created by on 5/30/13.
// Copyright 2011-2013 SponsorPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <VungleSDK/VungleSDK.h>
#import "SPRewardedVideoNetworkAdapter.h"

@class SPVungleNetwork;

/**
 Implementation of Vungle network for Rewarded Video demand
 
 ## Version compatibility
 
 - Adapter version: 2.2.0
 - Fyber SDK version: 7.0.2
 - Vungle SDK version: 3.0.10
 
 */

@interface SPVungleRewardedVideoAdapter : NSObject<SPRewardedVideoNetworkAdapter, VungleSDKDelegate>

@property (nonatomic, weak) SPVungleNetwork *network;

@end
