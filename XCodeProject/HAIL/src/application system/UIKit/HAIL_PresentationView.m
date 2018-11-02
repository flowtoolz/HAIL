#import "HAIL_PresentationView.h"

@implementation HAIL_PresentationView

- (instancetype)init
{
    self = [super init];
    
    if (!self) return nil;
    
    [self initialize];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (!self) return nil;
    
    [self initialize];
    
    return self;
}

- (void)initialize
{
    [self setUserInteractionEnabled:YES];
    [self setMultipleTouchEnabled:YES];
}


+ (void)addView:(UIView *)view
forPresentation:(HAIL_Presentation *)presentation
    toSuperview:(UIView *)superView
     autolayout:(BOOL)autolayout
{
    // color
    [view setBackgroundColor:[UIColor colorWithRed:[presentation color].red
                                             green:[presentation color].green
                                              blue:[presentation color].blue
                                             alpha:[presentation color].alpha]];
    
    // without autolayout -> superview has a valid frame
    if (!autolayout)
    {
        CGRect parentFrame = [superView frame];
        CGRect relFrame = presentation.frame;
        CGRect absFrame;
        
        absFrame.origin.x = parentFrame.size.width * relFrame.origin.x;
        absFrame.origin.y = parentFrame.size.height * relFrame.origin.y;
        absFrame.size.width = parentFrame.size.width * relFrame.size.width;
        absFrame.size.height = parentFrame.size.height * relFrame.size.height;
       
        [view removeFromSuperview];
        [view setFrame:absFrame];
        [superView addSubview:view];
        
        return;
    }
    
    // with autolayout ...
    
    // add
    [view removeFromSuperview];
    [superView addSubview:view];
    
    // layout
    CGRect relativeFrame = [presentation frame];
    
    NSLayoutConstraint *con = nil;
    
    con = [NSLayoutConstraint constraintWithItem:view
                                       attribute:NSLayoutAttributeLeft
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:superView
                                       attribute:NSLayoutAttributeRight
                                      multiplier:relativeFrame.origin.x
                                        constant:0];
    
    [superView addConstraint:con];
    
    con = [NSLayoutConstraint constraintWithItem:view
                                       attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:superView
                                       attribute:NSLayoutAttributeBottom
                                      multiplier:relativeFrame.origin.y
                                        constant:0];
    
    [superView addConstraint:con];
    
    con = [NSLayoutConstraint constraintWithItem:view
                                       attribute:NSLayoutAttributeWidth
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:superView
                                       attribute:NSLayoutAttributeWidth
                                      multiplier:relativeFrame.size.width
                                        constant:0];
    
    [superView addConstraint:con];
    
    con = [NSLayoutConstraint constraintWithItem:view
                                       attribute:NSLayoutAttributeHeight
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:superView
                                       attribute:NSLayoutAttributeHeight
                                      multiplier:relativeFrame.size.height
                                        constant:0];
    
    [superView addConstraint:con];
}

+ (void)addView:(UIView *)view
forPresentation:(HAIL_Presentation *)presentation
    toSuperview:(UIView *)superView
{
    [HAIL_PresentationView addView:view
                   forPresentation:presentation
                       toSuperview:superView
                        autolayout:YES];
}

- (void)addView:(UIView *)view forPresentation:(HAIL_Presentation *)presentation;
{
    [HAIL_PresentationView addView:view
                   forPresentation:presentation
                       toSuperview:self];
}

#pragma mark - touch events

+ (NSMutableArray *)activeTouches
{
    static NSMutableArray *touches = nil;
    
    if (!touches)
        touches = [[NSMutableArray alloc] init];
    
    return touches;
}

static BOOL singleFingerGesture = NO;

+ (BOOL)singleFingerGesture
{
    return singleFingerGesture;
}

+ (void)setSingleFingerGesture:(BOOL)singleFinger
{
    singleFingerGesture = singleFinger;
    //NSLog(@"s t %@", singleFinger ? @"ON" : @"OFF");
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        if (![[HAIL_PresentationView activeTouches] containsObject:touch])
        {
            [[HAIL_PresentationView activeTouches] addObject:touch];
        }
    }
    
    [HAIL_PresentationView setSingleFingerGesture:[[HAIL_PresentationView activeTouches] count] == 1];
    
    [[self nextResponder] touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    [[self nextResponder] touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
        [[HAIL_PresentationView activeTouches] removeObject:touch];
    
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches
               withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
        [[HAIL_PresentationView activeTouches] removeObject:touch];
    
    [HAIL_PresentationView setSingleFingerGesture:NO];
    
    [[self nextResponder] touchesCancelled:touches withEvent:event];
}

- (void)scrollViewChangedZoomLevel
{
    for (UIView *subView in [self subviews])
    {
        if ([subView isKindOfClass:[HAIL_PresentationView class]])
        {
            HAIL_PresentationView *pv = (HAIL_PresentationView *)subView;
            [pv scrollViewChangedZoomLevel];
        }
    }
}

- (void)singleFingerTouchEnded
{
    for (UIView *subView in [self subviews])
    {
        if ([subView isKindOfClass:[HAIL_PresentationView class]])
        {
            HAIL_PresentationView *pv = (HAIL_PresentationView *)subView;
            [pv singleFingerTouchEnded];
        }
    }
}

@end


