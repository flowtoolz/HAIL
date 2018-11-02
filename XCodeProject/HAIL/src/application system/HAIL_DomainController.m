#import "HAIL_DomainController.h"
#import "HAIL_DomainLogic.h"
#import "HAIL_TAAEAudioPlayer.h"
#import "HAIL_TAAEAudioFile.h"

@implementation HAIL_DomainController

- (void)injectAudioIntoDomain
{
    // files
    [self addAudioDataToDomainUsingFile:@"DrumHits/Kick01.wav"];
    [self addAudioDataToDomainUsingFile:@"DrumHits/Snare01.wav"];
    [self addAudioDataToDomainUsingFile:@"DrumHits/Closedhat01.wav"];
    [self addAudioDataToDomainUsingFile:@"DrumHits/Openhat01.wav"];
    [self addAudioDataToDomainUsingFile:@"DrumHits/Cymbal01.wav"];
    [self addAudioDataToDomainUsingFile:@"DrumHits/Shaker01.wav"];
    
    // player
    HAIL_DomainLogic *domain = [HAIL_DomainLogic singleton];
    [domain setPlayer:[[HAIL_TAAEAudioPlayer alloc] init]];
}

- (void)addAudioDataToDomainUsingFile:(NSString *)filename
{
	HAIL_DomainLogic *dl = [HAIL_DomainLogic singleton];
	
	HAIL_TAAEAudioFile *file = [[HAIL_TAAEAudioFile alloc] init];
	[file setFileName:filename];
	HAIL_AudioData *fileAudio = [file loadAudioData];
	[[[dl musicLibrary] audioLibrary] addAudioData:fileAudio];
}

#pragma mark - Singleton Access

+ (HAIL_DomainController *)singleton
{
	static HAIL_DomainController *c = nil;
	
	if (!c)
	{
		c = [[super allocWithZone:nil] init];
	}
	
	return c;
}

+ (id)allocWithZone:(NSZone *)zone
{
	return [self singleton];
}

@end
