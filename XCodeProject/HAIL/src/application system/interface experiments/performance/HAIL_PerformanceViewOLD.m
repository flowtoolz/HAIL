//
//  HAIL_PerformanceView.m
//  HAIL
//
//  Created by Sebastian on 2/28/13.
//  Copyright (c) 2013 com.hailbringer. All rights reserved.
//

#import "HAIL_PerformanceViewOLD.h"

@implementation HAIL_PerformanceViewOLD

- (void)drawRect:(CGRect)rect
{
	int beats = 8;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect bounds = [self bounds];
	float beatWidth = bounds.size.width / beats;

	CGContextSetLineWidth(context, 3 * sqrt(1.0 / [self transform].a));
	CGContextSetRGBStrokeColor(context, 1, 1, 1, 0.1);
	CGContextBeginPath(context);
	
	for (int i = 1; i < bounds.size.width / beatWidth; i++)
	{
		float x = (beatWidth * i);
		
		CGContextMoveToPoint(context, x, bounds.origin.y);
		CGContextAddLineToPoint(context, x, bounds.origin.y + bounds.size.height);
	}
	
	CGContextClosePath(context);
	CGContextStrokePath(context);
}

- (void) setTransform:(CGAffineTransform)transform
{
	CGAffineTransform constrainedTransform = transform;
	
	constrainedTransform.d = 1.0;
	
	[super setTransform:constrainedTransform];
}

@end
