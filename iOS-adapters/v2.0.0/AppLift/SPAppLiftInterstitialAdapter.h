//
//  SPAppLiftInterstitialAdapter.h
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 20/11/13.
//  Copyright (c) 2013 SponsorPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPInterstitialNetworkAdapter.h"
#import "PlayAdsSDK.h"

@class SPAppLiftNetwork;

@interface SPAppLiftInterstitialAdapter : NSObject <SPInterstitialNetworkAdapter, PlayAdsSDKDelegate>

@property (nonatomic, weak) SPAppLiftNetwork *network;

@end
