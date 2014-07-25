//
//  SPHyprMXRewardedVideoAdapter.m
//  SponsorPayTestApp
//
//  Created by Pierre Bongen on 22.05.14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPRewardedVideoNetworkAdapter.h"
#import "SPHyprMXNetwork.h"

@interface SPHyprMXRewardedVideoAdapter:NSObject <SPRewardedVideoNetworkAdapter>

@property (nonatomic, weak) SPHyprMXNetwork *network;

@end

