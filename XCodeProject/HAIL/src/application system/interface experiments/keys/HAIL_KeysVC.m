//
//  HAIL_PianoViewController.m
//  HAIL
//
//  Created by Sebastian on 2/27/13.
//  Copyright (c) 2013 com.hailbringer. All rights reserved.
//

#import "HAIL_KeysVC.h"

@implementation HAIL_KeysVC

- (void) didMoveToParentViewController:(UIViewController *)parent
{
	// find a size for the score view
	CGRect scrollFrame = [[self scrollView] frame];
	
	//NSLog(@"piano view was moved to parent controller");
	
	int pianoKeys = 24;
	float pianoKeyHeight = scrollFrame.size.height / 12; // maximum zoom: down to 3 keys
	float pianoFrameHeight = pianoKeys * pianoKeyHeight;
	float pianoFrameWidth = scrollFrame.size.width;
	
	CGRect pianoViewFrame = CGRectMake(0, 0, pianoFrameWidth, pianoFrameHeight);
	
	// blub
	[self setPianoView:[[HAIL_KeysView alloc] initWithFrame:pianoViewFrame]];
	[[self pianoView] setBackgroundColor:[UIColor colorWithRed:0.45
														 green:0.45
														  blue:0.45
														 alpha:1.0]];
	
	[[self scrollView] addSubview:[self pianoView]];
	[[self scrollView] setContentSize:pianoViewFrame.size];
	[[self scrollView] setMinimumZoomScale:scrollFrame.size.height / pianoViewFrame.size.height];
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	//NSLog(@"piano view did load");
}

- (void) viewWillAppear:(BOOL)animated
{
	//NSLog(@"piano view will appear");
	
	[[self scrollView] setZoomScale:[[self scrollView] minimumZoomScale] animated:NO];
}

@end
