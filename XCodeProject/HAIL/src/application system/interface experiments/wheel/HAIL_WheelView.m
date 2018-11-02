#import "HAIL_WheelView.h"
#import "HAIL_InterfaceConfiguration.h"

@implementation HAIL_WheelView

// init

- (void) didMoveToWindow
{
	[super didMoveToWindow];
	
	bounds = [self bounds];
	center = CGPointMake(bounds.origin.x + bounds.size.width / 2,
						 bounds.origin.y + bounds.size.height / 2);
	radius = MIN(bounds.size.width, bounds.size.height) / 2 - 10.0;
	rotation = 0.0;
}

// rotation

- (void) rotate:(float)rotationChange
{
	if (rotationChange == 0) return;
	
	rotation += rotationChange;
	
	//rotation -= (int) rotation;
	
	//if (rotation < 0) rotation += 1.0;

	[self setNeedsDisplay];
}

// responding to touch events

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches)
	{
		// get the points
		CGPoint oldPos = [touch previousLocationInView:self];
		CGPoint newPos = [touch locationInView:self];

		// are we far enough from the center?
		float oldCenterDist = sqrtf(powf(oldPos.x - center.x, 2) +
									powf(oldPos.y - center.y, 2));
		float newCenterDist = sqrtf(powf(newPos.x - center.x, 2) +
									powf(newPos.y - center.y, 2));
		
		if (oldCenterDist < radius / 3 || newCenterDist < radius / 3)
			continue;
		
		// angles
		float moveX = newPos.x - oldPos.x;
		float moveY = newPos.y - oldPos.y;
		
		float moveDist = sqrtf(moveX * moveX + moveY * moveY);
		
		float angle = powf(oldCenterDist, 2) + powf(newCenterDist, 2) - powf(moveDist, 2);
		angle = acosf(angle / (2 * oldCenterDist * newCenterDist));
		
		// direction
		BOOL right = YES;

		if (newPos.x > center.x && oldPos.x > center.x)
		{
			if (moveY < 0)
			{
				right = NO;
				
				//NSLog(@"1: moveY=%f", moveY);
			}
		}
		if (newPos.x < center.x && oldPos.x < center.x)
		{
			if (moveY > 0)
			{
				right = NO;
				
				//NSLog(@"2: moveY=%f", moveY);
			}
		}
		if (newPos.y < center.y && oldPos.y < center.y)
		{
			if (moveX < 0)
			{
				right = NO;
				
				//NSLog(@"3: moveX=%f", moveX);
			}
		}
		if (newPos.y > center.y && oldPos.y > center.y)
		{
			if (moveX > 0)
			{
				right = NO;
				
				//NSLog(@"4: moveX=%f", moveX);
			}
		}
		/*
		float newV = newPos.x - center.x;
		float newU = newPos.y - center.y;
		float oldV = oldPos.x - center.x;
		float oldU = oldPos.y - center.y;
		
		float v = newV;
		float u = newU;
		
		float direction = (u * u) * moveY * v - (v * v) * moveX * u;

		if (direction < 0) angle *= -1;
		
		if (direction <0)
		{
			NSLog(@"Links: %f", angle / (2 * M_PI));
			
			NSLog(@"move: %f   %f", moveX, moveY);
			
			NSLog(@"v: %f    u: %f", v, u);
		}
		*/
		
		if (!right) angle *= -1.0;
		
		// rotate
		[self rotate:angle / (2 * M_PI)];
		
		break;
	}
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

// drawing

- (void)drawRect:(CGRect)rect
{	
	// input data
	NSMutableArray *colorArray = [[HAIL_InterfaceConfiguration singleton] soundColorArray];
	int numberOfColors = [colorArray count];
	float fraction = 1.0 / numberOfColors;
	float pieAngle = fraction * 2 * M_PI;
	float offsetAngle = rotation * 2 * M_PI;
	float red, green, blue;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// for all pie slices
	for (int i = 0; i < numberOfColors; i++)
	{
		float startAngle = (pieAngle * i) + offsetAngle;
		float endAngle = startAngle + pieAngle;
	
		CGContextBeginPath(context);
	
		CGContextMoveToPoint(context, center.x, center.y);
	
		CGContextAddArc(context,
						center.x,
						center.y,
						radius,
						startAngle,
						endAngle,
						0);
	
		CGContextClosePath(context);
		
		[[colorArray objectAtIndex:i] getRed:&red
									   green:&green
										blue:&blue
									   alpha:nil];
		
		CGContextSetRGBFillColor(context, red, green, blue, 1.0);
		
		CGContextFillPath(context);
	}
	
	// white circle on top
	CGContextBeginPath(context);
	
	CGContextMoveToPoint(context, center.x, center.y);
	
	CGContextAddArc(context,
					center.x,
					center.y,
					radius / 2,
					0,
					2 * M_PI,
					0);
	
	CGContextClosePath(context);
		
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	
	CGContextFillPath(context);
}

@end
