#import "HAIL_ScoreViewOLD.h"
#import "HAIL_KeysView.h"

@implementation HAIL_ScoreViewOLD

// responding to touch events

- (void)drawRect:(CGRect)rect
{
	int numberOfKeys = 24;
	int beats = 8;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect bounds = [self bounds];
	float lineHeight = (bounds.size.height / numberOfKeys);
	float beatWidth = bounds.size.width / beats;
	

	CGContextSetLineWidth(context, 0.1 * lineHeight);
	CGContextSetRGBStrokeColor(context, 0.45, 0.45, 0.45, 1.0);
	CGContextBeginPath(context);

	for (int i = 0; i <= numberOfKeys; i++)
	{
		float y = (lineHeight * i);
		
		CGContextMoveToPoint(context, bounds.origin.x, y);
		CGContextAddLineToPoint(context, bounds.origin.x + bounds.size.width, y);
	}
	
	CGContextClosePath(context);
	CGContextStrokePath(context);

	CGContextSetLineWidth(context, 3 * sqrt(1.0 / [self transform].d));
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

@end
