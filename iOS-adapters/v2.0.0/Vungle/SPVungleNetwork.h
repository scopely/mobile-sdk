//
//  SPVungleNetwork.h
//
//  Created by Daniel Barden on 13/01/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <VungleSDK/VungleSDK.h>
#import "SPBaseNetwork.h"

/**
 Network class in charge of integrating Vungle library
 
 ## Version compatibility
 
 - Adapter version: 2.2.0
 - Fyber SDK version: 7.0.2
 - Vungle SDK version: 3.0.10
 
 */

@interface SPVungleNetwork : SPBaseNetwork

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *orientation;
@property (nonatomic, readonly) UIInterfaceOrientationMask orientationMask;
@property (nonatomic, copy) NSNumber *showClose;

@end
