//
//  SPHyprMXRewardedVideoAdapter.m
//  SponsorPayTestApp
//
//  Created by Pierre Bongen on 22.05.14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPRewardedVideoNetworkAdapter.h"



@class SPHyprMXNetwork;



#pragma mark  

@interface SPHyprMXRewardedVideoAdapter : NSObject < 
	SPRewardedVideoNetworkAdapter >

#pragma mark  
#pragma mark Public Properties -

@property ( nonatomic, weak ) SPBaseNetwork *network;

//!Typed convenience property for setting and getting the network.
@property ( nonatomic, weak ) SPHyprMXNetwork *networkAsSPHyprMXNetwork;

@end

#pragma mark  
