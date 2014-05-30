//
//  SPAdMobNetwork.h
//  SponsorPayTestApp
//
//  Created by Daniel Barden on 01/04/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPBaseNetwork.h"

typedef NS_ENUM(NSInteger, SPCOPPAComplicanceStatus) {
    SPAdmobCoppaComplianceUnknown,
    SPAdmobCoppaComplianceEnabled,
    SPAdmobCoppaComplianceDisabled
};

@interface SPAdMobNetwork : SPBaseNetwork

@property (assign, nonatomic) SPCOPPAComplicanceStatus coppaComplicanceStatus;
@property (strong, nonatomic) NSArray *testDevices;

@end
