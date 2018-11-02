#import <UIKit/UIKit.h>
#import "HAIL_Presentation.h"

@interface HAIL_PresentationView : UIControl

@property (nonatomic, weak) HAIL_Presentation *presentation;

- (void)addView:(UIView *)view forPresentation:(HAIL_Presentation *)presentation;
- (void)scrollViewChangedZoomLevel;
- (void)singleFingerTouchEnded;

+ (void)addView:(UIView *)view
forPresentation:(HAIL_Presentation *)presentation
    toSuperview:(UIView *)superView;

+ (void)addView:(UIView *)view
forPresentation:(HAIL_Presentation *)presentation
    toSuperview:(UIView *)superView
     autolayout:(BOOL)autolayout;

+ (NSMutableArray *)activeTouches;
+ (BOOL)singleFingerGesture;
+ (void)setSingleFingerGesture:(BOOL)singleFinger;

@end