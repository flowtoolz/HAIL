#import "HAIL_PresentationView.h"
#import "HAIL_ScorePresentation.h"

@interface HAIL_ScoreView : HAIL_PresentationView

@property (nonatomic, weak) HAIL_ScorePresentation *scorePresentation;

- (void)updateEventViews;

@end
