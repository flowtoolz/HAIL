//
//  HAIL_EditingContainerController.m
//  HAIL
//
//  Created by Sebastian on 2/27/13.
//  Copyright (c) 2013 com.hailbringer. All rights reserved.
//

#import "HAIL_EditingContainerController.h"

@implementation HAIL_EditingContainerController

{}

#pragma mark - View Delegate Protocol

- (void)viewDidLoad
{
	//NSLog(@"editing view did load");
	
	// adjust view
	[super viewDidLoad];
	
	// performance
	[self setPvc:[[HAIL_PerformanceVC alloc] init]];
	[self setContentController:[self pvc]
			   toContainerView:[self performanceContainerView]];
	[[[self pvc] scrollView] setDelegate:self];
	
	// keys
	[self setKvc:[[HAIL_KeysVC alloc] init]];
	[self setContentController:[self kvc]
			   toContainerView:[self keysContainerView]];
	[[[self kvc] scrollView] setDelegate:self];
	
	// score
	[self setSvc:[[HAIL_ScoreVC alloc] init]];
	[self setContentController:[self svc]
			   toContainerView:[self scoreContainerView]];
	[[[self svc] scrollView] setDelegate:self];
	
	// wheel
	[self setWvc:[[HAIL_WheelVC alloc] init]];
	[self setContentController:[self wvc]
			   toContainerView:[self wheelContainerView]];
}

#pragma mark - Loading Content Controllers

- (void)setContentController:(UIViewController*)controller
			 toContainerView:(UIView *)view
{
	// catch nil input
	if (!controller || !view)
	{
		NSLog(@"error: content controller or container view nil");
		return;
	}
	
	// push new controller on the stack
	[self addChildViewController:controller];
	
	// the new controller's frame
	CGRect frame = [view frame];
	frame.origin = CGPointMake(0, 0);
	[[controller view] setFrame:frame];
	
	// add new controller's view
	for (UIView *subview in [view subviews])
		[subview removeFromSuperview];
	
	[view addSubview:[controller view]];
	
	// inform new controller
	[controller didMoveToParentViewController:self];
	
	return;
}

#pragma mark - Scroll View Delegate Protocol

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	if ([scrollView isEqual:[[self svc] scrollView]])
		return [[self svc] scoreView];
	
	if ([scrollView isEqual:[[self kvc] scrollView]])
		return [[self kvc] pianoView];
	
	if ([scrollView isEqual:[[self pvc] scrollView]])
		return [[self pvc] performanceView];
	
	return nil;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self synchronizeScrollViewsToScrollView:scrollView];
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView
{
	[self synchronizeScrollViewsToScrollView:scrollView];
}

#pragma mark - Synchronizing Scrolls and Zooms

- (void) synchronizeScrollViewsToScrollView:(UIScrollView *)scrollView
{
	// keys are master
	if ([scrollView isEqual:[[self kvc] scrollView]])
	{
		if (![[[self kvc] pianoView] syncMaster]) return;
		
		//NSLog(@"keys are master");
		
		// zoom
		float scale = [[[self svc] scrollView] zoomScale];
		
		if (scale != [[[self kvc] pianoView] transform].d)
		{
			scale = [[[self kvc] pianoView] transform].d;
			[[[self svc] scrollView] setZoomScale:scale animated:NO];
		}
		
		// offset
		CGPoint scoreOffset = [[[self svc] scrollView] contentOffset];
		scoreOffset.y = [[[self kvc] scrollView] contentOffset].y;
		[[[self svc] scrollView] setContentOffset:scoreOffset animated:NO];
	}
	// performance is master
	else if ([scrollView isEqual:[[self pvc] scrollView]])
	{
		if (![[[self pvc] performanceView] syncMaster]) return;
		
		//NSLog(@"performance is master");
		
		// zoom
		float scale = [[[self svc] scrollView] zoomScale];
		
		if (scale != [[[self pvc] performanceView] transform].a)
		{
			scale = [[[self pvc] performanceView] transform].a;
			[[[self svc] scrollView] setZoomScale:scale animated:NO];
		}
		
		// offset
		CGPoint scoreOffset = [[[self svc] scrollView] contentOffset];
		scoreOffset.x = [[[self pvc] scrollView] contentOffset].x;
		[[[self svc] scrollView] setContentOffset:scoreOffset animated:NO];
	}
	// score is master
	else
	{
		if (![[[self svc] scoreView] syncMaster]) return;
		
		//NSLog(@"score is master");
		
		// zoom
		float scale = [[[self svc] scrollView] zoomScale];
		[[[self kvc] scrollView] setZoomScale:scale animated:NO];
		[[[self pvc] scrollView] setZoomScale:scale animated:NO];
	
		// offset
		CGPoint offset = [[[self kvc] scrollView] contentOffset];
		offset.y = [[[self svc] scrollView] contentOffset].y;
		offset.x = 0;
		[[[self kvc] scrollView] setContentOffset:offset animated:NO];
		
		offset = [[[self pvc] scrollView] contentOffset];
		offset.y = 0;
		offset.x = [[[self svc] scrollView] contentOffset].x;
		[[[self pvc] scrollView] setContentOffset:offset animated:NO];
	}
}

@end
