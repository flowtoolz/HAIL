//
//  HAIL_PianoView.m
//  HAIL
//
//  Created by Sebastian on 2/27/13.
//  Copyright (c) 2013 com.hailbringer. All rights reserved.
//

#import "HAIL_KeysView.h"

@implementation HAIL_KeysView

- (void)drawRect:(CGRect)rect
{
	int numberOfKeys = 24;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect bounds = [self bounds];
	
	CGContextSetFlatness(context, 5.0);
	CGContextSetLineCap(context, kCGLineCapRound);
	
	//CGContextSetLineWidth(context, 10.0);
	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);

	float lineHeight = (bounds.size.height / numberOfKeys);

	CGRect keyRect;
	keyRect.origin.x = 0.0;
	keyRect.size.width = bounds.size.width;
	keyRect.size.height = 0.9 * lineHeight;
	
	for (int i = 0; i < numberOfKeys; i++)
	{
		keyRect.origin.y = (lineHeight * (numberOfKeys - 1 - i)) + 0.05 * lineHeight;
		
		float brightness = 1.0;
		
		switch (i % 12)
		{
			case 1:
			case 3:
			case 6:
			case 8:
			case 10: brightness = 0.0; break;
		}

		CGContextSetRGBFillColor(context, brightness, brightness, brightness, 1.0);
		CGContextFillRect(context, keyRect);
	}
}

- (void) setTransform:(CGAffineTransform)transform
{
	CGAffineTransform constrainedTransform = transform;

	constrainedTransform.a = 1.0;
	
	[super setTransform:constrainedTransform];
}

/*
- (CGAffineTransform) transform
{
	CGAffineTransform constrainedTransform = [super transform];
	
	constrainedTransform.a = constrainedTransform.d;
	
	return constrainedTransform;
}
*/

@end
