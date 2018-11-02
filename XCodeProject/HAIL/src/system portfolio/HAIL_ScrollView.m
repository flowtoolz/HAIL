#import "HAIL_ScrollView.h"
#import "UIView+AutoLayout.h"

@interface HAIL_ScrollView ()

@property (nonatomic, weak) HAIL_PresentationView *contentView;
@property (nonatomic, strong) UIView *overlay;
@property (nonatomic, strong) NSMutableArray *touches;
@property (nonatomic) BOOL changed;
@property (nonatomic) double lastMoveTime;
@property (nonatomic) CGPoint moveSpeed;
@property (nonatomic, strong) NSTimer *inertiaTimer;

@end

@implementation HAIL_ScrollView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (!self) return nil;
    
    [self initialize];
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    
    if (!self) return nil;
    
    [self initialize];
    
    return self;
}

- (void)initialize
{
    [self setClipsToBounds:YES];
    [self setMultipleTouchEnabled:YES];
    [self setBackgroundColor:[UIColor redColor]];
    [self setZoomX:1.f];
    [self setZoomY:1.f];
    [self setVerticalZoomDisabled:NO];
    [self setHorizontalZoomDisabled:NO];
    [self setChanged:NO];
}

- (NSMutableArray *)touches
{
    if (_touches) return _touches;
    
    _touches = [[NSMutableArray alloc] init];
    
    return _touches;
}

- (UIView *)overlay
{
    if (_overlay) return _overlay;
        
    _overlay = [[UIView alloc] init];
    [_overlay setHidden:YES];
    UIColor *color = [UIColor colorWithRed:1.f green:0.f blue:0.f alpha:0.5f];
    [_overlay setBackgroundColor:color];
    [_overlay setUserInteractionEnabled:NO];
    
    return _overlay;
}

- (void)setContentView:(HAIL_PresentationView *)contentView
{
    _contentView = contentView;
    
    [contentView removeFromSuperview];
    [self addSubview:contentView];
    
    contentView.layer.position = CGPointMake(0, 0);
    contentView.layer.anchorPoint = CGPointMake(0, 0);
    contentView.multipleTouchEnabled = YES;
    contentView.userInteractionEnabled = YES;
    
    CGRect frame = [self frame];
    frame.origin.x = 0.f;
    frame.origin.y = 0.f;
    contentView.frame = frame;
    
    [[self overlay] setFrame:[self frame]];
    [[self overlay] removeFromSuperview];
    [[self superview] addSubview:[self overlay]];
    [[self overlay] pinToSuperviewEdges:JRTViewPinAllEdges inset:0.f];
    
    [self setChanged:YES];
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    // proceed panning?
    if ([self moveSpeed].x != 0.f || [self moveSpeed].y != 0.f)
    {
        [HAIL_PresentationView setSingleFingerGesture:NO];
    }
    
    // stop inertia scrolling
    [[self inertiaTimer] invalidate];
    [self setMoveSpeed:CGPointZero];

    // multi finger gesture?
    if (![HAIL_PresentationView singleFingerGesture])
    {
        [self singleFingerTouchEnded];
        [[self overlay] setHidden:NO];
    }
    else
        [[self overlay] setHidden:YES];
}

- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    // the scroll view ignores single finger swipes
    if ([HAIL_PresentationView singleFingerGesture])
        return;
    
    // pinch or pan
    CGPoint previousBoundsOrigin = [self bounds].origin;
    
    if ([[HAIL_PresentationView activeTouches] count] == 2)
    {
        [self pinchWithTouch1:[[HAIL_PresentationView activeTouches] objectAtIndex:0]
                       touch2:[[HAIL_PresentationView activeTouches] objectAtIndex:1]];
    }
    else if ([[HAIL_PresentationView activeTouches] count] == 1)
    {
        [self panWithTouch:[[HAIL_PresentationView activeTouches] firstObject]];
    }
    
    // collision detection
    [self keepBoundsInContentFrame];
    
    // inform delegate about change
    if ([self changed])
    {
        [[self delegate] scrollViewDidChange:self];
        [self setChanged:NO];
    }
    
    // measure speed
    [self measureSpeedForInertiaScrolling:previousBoundsOrigin];
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    if ([HAIL_PresentationView singleFingerGesture])
    {
        [[self overlay] setHidden:YES];
        return;
    }
    
    if ([[HAIL_PresentationView activeTouches] count] == 0)
    {
        //NSLog(@"about to inertia scoll? speed = %f / %f", [self moveSpeed].x, [self moveSpeed].y);
        
        if ([self moveSpeed].x > 10.f || [self moveSpeed].x < -10.f ||
            [self moveSpeed].y > 10.f || [self moveSpeed].y < -10.f)
        {
            [self setInertiaTimer:[NSTimer scheduledTimerWithTimeInterval:0.02
                                                                   target:self
                                                                 selector:@selector(inertiaTimeEvent)
                                                                 userInfo:nil
                                                                  repeats:YES]];
        }
        else
            [[self overlay] setHidden:YES];
        
        // redraw content view
        [[self contentView] scrollViewChangedZoomLevel];
    }
}

- (void)touchesCancelled:(NSSet *)touches
               withEvent:(UIEvent *)event
{
    //NSLog(@"scroll view cancelled");
    [[self inertiaTimer] invalidate];
}

#pragma mark - Panning & Zooming

- (void)panWithTouch:(UITouch *)touch
{
    CGPoint newPos = [touch locationInView:self];
    CGPoint oldPos = [touch previousLocationInView:self];
    
    CGPoint delta = CGPointMake(oldPos.x - newPos.x,
                                oldPos.y - newPos.y);
    
    if (delta.x != 0.f || delta.y != 0.f)
    {
        [self moveContentOffset:delta];
        [self setChanged:YES];
    }
}

- (void)pinchWithTouch1:(UITouch *)touch1
                 touch2:(UITouch *)touch2
{
    // bei ...locationIn... ist der offset (bounds) schon eingerechnet!!!
    CGPoint newPos1 = [touch1 locationInView:self];
    CGPoint oldPos1 = [touch1 previousLocationInView:self];
    
    CGPoint newPos2 = [touch2 locationInView:self];
    CGPoint oldPos2 = [touch2 previousLocationInView:self];
    
    // scale both dimension
    float minPinchStartDist = 50.f;
    
    if (![self horizontalZoomDisabled])
    {
        float oldDistX = abs(oldPos1.x - oldPos2.x);
        
        if (oldDistX > minPinchStartDist)
        {
            float newDistX = abs(newPos1.x - newPos2.x);
            
            float zoomFactorX = newDistX / oldDistX;
            
            self.zoomX *= zoomFactorX;
            
            if (self.zoomX < 1.f)
                self.zoomX = 1.f;
            else if (self.zoomX > 4.f)
                self.zoomX = 4.f;
            
            [self setChanged:YES];
        }
    }
    
    if (![self verticalZoomDisabled])
    {
        float oldDistY = abs(oldPos1.y - oldPos2.y);
        
        if (oldDistY > minPinchStartDist)
        {
            float newDistY = abs(newPos1.y - newPos2.y);
            
            float zoomFactorY = newDistY / oldDistY;
            
            self.zoomY *= zoomFactorY;
            
            if (self.zoomY < 1.f)
                self.zoomY = 1.f;
            else if (self.zoomY > 4.f)
                self.zoomY = 4.f;
            
            [self setChanged:YES];
        }
    }
    
    if (![self changed]) return;
    
    // prepare panning
    CGPoint oldPinchCenter = CGPointMake((oldPos1.x + oldPos2.x) / 2.f,
                                         (oldPos1.y + oldPos2.y) / 2.f);
    CGPoint newPinchCenter = CGPointMake((newPos1.x + newPos2.x) / 2.f,
                                         (newPos1.y + newPos2.y) / 2.f);
    
    CGRect contentFrame = [self contentView].frame;
    
    CGPoint relContentPos;
    relContentPos.x = oldPinchCenter.x / contentFrame.size.width;
    relContentPos.y = oldPinchCenter.y / contentFrame.size.height;
    
    // zoom content by resizing it
    contentFrame.size.width = self.bounds.size.width * self.zoomX;
    contentFrame.size.height = self.bounds.size.height * self.zoomY;
    [[self contentView] setFrame:contentFrame];
    
    // pan
    CGRect bounds = [self bounds];
    CGPoint newScreenPos;
    newScreenPos.x = newPinchCenter.x - bounds.origin.x;
    newScreenPos.y = newPinchCenter.y - bounds.origin.y;
    bounds.origin.x = (relContentPos.x * contentFrame.size.width) - newScreenPos.x;
    bounds.origin.y = (relContentPos.y * contentFrame.size.height) - newScreenPos.y;
    [self setBounds:bounds];
}

- (void)keepBoundsInContentFrame
{
    CGRect contentFrame = [[self contentView] frame];
    CGRect bounds = [self bounds];
    CGPoint speed = [self moveSpeed];
    
    if (bounds.origin.x < 0.f)
    {
        bounds.origin.x = 0.f;
        speed.x = 0.f;
        [self setChanged:YES];
    }
    else if (bounds.origin.x > contentFrame.size.width - bounds.size.width)
    {
        bounds.origin.x = contentFrame.size.width - bounds.size.width;
        speed.x = 0.f;
        [self setChanged:YES];
    }
    
    if (bounds.origin.y < 0.f)
    {
        bounds.origin.y = 0.f;
        speed.y = 0.f;
        [self setChanged:YES];
    }
    else if (bounds.origin.y > contentFrame.size.height - bounds.size.height)
    {
        bounds.origin.y = contentFrame.size.height - bounds.size.height;
        speed.y = 0.f;
        [self setChanged:YES];
    }
    
    [self setBounds:bounds];
    [self setMoveSpeed:speed];
}

#pragma mark - Inertia Scrolling

- (void)measureSpeedForInertiaScrolling:(CGPoint)previousBoundsOrigin
{
    // inertia scrolling
    double now = CACurrentMediaTime();
    
    if ([self lastMoveTime] > 0.0)
    {
        // measure time
        double moveDuration = now - [self lastMoveTime];
        
        // calculate speed for inertia scrolling
        CGPoint boundsOrigin = [self bounds].origin;
        
        CGPoint velocity = CGPointMake(boundsOrigin.x - previousBoundsOrigin.x,
                                       boundsOrigin.y - previousBoundsOrigin.y);
        
        CGPoint currentSpeed = CGPointMake(velocity.x / moveDuration,
                                           velocity.y / moveDuration);
        
        if ([self moveSpeed].x == 0.0 && [self moveSpeed].y == 0.0)
            [self setMoveSpeed:currentSpeed];
        else
        {
            CGPoint smoothSpeed;
            
            smoothSpeed.x = 0.6 * self.moveSpeed.x + 0.4 * currentSpeed.x;
            smoothSpeed.y = 0.6 * self.moveSpeed.y + 0.4 * currentSpeed.y;
            
            self.moveSpeed = smoothSpeed;
            
            //NSLog(@"moving pixels per second: x->%f   y->%f", smoothSpeed.x, smoothSpeed.y);
        }
    }
    
    [self setLastMoveTime:now];
}

- (void)inertiaTimeEvent
{
    //NSLog(@"should inertia scroll");

    // move bounds
    CGPoint move = CGPointMake(0.02 * [self moveSpeed].x,
                               0.02 * [self moveSpeed].y);
    
    [self moveContentOffset:move];
    [self keepBoundsInContentFrame];
    [[self delegate] scrollViewDidChange:self];
    
    // reduce speed
    CGPoint speed = [self moveSpeed];
    
    float speedReduction = 0.95f;
    float thresholdToStop = 10.f;
    
    if (speed.x > 0)
    {
        speed.x *= speedReduction;
        
        if (speed.x < thresholdToStop)
            speed.x = 0;
    }
    else
    {
        speed.x *= speedReduction;
        
        if (speed.x > -thresholdToStop)
            speed.x = 0;
    }
    
    if (speed.y > 0)
    {
        speed.y *= speedReduction;
        
        if (speed.y < thresholdToStop)
            speed.y = 0;
    }
    else
    {
        speed.y *= speedReduction;
        
        if (speed.y > -thresholdToStop)
            speed.y = 0;
    }
    
    [self setMoveSpeed:speed];
    
    // stopped? -> deactivate timer and hide overlay
    if (speed.x == 0 && speed.y == 0)
    {
        [[self inertiaTimer] invalidate];
        [[self overlay] setHidden:YES];
    }
}

#pragma mark - change panning position

- (void)setContentOffset:(CGPoint)offset
{
    CGRect bounds = [self bounds];
    bounds.origin = offset;
    [self setBounds:bounds];
}

- (void)moveContentOffset:(CGPoint)delta
{
    CGRect bounds = [self bounds];
    bounds.origin.x += delta.x;
    bounds.origin.y += delta.y;
    [self setBounds:bounds];
}

#pragma mark - Sync

- (void)adjustToScrollView:(HAIL_ScrollView *)scrollView
{
    CGRect contentFrame = [[self contentView] frame];
    CGRect bounds = [self bounds];
    
    if (![self horizontalZoomDisabled] &&
        ![scrollView horizontalZoomDisabled])
    {
        contentFrame.size.width = self.bounds.size.width * scrollView.zoomX;
        bounds.origin.x = [scrollView bounds].origin.x;
        self.zoomX = scrollView.zoomX;
    }
    
    if (![self verticalZoomDisabled] &&
        ![scrollView verticalZoomDisabled])
    {
        contentFrame.size.height = self.bounds.size.height * scrollView.zoomY;
        bounds.origin.y = [scrollView bounds].origin.y;
        self.zoomY = scrollView.zoomY;
    }
    
    [[self contentView] setFrame:contentFrame];
    [self setBounds:bounds];
}

@end
