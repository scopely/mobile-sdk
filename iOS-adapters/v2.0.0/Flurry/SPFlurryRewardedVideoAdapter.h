//
//  SPFlurryAdapter.h
//  SponsorPay iOS SDK
//
//  Created by David Davila on 6/17/13.
// Copyright 2011-2013 SponsorPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPTPNVideoAdapter.h"
#import "SPFlurryNetwork.h"

#import "FlurryAdDelegate.h"

//#define FLURRY_TEST_ADS_ENABLED

@class SPFlurryNetwork;

@interface SPFlurryRewardedVideoAdapter : NSObject <SPTPNVideoAdapter, FlurryAdDelegate>

@property (nonatomic, weak) SPFlurryNetwork *network;

@end
