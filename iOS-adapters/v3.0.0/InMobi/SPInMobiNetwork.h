//
//  SPInMobiNetwork.h
//
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPBaseNetwork.h"
#import "InMobi.h"


/**
 Implementation of InMobi network adapter

 ## Version compatibility

 - Adapter version: 3.0.0
 - Fyber SDK version: 7.0.3
 - InMobi SDK version: 4.5.1

 */

@interface SPInMobiNetwork : SPBaseNetwork

@property (nonatomic, copy, readonly) NSString *appId;
@property (nonatomic, copy, readonly) NSString *rewardedVideoPropertyId;
@property (nonatomic, strong) NSDictionary *additionalParameters;

@end
