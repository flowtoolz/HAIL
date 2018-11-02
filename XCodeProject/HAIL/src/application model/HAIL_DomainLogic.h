#import "HAIL_AudioPlayerProtocol.h"
#import "HAIL_Performance.h"
#import "HAIL_MusicLibrary.h"

@interface HAIL_DomainLogic : NSObject

#pragma mark - domain objects

@property (nonatomic, strong) HAIL_MusicLibrary *musicLibrary;
@property (nonatomic, strong) HAIL_AudioPlayer *player;
@property (nonatomic, strong) HAIL_Performance *performance;

#pragma mark - create content

- (void)addNewPart;
- (void)addNewPartWithNumberOfFrames:(NSUInteger)frames;

- (void)addNewVoice;
- (void)addNewVoiceWithAudioData:(NSUInteger)audioIndex;

- (void)addNewScore;

#pragma mark - singleton access

+ (HAIL_DomainLogic *)singleton;

@end
