#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "HAIL_ScoreViewOLD.h"

@interface HAIL_ScoreVC : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) HAIL_ScoreViewOLD *scoreView;

@end
