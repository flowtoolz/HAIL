#import "HAIL_DomainLogic.h"
#import "HAIL_Synthesizer.h"
#import "HAIL_Voice.h"
#import "HAIL_Part.h"

@implementation HAIL_DomainLogic

#pragma mark - content creation

- (void)addNewPart
{
    HAIL_Part *part = [[HAIL_Part alloc] init];
    [[[[self musicLibrary] partLibrary] partArray] addObject:part];
}

- (void)addNewPartWithNumberOfFrames:(NSUInteger)frames
{
    HAIL_Part *part = [[HAIL_Part alloc] init];
    [part setNumberOfFrames:frames];
    [[[[self musicLibrary] partLibrary] partArray] addObject:part];
}

- (void)addNewVoiceWithAudioData:(NSUInteger)audioIndex
{
    HAIL_MusicLibrary *library = [self musicLibrary];
    
    HAIL_AudioData *audioData = [[library audioLibrary] audioDataAt:audioIndex];

    HAIL_Voice *voice = [[HAIL_Voice alloc] init];
    [voice setAudioSource:audioData];
    [[[library voiceLibrary] voiceArray] addObject:voice];
}

- (void)addNewVoice
{
    HAIL_Voice *voice = [[HAIL_Voice alloc] init];
    [[[[self musicLibrary] voiceLibrary] voiceArray] addObject:voice];
}

- (void)addNewScore
{
    HAIL_Score *score = [[HAIL_Score alloc] init];
    [[[self musicLibrary] scoreLibrary] addScore:score];
}

#pragma mark - access

- (HAIL_Performance *)performance
{
    if (!_performance)
    {
        _performance = [[HAIL_Performance alloc] init];
        [_player setAudioSource:_performance];
        [_performance setMusicLibrary:[self musicLibrary]];
    }
    
    return _performance;
}

- (void)setPlayer:(HAIL_AudioPlayer *)player
{
    _player = player;
    
    [_player setAudioSource:[self performance]];
}

- (HAIL_MusicLibrary *)musicLibrary
{
    if (!_musicLibrary)
        _musicLibrary = [[HAIL_MusicLibrary alloc] init];
    
    return _musicLibrary;
}

#pragma mark - Singleton Access

+ (HAIL_DomainLogic *)singleton
{
	static HAIL_DomainLogic *dw = nil;
	
	if (!dw)
	{
		dw = [[super allocWithZone:nil] init];
	}
	
	return dw;
}

+ (id)allocWithZone:(NSZone *)zone
{
	return [self singleton];
}

@end
