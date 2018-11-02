#import "HAIL_PerformanceView.h"
#import "HAIL_ScoreView.h"
#import "UIView+AutoLayout.h"

@implementation HAIL_PerformanceView

- (void)setPerformancePresentation:(HAIL_PerformancePresentation *)performancePresentation
{
    _performancePresentation = performancePresentation;
    
    HAIL_Color color = [_performancePresentation color];
    
    [self setBackgroundColor:[UIColor colorWithRed:color.red
                                             green:color.green
                                              blue:color.blue
                                             alpha:color.alpha]];
}

- (void)updateScoreViews
{
    for (UIView *subView in [self subviews])
        [subView removeFromSuperview];
    
    for (int i = 0; i < [[self performancePresentation] numberOfChildren]; i++)
    {
        HAIL_ScorePresentation *scorePresentation = (HAIL_ScorePresentation *)[[self performancePresentation] childAtIndex:i];
        
        [self createScoreViewForScorePresentation:scorePresentation];
    }
}

- (void)createScoreViewForScorePresentation:(HAIL_ScorePresentation *)scorePresentation
{
    // add and layout score view
    HAIL_ScoreView *scoreView = [HAIL_ScoreView autoLayoutView];
    
    [self addView:scoreView forPresentation:scorePresentation];
    
    // configure score view
    /*
    [[scoreView layer] setCornerRadius:20];
    [scoreView layer].masksToBounds = YES;
    */
    scoreView.layer.borderColor = [[UIColor blackColor] CGColor];
    scoreView.layer.borderWidth = 0.5f;
    
    /*
    scoreView.layer.shadowOffset = CGSizeMake(0, 0);
    scoreView.layer.shadowRadius = 3;
    scoreView.layer.shadowOpacity = 1.f;
    */
    
    [scoreView setScorePresentation:scorePresentation];
}
	
@end
