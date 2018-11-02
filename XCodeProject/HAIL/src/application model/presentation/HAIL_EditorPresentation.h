#import "HAIL_PerformancePresentation.h"
#import "HAIL_PartPresentation.h"
#import "HAIL_VoicePresentation.h"

@interface HAIL_EditorPresentation : HAIL_Presentation

#pragma mark - Input

- (void)playButtonPressed;

#pragma mark - Output

- (HAIL_PerformancePresentation *)performancePresentation;
- (HAIL_PartPresentation *)partPresentation;
- (HAIL_VoicePresentation *)voicePresentation;
- (HAIL_Presentation *)playButtonPresentation;

- (float)relativePlayingPosition;

@end