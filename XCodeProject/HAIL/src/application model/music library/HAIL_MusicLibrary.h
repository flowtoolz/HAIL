#import "HAIL_AudioLibrary.h"
#import "HAIL_VoiceLibrary.h"
#import "HAIL_PartLibrary.h"
#import "HAIL_ScoreLibrary.h"
#import "HAIL_Part.h"
#import "HAIL_Voice.h"

@interface HAIL_MusicLibrary : NSObject

#pragma mark - Sub-Libraries

@property (nonatomic, strong) HAIL_AudioLibrary *audioLibrary;
@property (nonatomic, strong) HAIL_VoiceLibrary *voiceLibrary;
@property (nonatomic, strong) HAIL_PartLibrary *partLibrary;
@property (nonatomic, strong) HAIL_ScoreLibrary *scoreLibrary;

#pragma mark - mapping scores to part/voice-combinations

- (HAIL_Score *)scoreForPart:(HAIL_Part *)part
                       voice:(HAIL_Voice *)voice;

- (void)associateScore:(HAIL_Score *)score
              withAtomicPart:(HAIL_Part *)part
              atomicVoice:(HAIL_Voice *)voice;

#pragma mark - Accessing Audio

- (float)frameAt:(NSUInteger)index
         forPart:(HAIL_Part *)part
        andVoice:(HAIL_Voice *)voice;

@end
