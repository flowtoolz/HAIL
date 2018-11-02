#import "HAIL_AudioLibrary.h"

@interface HAIL_AudioLibrary ()

@property (nonatomic, strong) NSMutableArray *audioArray;

@end

@implementation HAIL_AudioLibrary

- (NSMutableArray *)audioArray
{
	if (!_audioArray)
		_audioArray = [[NSMutableArray alloc] init];
	
	return _audioArray;
}

- (void)addAudioData:(HAIL_AudioData *)audioData
{
	[[self audioArray] addObject:audioData];
}

- (HAIL_AudioData *)audioDataAt:(NSUInteger)index
{
	if (index >= [[self audioArray] count])
		return nil;
	
	return [[self audioArray] objectAtIndex:index];
}

@end
