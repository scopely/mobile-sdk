//
//  SPHyprMXRewardedVideoAdapter.m
//  SponsorPayTestApp
//
//  Created by Pierre Bongen on 22.05.14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPHyprMXRewardedVideoAdapter.h"

// SponsorPay SDK.
#import "SPHyprMXNetwork.h"
#import "SPLogger.h"

// HyprMX SDK.
#import <HyprMX/HyprMX.h>

#ifndef SP_HYPR_STRINGIFY
#define SP_HYPR_STRINGIFY( s ) ( sizeof( s ) ? @ #s : @ #s )
#endif

#ifndef SP_HYPR_CASE
#define SP_HYPR_CASE( e ) case e : result = SP_HYPR_STRINGIFY( e ); break;
#endif

//
// Types
//

typedef NS_ENUM( NSUInteger, SPHyprMXRewardedVideoAdapterState ) {

	//!No video is available.
	SPHyprMXRewardedVideoAdapterStateCannotDisplay = 0,
    
    //!An offer or video is available for display.
	SPHyprMXRewardedVideoAdapterStateCanDisplay,
    
    //!A video might be/is available but a form is first displayed to the user.
    SPHyprMXRewardedVideoAdapterStateCanDisplayRequiredInformation,
    
    //!A video is currently being displayed.
	SPHyprMXRewardedVideoAdapterStateDisplaying,
	
	//!Checking availability is called "requesting display" in HyprMX lingo.
	SPHyprMXRewardedVideoAdapterStateRequestingDisplay,
	
    //!Minimum valid value.
	SPHyprMXRewardedVideoAdapterStateMin = 
		SPHyprMXRewardedVideoAdapterStateCannotDisplay,

    //!Maximum valid value.
	SPHyprMXRewardedVideoAdapterStateMax =	
		SPHyprMXRewardedVideoAdapterStateRequestingDisplay
		
};



#pragma mark  
#define SP_HYPR_LOG 1


#if SP_HYPR_LOG

#define SP_HYPR_LOG_METHOD() {\
	SPLogDebug( \
		@"[HYPR] -[%@ %@] ( self.state = %@ )", \
		NSStringFromClass( [self class] ), \
		NSStringFromSelector( _cmd ), \
        NSStringFromSPHyprMXRewardedVideoAdapterState( self.state ) ); \
}

#define SP_HYPR_LOG_OFFER_METHOD() {\
	SPLogDebug( \
		@"[HYPR] -[%@ %@]: offer = %@ ( self.state = %@ )", \
		NSStringFromClass( [self class] ), \
		NSStringFromSelector( _cmd ), \
		NSStringFromHYPROffer( offer ), \
        NSStringFromSPHyprMXRewardedVideoAdapterState( self.state ) ); \
}

#else

#define SP_HYPR_LOG_METHOD()
#define SP_HYPR_LOG_OFFER_METHOD()

#endif



#pragma mark  

static NSString * NSStringFromHYPROffer( HYPROffer *offer )
{
	return offer
		? [NSString stringWithFormat:
			@"%@{ identifier = %@, rewardIdentifier = %@ }",
			[offer description],
			offer.identifier,
			offer.rewardIdentifier]
		: nil;
}

static NSString * NSStringFromSPHyprMXRewardedVideoAdapterState(
	SPHyprMXRewardedVideoAdapterState state
){
	NSCAssert(
		SPHyprMXRewardedVideoAdapterStateMin <= state
			&& SPHyprMXRewardedVideoAdapterStateMax >= state,
		@"Invalid value for state parameter." );

	NSString *result = nil;

	switch ( state )
    {
	SP_HYPR_CASE( SPHyprMXRewardedVideoAdapterStateCanDisplay )
	SP_HYPR_CASE( SPHyprMXRewardedVideoAdapterStateCanDisplayRequiredInformation )
    SP_HYPR_CASE( SPHyprMXRewardedVideoAdapterStateCannotDisplay )
    SP_HYPR_CASE( SPHyprMXRewardedVideoAdapterStateDisplaying )
    SP_HYPR_CASE( SPHyprMXRewardedVideoAdapterStateRequestingDisplay )
    }
    
    if ( !result )
    {
    	result = [NSString stringWithFormat:@"%@( %llu )",
        	SP_HYPR_STRINGIFY( SPHyprMXRewardedVideoAdapterState ),
            (unsigned long long)state];
    }
    
    return result;
}



#pragma mark  
#pragma mark  
#pragma mark  

@interface SPHyprMXRewardedVideoAdapter() < HYPROfferPresentationDelegate >

#pragma mark  
#pragma mark Private Properties -

#pragma mark  
#pragma mark HyperMX

/*!
	\brief Holds the currently processed HyprMX display request.
    
    A display request covers the time from the availability check until when the
    video is either played or the HyperMX SDK notified us that it currently
    cannot display anything.
    
    During this time, this property is guaranteed to be non-nil.
*/
@property ( nonatomic, strong ) HYPRDisplayRequest *displayRequest;

#pragma mark  
#pragma mark State

@property ( nonatomic, assign ) SPHyprMXRewardedVideoAdapterState state;

@property ( nonatomic, assign, getter = isOfferComplete ) BOOL offerComplete;

@end



#pragma mark  
#pragma mark  
#pragma mark  

@implementation SPHyprMXRewardedVideoAdapter
{
@private

	__weak id < SPRewardedVideoNetworkAdapterDelegate > delegate;
	HYPRDisplayRequest *displayRequest;
	__weak SPHyprMXNetwork *networkAsSPHyprMXNetwork;
	SPHyprMXRewardedVideoAdapterState state;
}

#pragma mark  
#pragma mark Public Properties -

- (SPHyprMXNetwork *)networkAsSPHyprMXNetwork
{
	return self->networkAsSPHyprMXNetwork;
}

- (SPBaseNetwork *)network
{
	return self.networkAsSPHyprMXNetwork;
}

- (void)setNetworkAsSPHyprMXNetwork:(SPHyprMXNetwork *)newNetwork
{
	//
	// Check parameter.
	//
	
	NSAssert(
		!newNetwork 
			|| [newNetwork isKindOfClass:[SPHyprMXNetwork class]],
		@"Expecting newHyprMXNetwork parameter to be  either nil or kind of "
			"class %@.",
		NSStringFromClass( [SPHyprMXNetwork class] ) );
	
	//
	// Set new network.
	//
	
	self->networkAsSPHyprMXNetwork = newNetwork;
}

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
#pragma mark HyperMX

- (HYPRDisplayRequest *)displayRequest
{
	return self->displayRequest;
}

- (void)setDisplayRequest:(HYPRDisplayRequest *)newDisplayRequest
{
	//
	// Check parameter.
	//
	
	NSAssert(
		!newDisplayRequest 
			|| [newDisplayRequest isKindOfClass:[HYPRDisplayRequest class]],
		@"Expecting newDisplayRequest parameter to be nil or kind of class "
		 	"%@.",
		NSStringFromClass( [HYPRDisplayRequest class] ) );
	
	//
	// Set new display request.
	//
	
	self->displayRequest = newDisplayRequest;
}

#pragma mark  
#pragma mark State

- (SPHyprMXRewardedVideoAdapterState)state
{
	return self->state;
}

- (void)setState:(SPHyprMXRewardedVideoAdapterState)newState
{
	//
	// Check parameter.
	//
	
	NSAssert(
		SPHyprMXRewardedVideoAdapterStateMin <= newState
			&& SPHyprMXRewardedVideoAdapterStateMax >= newState,
		@"Invalid value for newState parameter." );
	
	//
	// Set new state.
	//
	
	self->state = newState;
}

#pragma mark  
#pragma mark Protocol Methods -

#pragma mark  
#pragma mark SPRewardedVideoNetworkAdapter

- (void)checkAvailability
{
	SP_HYPR_LOG_METHOD();
    
	switch ( self.state )
	{
	case SPHyprMXRewardedVideoAdapterStateCanDisplay:
	case SPHyprMXRewardedVideoAdapterStateCanDisplayRequiredInformation:
		[self reportVideoAvailable:YES];
		break;
	
	case SPHyprMXRewardedVideoAdapterStateCannotDisplay:
		// TODO: Potential source of infinite, battery draining requests?
		[self requestHyprMXDisplay];
		break;
	
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
    self.offerComplete = NO;
	[self displayHyprMXVideo];
}

- (void)setNetwork:(SPBaseNetwork *)network
{
	self.networkAsSPHyprMXNetwork = (SPHyprMXNetwork *)network;
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
#pragma mark HYPROfferDelegate

- (void)didCancelOffer:(HYPROffer *)offer
{
	SP_HYPR_LOG_OFFER_METHOD();
	[self notifyVideoDidAbort];
}

- (void)didCompleteOffer:(HYPROffer *)offer
{
	SP_HYPR_LOG_OFFER_METHOD();
    
    //
    // NOTE: HyprMX uses "complete offer" while SponsorPay uses "finish video"
    //       in this situation.
	//
    self.offerComplete = YES;
    [self notifyVideoDidFinish];
}

- (void)didDisplayOffer:(HYPROffer *)offer
{
	SP_HYPR_LOG_OFFER_METHOD();
	[self notifyVideoDidStart];
}

- (NSArray*)rewardsForOffer:(HYPROffer*)offer
{
	SP_HYPR_LOG_OFFER_METHOD();
	return nil;
}

- (void)willDisplayOffer:(HYPROffer *)offer
{
	SP_HYPR_LOG_OFFER_METHOD();
}

#pragma mark  
#pragma mark HYPROfferPresentationDelegate

- (void)displayRequestCanDisplayOfferList:(HYPRDisplayRequest *)displayRequest
{
	SP_HYPR_LOG_METHOD();
}

- (void)displayRequestCanDisplayRequiredInformation:(HYPRDisplayRequest *)
	aDisplayRequest
{
	SP_HYPR_LOG_METHOD();
    
    self.state = SPHyprMXRewardedVideoAdapterStateCanDisplayRequiredInformation;

	//
	// NOTE: We regard this state as if there is a video available. The 
    //       "required information" screen might ask the user for his/her age 
    //       in order to deliver only suitable advertisements.
    //
    
	[self reportVideoAvailable:YES];    
}

- (void)displayRequest:(HYPRDisplayRequest *)aDisplayRequest 
	canDisplayOffer:(HYPROffer *)offer
{
	SP_HYPR_LOG_METHOD();
    
    self.state = SPHyprMXRewardedVideoAdapterStateCanDisplay;
    
	[self reportVideoAvailable:YES];
}

- (void)displayRequestCannotDisplay:(HYPRDisplayRequest *)displayRequest
{
	SP_HYPR_LOG_METHOD();

    self.state = SPHyprMXRewardedVideoAdapterStateCannotDisplay;

	[self disposeHyprMXDisplayRequest];

    NSString * const errorDescription =	[NSString stringWithFormat:
        @"HyprMX failed and reported that it cannot display."];

    SPLogError( errorDescription );
    
    // NOTE: No SDK error class and codes exists so far.
    
    [self notifyDidFailWithError:[NSError 
        errorWithDomain:@"com.sponsorpay"
        code:0
        userInfo:@{ NSLocalizedDescriptionKey : errorDescription }]];
}

- (void)displayRequestDidFinish:(HYPRDisplayRequest *)displayRequest
{
	SP_HYPR_LOG_METHOD();

	self.state = SPHyprMXRewardedVideoAdapterStateCannotDisplay;

	[self disposeHyprMXDisplayRequest];

    if ( self.offerComplete )
    {
        [self notifyVideoDidClose];
    }
}

#pragma mark
#pragma mark Private Methods -

#pragma mark  
#pragma mark Working with HyprMX

- (void)disposeHyprMXDisplayRequest
{
	SP_HYPR_LOG_METHOD();

	//
	// Check state.
	//

	if ( SPHyprMXRewardedVideoAdapterStateCannotDisplay != self.state ) {
    
		NSString * const errorDescription =	[NSString stringWithFormat:
			@"The display request is still in use."];

		SPLogWarn( errorDescription );
		
		return;
	}
    
	if ( !self.displayRequest ) {
    
    	return;
    
    }
    
    //
    // Dispose of display request.
    //
    
    self.state = SPHyprMXRewardedVideoAdapterStateCannotDisplay;
	
    [[HYPRManager sharedManager] removeDisplayRequest:self.displayRequest];
    
    self.displayRequest = nil;
}

- (void)requestHyprMXDisplay
{
	SP_HYPR_LOG_METHOD();

	//
	// Check state.
	//

	if ( SPHyprMXRewardedVideoAdapterStateRequestingDisplay == self.state ) {
    
    	// We are already requesting a display.
    	return;
    
    }
	
	if ( SPHyprMXRewardedVideoAdapterStateCannotDisplay != self.state ) {
    
		NSString * const errorDescription =	[NSString stringWithFormat:
			@"There is already a display request."];

		SPLogWarn( errorDescription );
		
		// NOTE: No SDK error class and codes exists so far.
		
		[self notifyDidFailWithError:[NSError 
			errorWithDomain:@"com.sponsorpay"
			code:0
			userInfo:@{ NSLocalizedDescriptionKey : errorDescription }]];
		
		return;
	}
	
	NSAssert(
		!self.displayRequest,
		@"Expecting self.displayRequest to be nil at this point.",
		NSStringFromClass( [HYPRDisplayRequest class] ) );

	//
    // Request display.
    //
    
	self.state = SPHyprMXRewardedVideoAdapterStateRequestingDisplay;

	self.displayRequest = [[HYPRManager sharedManager] 
    	addDisplayRequestWithPresentationDelegate:self];
}

- (void)displayHyprMXVideo
{
	SP_HYPR_LOG_METHOD();

	//
	// Check state.
	//
	
    if ( SPHyprMXRewardedVideoAdapterStateDisplaying == self.state )
    {
    	// We already display the video. Just leave.
    	return;
    }
    
	if ( 
    	SPHyprMXRewardedVideoAdapterStateCanDisplay != self.state 
        	&& SPHyprMXRewardedVideoAdapterStateCanDisplayRequiredInformation
            	!= self.state
    ){
	
		NSString * const errorDescription =	[NSString stringWithFormat:
			@"Did receive %@ message but %@ is not ready to play a video.",
			NSStringFromSelector( _cmd ),
			self];

		SPLogError( errorDescription );
		
		// NOTE: No SDK error class and codes exists so far.
		
		[self notifyDidFailWithError:[NSError 
			errorWithDomain:@"com.sponsorpay"
			code:0
			userInfo:@{ NSLocalizedDescriptionKey : errorDescription }]];
		
		return;
	}
	
	NSAssert(
		[self.displayRequest isKindOfClass:[HYPRDisplayRequest class]],
		@"Expecting self.displayRequest to be non-nil and kind of class %@ "
			"at this point.",
		NSStringFromClass( [HYPRDisplayRequest class] ) );
	
	//
	// Play the video.
	//
    
    self.state = SPHyprMXRewardedVideoAdapterStateDisplaying;
	
	[self.displayRequest display];
}

#pragma mark  
#pragma mark Notifying and Reporting to the Delegate

- (void)notifyDidFailWithError:(NSError *)error
{
	//
	// Check parameter.
	//
	
	NSAssert(
		[error isKindOfClass:[NSError class]],
		@"Expecting error parameter to be kind of class NSError." );

	//
    // Check state.
    //
    
	NSAssert( self.delegate, @"No delegate has been set." );

    NSAssert( 
    	[self.delegate respondsToSelector:
        	@selector( adapter:didFailWithError: )],
        @"Delegate does not respond to %@.",
        NSStringFromSelector( @selector( adapter:didFailWithError: ) ) );

	//
	// Notify the delegate.
	//
	
    [self.delegate adapter:self didFailWithError:error];
}

- (void)notifyVideoDidFinish
{
	//
    // Check state.
    //
    
	NSAssert( self.delegate, @"No delegate has been set." );

    NSAssert( 
    	[self.delegate respondsToSelector:
        	@selector( adapterVideoDidFinish: )],
        @"Delegate does not respond to %@.",
        NSStringFromSelector( @selector( adapterVideoDidFinish: ) ) );

	//
	// Notify the delegate.
	//
    
    [self.delegate adapterVideoDidFinish:self];
}

- (void)notifyVideoDidAbort
{
	//
    // Check state.
    //
    
	NSAssert( self.delegate, @"No delegate has been set." );

    NSAssert( 
    	[self.delegate respondsToSelector:
        	@selector( adapterVideoDidAbort: )],
        @"Delegate does not respond to %@.",
        NSStringFromSelector( @selector( adapterVideoDidAbort: ) ) );

    //
    // Notify delegate.
    //
    
    [self.delegate adapterVideoDidAbort:self];
}


- (void)notifyVideoDidClose
{
    //
    // Check state.
    //

    NSAssert( self.delegate, @"No delegate has been set." );

    NSAssert(
             [self.delegate respondsToSelector:@selector( adapterVideoDidClose: )],
             @"Delegate does not respond to %@.",
             NSStringFromSelector( @selector( adapterVideoDidClose: ) ) );

    //
    // Notify delegate.
    //

    [self.delegate adapterVideoDidClose:self];
}

- (void)notifyVideoDidStart
{
	//
    // Check state.
    //
    
	NSAssert( self.delegate, @"No delegate has been set." );

    NSAssert( 
    	[self.delegate respondsToSelector:
        	@selector( adapterVideoDidStart: )],
        @"Delegate does not respond to %@.",
        NSStringFromSelector( @selector( adapterVideoDidStart: ) ) );

    //
    // Notify delegate.
    //
    
    [self.delegate adapterVideoDidStart:self];
}

- (void)reportVideoAvailable:(BOOL)videoAvailable
{
	//
    // Check state.
    //
    
	NSAssert( self.delegate, @"No delegate has been set." );

    NSAssert( 
    	[self.delegate respondsToSelector:
        	@selector( adapter:didReportVideoAvailable: )],
        @"Delegate does not respond to %@.",
        NSStringFromSelector( @selector( adapter:didReportVideoAvailable: ) ) );

    //
    // Notify delegate.
    //
    
    [self.delegate 
        adapter:self 
        didReportVideoAvailable:videoAvailable ? YES : NO];
}

@end

#pragma mark  
