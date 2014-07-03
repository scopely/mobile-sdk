//
//  SPEbuzzingRewardedVideoAdapter.m
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 07/05/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPRewardedVideoNetworkAdapter.h"

@class SPEbuzzingNetwork;

@interface SPEbuzzingRewardedVideoAdapter : NSObject <SPRewardedVideoNetworkAdapter>

@property (nonatomic, weak) SPEbuzzingNetwork *network;

@end
