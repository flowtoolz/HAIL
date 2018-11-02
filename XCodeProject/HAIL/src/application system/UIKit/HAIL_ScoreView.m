#import "HAIL_ScoreView.h"
#import "UIView+AutoLayout.h"
#import "HAIL_EventView.h"
#import "HAIL_EventPresentation.h"

@interface HAIL_ScoreView ()

@property (nonatomic, strong) UIView *potentialEventView;

@end

@implementation HAIL_ScoreView

#pragma mark - touches

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    //NSLog(@"score view ... touch began");
    [super touchesBegan:touches withEvent:event];
    
    [[self potentialEventView] removeFromSuperview];
    [self setPotentialEventView:nil];
    
    // draw
    if ([HAIL_PresentationView singleFingerGesture])
    {
        UITouch *touch = [touches anyObject];
        
        CGPoint absolute = [touch locationInView:self];

        [self setPotentialEventView:[[UIView alloc] init]];
        UIColor *color = [UIColor colorWithRed:1.f
                                         green:0.f
                                          blue:0.f
                                         alpha:0.5f];
        [[self potentialEventView] setBackgroundColor:color];
        float cellWidth = [self frame].size.width / 16;
        int cell = absolute.x / cellWidth;
        absolute.x = (((float)cell) / 16) * [self frame].size.width;
        CGRect frame = CGRectMake(absolute.x,
                                  0,
                                  [self frame].size.width / 16,
                                  [self frame].size.height);
        [[self potentialEventView] setFrame:frame];
        
        
        [self addSubview:[self potentialEventView]];
    }
}

- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    // draw
    if (![HAIL_PresentationView singleFingerGesture])
        return;
    
    if ([self potentialEventView])
    {
        UITouch *touch = [touches anyObject];
        
        CGPoint absolute = [touch locationInView:self];
        
        float cellWidth = [self frame].size.width / 16;
        int cell = (absolute.x / cellWidth) + 1;
        absolute.x = (((float)cell) / 16) * [self frame].size.width;
        
        float maxX = [self frame].origin.x + [self frame].size.width;
        if (absolute.x > maxX)
            absolute.x = maxX;
        
        CGRect frame = [self potentialEventView].frame;
        
        frame.size.width = absolute.x - frame.origin.x;
        
        [[self potentialEventView] setFrame:frame];
    }
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    // no single finger gesture? -> done
    if (![HAIL_PresentationView singleFingerGesture])
        return;
    
    // touch up inside?
    UITouch *touch = [touches anyObject];
    
    CGPoint absolute = [touch locationInView:self];
    
    if ([self pointInside:absolute withEvent:event])
    {
        float viewWidth = [self frame].size.width;
        float start = [[self potentialEventView] frame].origin.x / viewWidth;
        float end = start + [[self potentialEventView] frame].size.width / viewWidth;
        
        [[self scorePresentation] viewWasMarkedFromRelativeStart:start
                                                           toEnd:end];
    }
    
    // remove editing view
    [[self potentialEventView] removeFromSuperview];
    [self setPotentialEventView:nil];
}

- (void)touchesCancelled:(NSSet *)touches
               withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    // remove editing view
    [[self potentialEventView] removeFromSuperview];
    [self setPotentialEventView:nil];
}

#pragma mark - other

- (void)setScorePresentation:(HAIL_ScorePresentation *)scorePresentation
{
    _scorePresentation = scorePresentation;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc removeObserver:self];
    
    if (scorePresentation == nil) return;
    
    // listening to the score presentation
    [nc addObserver:self
           selector:@selector(recievedScorePresentationChangedNotification:) name:@"HAIL_ScorePresentationChandedNotification"
             object:scorePresentation];

    // update event views
    [self updateEventViews];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)recievedScorePresentationChangedNotification:(NSNotification *)notification
{
    [self updateEventViews];
}

- (void)updateEventViews
{
    for (UIView *subview in [self subviews])
        [subview removeFromSuperview];
    
    for (int i = 0; i < [[self scorePresentation] numberOfChildren]; i++)
    {
        HAIL_EventPresentation *eventPresentation = (HAIL_EventPresentation *)[[self scorePresentation] childAtIndex:i];
        
        [self createEventViewForEventPresentation:eventPresentation];
    }
}

- (void)createEventViewForEventPresentation:(HAIL_EventPresentation *)eventPresentation
{
    // add and layout event view
    HAIL_EventView *eventView = [HAIL_EventView autoLayoutView];

    [eventView setPresentation:eventPresentation];
    
    [self addView:eventView forPresentation:eventPresentation];

    
    // configure
    [eventView setUserInteractionEnabled:NO];
}

- (void)scrollViewChangedZoomLevel
{
    [self updateEventViews];
}

- (void)singleFingerTouchEnded
{
    [[self potentialEventView] removeFromSuperview];
    [self setPotentialEventView:nil];
}

@end
