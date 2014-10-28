//
//  SPInMobiInterstitialAdapter.h
//
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPInterstitialNetworkAdapter.h"
@class SPInMobiNetwork;

@interface SPInMobiInterstitialAdapter : NSObject <SPInterstitialNetworkAdapter>

@property (weak, nonatomic) SPInMobiNetwork *network;

@end
