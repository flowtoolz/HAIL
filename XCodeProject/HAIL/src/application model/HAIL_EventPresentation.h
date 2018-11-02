#import "HAIL_Presentation.h"
#import "HAIL_AudioSourceProtocol.h"

@interface HAIL_EventPresentation : HAIL_Presentation

@property (nonatomic, weak) HAIL_AudioSource *audioSource;
@property (nonatomic) NSUInteger numberOfFrames;

@end
