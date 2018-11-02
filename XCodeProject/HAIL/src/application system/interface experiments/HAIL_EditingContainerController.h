#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "HAIL_KeysVC.h"
#import "HAIL_ScoreVC.h"
#import "HAIL_WheelVC.h"
#import "HAIL_PerformanceVC.h"

@interface HAIL_EditingContainerController : UIViewController <UIScrollViewDelegate>

// container views from the .nib
@property (weak, nonatomic) IBOutlet UIView *keysContainerView;
@property (weak, nonatomic) IBOutlet UIView *scoreContainerView;
@property (weak, nonatomic) IBOutlet UIView *wheelContainerView;
@property (weak, nonatomic) IBOutlet UIView *performanceContainerView;

// content view controllers
@property (strong, nonatomic) HAIL_KeysVC *kvc;
@property (strong, nonatomic) HAIL_ScoreVC *svc;
@property (strong, nonatomic) HAIL_WheelVC *wvc;
@property (strong, nonatomic) HAIL_PerformanceVC *pvc;

// bring controllers to the screen
- (void)setContentController:(UIViewController*)controller
			 toContainerView:(UIView *)view;

@end
