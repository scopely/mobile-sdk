//
//  SPAppLiftInterstitialAdapter.h
//  Fyber iOS SDK - AppLift Adapter v.2.2.1
//
//  Created on 20/11/13.
//  Copyright (c) 2013 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPInterstitialNetworkAdapter.h"
#import "PlayAdsSDK.h"

@class SPAppLiftNetwork;

@interface SPAppLiftInterstitialAdapter : NSObject<SPInterstitialNetworkAdapter, PlayAdsSDKDelegate>

@property (nonatomic, weak) SPAppLiftNetwork *network;

@end
