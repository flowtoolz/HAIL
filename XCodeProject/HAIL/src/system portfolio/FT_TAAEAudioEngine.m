#import "FT_TAAEAudioEngine.h"


@interface FT_TAAEAudioEngine ()

@property (nonatomic, strong) AEAudioController *audioController;

@end


@implementation FT_TAAEAudioEngine


#pragma mark - getters

- (AudioStreamBasicDescription)audioFormat
{
	return [[self audioController] audioDescription];
}

- (AEAudioController *)audioController
{
	return _audioController;
}


#pragma mark - init

- (id)init
{
	self = [super init];
	
	if (self == nil) return nil;

	// audio format
	AudioStreamBasicDescription audioFormat =
		[AEAudioController nonInterleaved16BitStereoAudioDescription];

	// create audio controller
	AEAudioController *ac = nil;
	
	ac = [[AEAudioController alloc] initWithAudioDescription:audioFormat
												inputEnabled:NO
										  useVoiceProcessing:NO];
	
	[self setAudioController:ac];
	
	// start the engine
	NSError *error = nil;

	if (![[self audioController] start:&error])
	{
		NSLog(@"Error when starting the AAE: %@", error);
		[self setAudioController:nil];
	}
	
	return self;
}

#pragma mark - Singleton Access

+ (FT_TAAEAudioEngine *)singleton
{
	static FT_TAAEAudioEngine *taae = nil;
	
	if (!taae) taae = [[super allocWithZone:nil] init];
	
	return taae;
}

+ (id)allocWithZone:(NSZone *)zone
{
	return [self singleton];
}

@end
 
