//
//  SPVungleAdapter.h
//  SponsorPay iOS SDK
//
//  Created by David Davila on 5/30/13.
// Copyright 2011-2013 SponsorPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <vunglepub/vunglepub.h>
#import "SPTPNVideoAdapter.h"

#define VungleProtocol , VGVunglePubDelegate

@class SPVungleNetwork;
@interface SPVungleRewardedVideoAdapter : NSObject <SPTPNVideoAdapter VungleProtocol>

@property (nonatomic, weak) SPVungleNetwork *network;

@end
