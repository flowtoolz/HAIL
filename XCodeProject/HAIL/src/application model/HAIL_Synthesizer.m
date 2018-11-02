#import "HAIL_Synthesizer.h"

@implementation HAIL_Synthesizer

+ (HAIL_AudioData *)synthesizeAudioData
{
	// create synthetic audio data
	HAIL_AudioData *ad = [[HAIL_AudioData alloc] init];
	
	[ad setNumberOfFrames:22050];
	
	for (NSInteger frame = 0;
		 frame < [ad numberOfFrames];
		 frame++)
	{
		// base frequency
		float x = (frame / (44100.0 / M_PI)) * 880;
		
		// major chord
		float elongation = (sinf(x) +
							sinf(x * 1.25) +
							sinf(x * 1.5) +
							sinf(x * 2)) / 4;
		
		// write audio data
		[ad setElongation:@(elongation) toFrameAt:frame];
	}
	
	return ad;
}

@end
