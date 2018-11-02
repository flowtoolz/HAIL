#import "HAIL_EventView.h"
#import "HAIL_EventPresentation.h"

@implementation HAIL_EventView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2.f);

    HAIL_EventPresentation *pres = (HAIL_EventPresentation *)[self presentation];
    HAIL_AudioSource *as = [pres audioSource];

    NSUInteger eventFrames = [pres numberOfFrames];
    
    int numLines = rect.size.width;
    for (int i = 0; i < numLines; i += 4)
    {
        NSUInteger frameIndex = (((float)i) / rect.size.width) * eventFrames;
        float frame = [as elongationAtFrameIndex:frameIndex];
        if (frame < 0.f) frame *= -1;
        float lineHeight = rect.size.height * frame;
        float lineTop = rect.origin.y + ((1.f - frame) / 2) * rect.size.height;
        
        CGContextMoveToPoint(context, i, lineTop);
        
        CGContextAddLineToPoint(context, i, lineTop + lineHeight);
    }
    
    CGContextStrokePath(context);
}

@end
