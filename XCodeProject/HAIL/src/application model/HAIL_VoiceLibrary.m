#import "HAIL_VoiceLibrary.h"

@implementation HAIL_VoiceLibrary

- (NSMutableArray *)voiceArray
{
	if (!_voiceArray)
		_voiceArray = [[NSMutableArray alloc] init];
	
	return _voiceArray;
}

@end
