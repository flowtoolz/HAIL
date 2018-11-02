#import "HAIL_Presentation.h"
#import "HAIL_Score.h"
#import "HAIL_Part.h"
#import "HAIL_Voice.h"

@interface HAIL_ScorePresentation : HAIL_Presentation

@property (nonatomic, weak) HAIL_Score *score;
@property (nonatomic, weak) HAIL_Voice *voice;

- (void)addEventsOfScore:(HAIL_Score *)score;
- (void)viewWasMarkedFromRelativeStart:(float)start
                                 toEnd:(float)end;

@end