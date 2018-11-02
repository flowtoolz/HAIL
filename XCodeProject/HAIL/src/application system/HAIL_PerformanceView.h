#import "HAIL_PresentationView.h"
#import "HAIL_PerformancePresentation.h"

@interface HAIL_PerformanceView : HAIL_PresentationView

@property (nonatomic, weak) HAIL_PerformancePresentation *performancePresentation;

- (void)updateScoreViews;

@end
