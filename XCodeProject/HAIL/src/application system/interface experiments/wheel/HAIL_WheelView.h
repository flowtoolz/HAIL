#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HAIL_WheelView : UIView
{
	float rotation;
	float radius;
	CGRect bounds;
	CGPoint center;
}

- (void) rotate:(float)rotationChange;

@end
