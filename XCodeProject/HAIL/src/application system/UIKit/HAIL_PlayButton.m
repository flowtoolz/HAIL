#import "HAIL_PlayButton.h"

@implementation HAIL_PlayButton

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1.f);
    
    float symbolWidth = rect.size.width * 0.3;
    
    CGContextMoveToPoint(context,
                         rect.origin.x + (rect.size.width - symbolWidth) / 2,
                         rect.origin.y + (rect.size.height - symbolWidth) / 2);
    
    CGContextAddLineToPoint(context,
                            rect.origin.x + (rect.size.width - symbolWidth) / 2,
                            rect.origin.y + (rect.size.height + symbolWidth) / 2);
    
    CGContextAddLineToPoint(context,
                            rect.origin.x + (rect.size.width + symbolWidth) / 2,
                            rect.origin.y + 0.5 * rect.size.height);
    
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

@end
