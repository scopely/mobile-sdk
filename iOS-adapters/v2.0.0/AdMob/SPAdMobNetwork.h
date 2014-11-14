//
//  SPAdMobNetwork.h
//
//  Created on 01/04/14.
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import "SPBaseNetwork.h"

typedef NS_ENUM(NSInteger, SPCOPPAComplicanceStatus) {
    SPAdmobCoppaComplianceUnknown,
    SPAdmobCoppaComplianceEnabled,
    SPAdmobCoppaComplianceDisabled
};

@interface SPAdMobNetwork : SPBaseNetwork

@property (nonatomic, assign) SPCOPPAComplicanceStatus coppaComplicanceStatus;
@property (nonatomic, strong) NSArray *testDevices;

@end
