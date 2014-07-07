//
//  SPHyprMXNetwork.m
//  SponsorPayTestApp
//
//  Created by Pierre Bongen on 22.05.14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

// Adapter versioning - Remember to update the header

#import "SPHyprMXNetwork.h"

// SponsorPay SDK.
#import "SPHyprMXRewardedVideoAdapter.h"
#import "SPLogger.h"
#import "SPRandomID.h"
#import "SPSemanticVersion.h"
#import "SPTPNGenericAdapter.h"

// HyprMX SDK.
#import <HyprMX/HyprMX.h>



//
// Constants
//

// --- Version

static const NSInteger SPHyprMXVersionMajor = 2;
static const NSInteger SPHyprMXVersionMinor = 0;
static const NSInteger SPHyprMXVersionPatch = 0;

// --- Data Dictionary Keys aka Network Parameters

static NSString * const SPHyprMXDistributorID = @"SPHyprMXDistributorID";
static NSString * const SPHyprMXPropertyID = @"SPHyprMXPropertyID";

// --- User Defaults Keys

static NSString * const SPHyprMXUserID = @"SPHyprMXUserID";



#pragma mark  

@interface SPHyprMXNetwork()

@property ( nonatomic, strong ) SPHyprMXRewardedVideoAdapter *
	HyprMXRewardedVideoAdapter;
@property ( nonatomic, copy, readonly ) NSString *HyprMXUserID;
@property ( nonatomic, strong ) id < SPTPNVideoAdapter > rewardedVideoAdapter;
	
@end




#pragma mark  
#pragma mark  
#pragma mark  

@implementation SPHyprMXNetwork

#pragma mark  
#pragma mark Private Properties -

@synthesize HyprMXRewardedVideoAdapter = HyprMXRewardedVideoAdapter;

- (NSString *)HyprMXUserID
{
	NSUserDefaults * const defaults = [NSUserDefaults standardUserDefaults];
    
	NSString *result = [defaults objectForKey:SPHyprMXUserID];
    
    if ( 
    	![result isKindOfClass:[NSString class]]
        	|| ![result length]
    ){
    	SPLogDebug( @"[HYPR] Creating new user ID." );
    	result = [SPRandomID randomIDString];
        
        [defaults setObject:result forKey:SPHyprMXUserID];
    }
	else
    {
    	SPLogDebug( @"[HYPR] Using existing user ID." );
    }
    
    return result;
}

@synthesize rewardedVideoAdapter = _rewardedVideoAdapter;

#pragma mark  
#pragma mark Public Methods -

- (instancetype)init
{
    self = [super init];
	
    if (self) {
    }
	
    return self;
}

#pragma mark  
#pragma mark Method Overrides -

#pragma mark  
#pragma mark SPBaseNetwork

+ (SPSemanticVersion *)adapterVersion
{
    return [SPSemanticVersion 
    	versionWithMajor:SPHyprMXVersionMajor
        minor:SPHyprMXVersionMinor
        patch:SPHyprMXVersionPatch];
}

- (BOOL)startSDK:(NSDictionary *)data
{
	//
	// Check parameter.
	//
	
	if ( ![data isKindOfClass:[NSDictionary class]] ) {
    
		SPLogError( @"data parameter is nil or not a dictionary." );
		return NO;
        
	}

	// --- Distributor ID.
	
	NSString * const distributorID = data[ SPHyprMXDistributorID ];
	
	if ( 
		![distributorID isKindOfClass:[NSString class]] 
			|| ![distributorID length]
	){
		SPLogError( @"No or empty value given for key %@.", 
			SPHyprMXDistributorID );

		return NO;
	}
	
	// --- Property ID.
	
	NSString * const propertyID = data[ SPHyprMXPropertyID ];
	
	if ( 
		![propertyID isKindOfClass:[NSString class]] 
			|| ![propertyID length]
	){
		SPLogError( @"No or empty value given for key %@.",
			SPHyprMXPropertyID );

		return NO;
	}

	//
    // Start SDK.
    //

    SPLogInfo(@"Initializing HyprMX SDK version %@",[[HYPRManager sharedManager] versionString]);
    [[HYPRManager sharedManager] 
		initializeWithDistributorId:distributorID
		propertyId:propertyID 
		userId:self.HyprMXUserID];

    return YES;
}

- (void)startRewardedVideoAdapter:(NSDictionary *)data
{
    self.HyprMXRewardedVideoAdapter = [SPHyprMXRewardedVideoAdapter new];

    SPTPNGenericAdapter * const videoAdapterWrapper = 
		[[SPTPNGenericAdapter alloc] initWithVideoNetworkAdapter:
			self.HyprMXRewardedVideoAdapter];

    self.HyprMXRewardedVideoAdapter.delegate = videoAdapterWrapper;
    self.rewardedVideoAdapter = videoAdapterWrapper;

    [super startRewardedVideoAdapter:data];
}

@end

#pragma mark  
