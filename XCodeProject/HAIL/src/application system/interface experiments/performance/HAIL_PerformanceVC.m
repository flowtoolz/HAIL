//
//  HAIL_PerformanceViewController.m
//  HAIL
//
//  Created by Sebastian on 2/28/13.
//  Copyright (c) 2013 com.hailbringer. All rights reserved.
//

#import "HAIL_PerformanceVC.h"

@implementation HAIL_PerformanceVC

- (void) didMoveToParentViewController:(UIViewController *)parent
{
	//NSLog(@"performance view was moved to parent controller");
	
	// find a size for the performance view
	CGRect scrollFrame = [[self scrollView] frame];
	
	float scrollViewAspectRatio = scrollFrame.size.width / scrollFrame.size.height;
	
	int pianoKeys = 24;
	float pianoKeyHeight = scrollFrame.size.height / 12; // maximum zoom: down to 3 keys
	float scoreFrameHeight = pianoKeys * pianoKeyHeight;
	float scoreFrameWidth = scoreFrameHeight * scrollViewAspectRatio;
	
	CGRect performanceViewFrame = CGRectMake(0,
											 0,
											 scoreFrameWidth,
											 scrollFrame.size.height);
	
	// blub
	[self setPerformanceView:[[HAIL_PerformanceViewOLD alloc] initWithFrame:performanceViewFrame]];
	[[self performanceView] setBackgroundColor:[UIColor clearColor]];
	
	[[self scrollView] addSubview:[self performanceView]];
	[[self scrollView] setContentSize:performanceViewFrame.size];
	[[self scrollView] setMinimumZoomScale:scrollFrame.size.width /
	 										performanceViewFrame.size.width];
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	//NSLog(@"performance view did load");
}

- (void) viewWillAppear:(BOOL)animated
{
	//NSLog(@"performance view will appear");
	
	[[self scrollView] setZoomScale:[[self scrollView] minimumZoomScale] animated:NO];
}

@end
