//
//  SPHyprMXRewardedVideoAdapter.m
//  SponsorPayTestApp
//
//  Created by Pierre Bongen on 22.05.14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPHyprMXRewardedVideoAdapter.h"
#import "SPHyprMXNetwork.h"
#import "SPLogger.h"
#import "HyprMX.h"

#ifndef SP_TO_NSSTRING
#define SP_TO_NSSTRING(s) (sizeof(s) ? @ # s : @ # s)
#endif

typedef NS_ENUM(NSUInteger, SPHyprMXRewardedVideoAdapterState){

	//!No video is available.
	SPHyprMXRewardedVideoAdapterStateCannotDisplay = 0,
    
    //!An offer or video is available for display.
	SPHyprMXRewardedVideoAdapterStateCanDisplay,
    
    //!A video is currently being displayed.
	SPHyprMXRewardedVideoAdapterStateDisplaying,
	
	//!Checking availability is called "requesting display" in HyprMX lingo.
	SPHyprMXRewardedVideoAdapterStateRequestingDisplay,
	
    //!Minimum valid value.
	SPHyprMXRewardedVideoAdapterStateMin = SPHyprMXRewardedVideoAdapterStateCannotDisplay,

    //!Maximum valid value.
	SPHyprMXRewardedVideoAdapterStateMax = SPHyprMXRewardedVideoAdapterStateRequestingDisplay
		
};



#pragma mark  
#define SP_HYPR_LOG 1


#if SP_HYPR_LOG

#define SP_HYPR_LOG_METHOD(){\
	SPLogDebug(\
		@"[HYPR] -[%@ %@] (self.state = %@)", \
		NSStringFromClass([self class]), \
		NSStringFromSelector(_cmd), \
        NSStringFromSPHyprMXRewardedVideoAdapterState(self.state)); \
}

#define SP_HYPR_LOG_OFFER_METHOD(){\
	SPLogDebug(\
		@"[HYPR] -[%@ %@]: offer = %@ (self.state = %@)", \
		NSStringFromClass([self class]), \
		NSStringFromSelector(_cmd), \
		NSStringFromHYPROffer(offer), \
        NSStringFromSPHyprMXRewardedVideoAdapterState(self.state)); \
}

#else

#define SP_HYPR_LOG_METHOD()
#define SP_HYPR_LOG_OFFER_METHOD()

#endif

#pragma mark  

static NSString *NSStringFromHYPROffer(HYPROffer *offer)
{
	return offer ? [NSString stringWithFormat:@"%@{ identifier = %@, rewardIdentifier = %@ }", [offer description], offer.identifier, offer.rewardIdentifier] : nil;
}

static NSString *NSStringFromSPHyprMXRewardedVideoAdapterState(SPHyprMXRewardedVideoAdapterState state)
{
	NSCAssert(SPHyprMXRewardedVideoAdapterStateMin <= state && SPHyprMXRewardedVideoAdapterStateMax >= state, @"Invalid value for state parameter.");
	NSString *result = nil;

    switch(state){
        case SPHyprMXRewardedVideoAdapterStateCanDisplay:
            result = SP_TO_NSSTRING(SPHyprMXRewardedVideoAdapterStateCanDisplay);
            break;
        case SPHyprMXRewardedVideoAdapterStateCannotDisplay:
            result = SP_TO_NSSTRING(SPHyprMXRewardedVideoAdapterStateCannotDisplay);
            break;
        case SPHyprMXRewardedVideoAdapterStateDisplaying:
            result = SP_TO_NSSTRING(SPHyprMXRewardedVideoAdapterStateDisplaying);
            break;
        case SPHyprMXRewardedVideoAdapterStateRequestingDisplay:
            result = SP_TO_NSSTRING(SPHyprMXRewardedVideoAdapterStateRequestingDisplay);
            break;
        default:
            break;
    }
    if(!result){
    	result = [NSString stringWithFormat:@"%@(%llu)", SP_TO_NSSTRING(SPHyprMXRewardedVideoAdapterState), (unsigned long long)state];
    }
    
    return result;
}

#pragma mark
@interface SPHyprMXRewardedVideoAdapter()

#pragma mark  
#pragma mark Private Properties -

@property (nonatomic, assign) SPHyprMXRewardedVideoAdapterState state;

@end

#pragma mark -

@implementation SPHyprMXRewardedVideoAdapter

#pragma mark  
#pragma mark SPRewardedVideoNetworkAdapter

@synthesize delegate;

- (NSString *)networkName
{
    return self.network.name;
}

#pragma mark  
#pragma mark Private Properties -

#pragma mark  
#pragma mark Protocol Methods -

#pragma mark  
#pragma mark SPRewardedVideoNetworkAdapter

- (void)checkAvailability
{
    SP_HYPR_LOG_METHOD();
    
    switch (self.state)
    {
        case SPHyprMXRewardedVideoAdapterStateCanDisplay:
            [self reportVideoAvailable:YES];
            break;
        case SPHyprMXRewardedVideoAdapterStateCannotDisplay:
        {
            // TODO: Potential source of infinite, battery draining requests?
            [[HYPRManager sharedManager] checkInventory:^(BOOL isOfferReady) {
                self.state = isOfferReady ? SPHyprMXRewardedVideoAdapterStateCanDisplay : SPHyprMXRewardedVideoAdapterStateCannotDisplay;
                [self reportVideoAvailable:YES];
            }];
            break;
        }
        case SPHyprMXRewardedVideoAdapterStateDisplaying:
            // No other video is available while we are still displaying.
            [self reportVideoAvailable:NO];
            break;
            
        case SPHyprMXRewardedVideoAdapterStateRequestingDisplay:
            // We are already requesting display with HyperMX.
            break;
    }
}

- (void)playVideoWithParentViewController:(UIViewController *)parentVC
{
	[self displayHyprMXVideo];
}

- (BOOL)startAdapterWithDictionary:(NSDictionary *)dict
{
    // Sets the specific data for rewarded video, such as ad placements.
    // The data dictionary contains the SPNetworkParameters dictionary read from
	// the plist file
	
	// NOTE: Currently, there's nothing to do here for HyprMX.
	
    return YES;
}

#pragma mark
#pragma mark Private Methods -

#pragma mark  
#pragma mark Working with HyprMX

- (void)disposeHyprMXDisplayRequest
{
	SP_HYPR_LOG_METHOD();

	if(SPHyprMXRewardedVideoAdapterStateCannotDisplay != self.state){
        NSString *const errorDescription = [NSString stringWithFormat:@"The display request is still in use."];
		SPLogWarn(errorDescription);
		return;
	}

    self.state = SPHyprMXRewardedVideoAdapterStateCannotDisplay;
}

- (void)requestHyprMXDisplay
{
	SP_HYPR_LOG_METHOD();

	if(SPHyprMXRewardedVideoAdapterStateRequestingDisplay == self.state){
    	// We are already requesting a display.
    	return;
    }
	
	if(SPHyprMXRewardedVideoAdapterStateCannotDisplay != self.state){
    
		NSString *const errorDescription = [NSString stringWithFormat:@"There is already a display request."];
		SPLogWarn(errorDescription);
		
		// NOTE: No SDK error class and codes exists so far.
		
		[self notifyDidFailWithError:[NSError errorWithDomain:@"com.sponsorpay" code:0 userInfo:@{NSLocalizedDescriptionKey : errorDescription}]];
		
		return;
	}
    
	self.state = SPHyprMXRewardedVideoAdapterStateRequestingDisplay;
    
    [[HYPRManager sharedManager] checkInventory:^(BOOL isOfferReady) {
        self.state = isOfferReady ? SPHyprMXRewardedVideoAdapterStateCanDisplay : SPHyprMXRewardedVideoAdapterStateCannotDisplay;
        [self reportVideoAvailable:YES];
        SP_HYPR_LOG_METHOD();
    }];
}

- (void)displayHyprMXVideo
{
	SP_HYPR_LOG_METHOD();
	
    if(SPHyprMXRewardedVideoAdapterStateDisplaying == self.state){
    	// We already display the video. Just leave.
    	return;
    }
    
	if((SPHyprMXRewardedVideoAdapterStateCanDisplay != self.state)){
	
		NSString *const errorDescription = [NSString stringWithFormat: @"Did receive %@ message but %@ is not ready to play a video.", NSStringFromSelector(_cmd),
			self];

		SPLogError(errorDescription);
		
		// NOTE: No SDK error class and codes exists so far.
		[self notifyDidFailWithError:[NSError errorWithDomain:@"com.sponsorpay" code:0 userInfo:@{NSLocalizedDescriptionKey: errorDescription}]];
		
		return;
	}
		
    self.state = SPHyprMXRewardedVideoAdapterStateDisplaying;
	
    [self notifyVideoDidStart];
    [[HYPRManager sharedManager] displayOffer:^(BOOL completed, HYPROffer *offer) {
        SP_HYPR_LOG_OFFER_METHOD();
        if(completed)
        {
            [self notifyVideoDidFinish];
            [self notifyVideoDidClose];
        }
        else
        {
            [self notifyVideoDidAbort];
        }
        self.state = SPHyprMXRewardedVideoAdapterStateCannotDisplay;
    }];
}

#pragma mark  
#pragma mark Notifying and Reporting to the Delegate

- (void)notifyDidFailWithError:(NSError *)error
{
    [self.delegate adapter:self didFailWithError:error];
}

- (void)notifyVideoDidFinish
{
    [self.delegate adapterVideoDidFinish:self];
}

- (void)notifyVideoDidAbort
{
    [self.delegate adapterVideoDidAbort:self];
}

- (void)notifyVideoDidClose
{
    [self.delegate adapterVideoDidClose:self];
}

- (void)notifyVideoDidStart
{
    [self.delegate adapterVideoDidStart:self];
}

- (void)reportVideoAvailable:(BOOL)videoAvailable
{
    [self.delegate adapter:self didReportVideoAvailable:videoAvailable ? YES : NO];
}

@end

#pragma mark  
