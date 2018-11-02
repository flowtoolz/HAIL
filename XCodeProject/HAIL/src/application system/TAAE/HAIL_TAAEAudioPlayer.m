#import "HAIL_TAAEAudioPlayer.h"
#import "FT_TAAEAudioEngine.h"

@interface HAIL_TAAEAudioPlayer ()


@end

@implementation HAIL_TAAEAudioPlayer

@synthesize audioSource, state, nextFrame = _nextFrame;

- (id)init
{
	self = [super init];
	
	if (self == nil) return nil;
	
	// create audio generation block
	AEBlockChannelBlock block =	^(const AudioTimeStamp *time,
								  UInt32 frames,
								  AudioBufferList *audio)
	{
		if ([self state] == HAIL_AudioPlayerStatePaused)
			return;
		
		if ([self audioSource] == nil)
		{
			NSLog(@"player has no audio data!");
			return;
		}
		
		UInt32 numberOfDataFrames = [[self audioSource] numberOfFrames];
		
		if (numberOfDataFrames == 0)
		{
			NSLog(@"player's audio data is empty!");
			return;
		}
		
		for (UInt32 bufferFrame = 0; bufferFrame < frames; bufferFrame++)
		{
			UInt32 dataFrame = [self nextFrame];
			
			float elongationNormalized = [[self audioSource] elongationAtFrameIndex:dataFrame];
		
			SInt16 elongation16BitInt = elongationNormalized * (INT16_MAX / 2);
			
			//self.nextFrame++;
			
			((SInt16*)audio->mBuffers[0].mData)[bufferFrame] = elongation16BitInt;
			((SInt16*)audio->mBuffers[1].mData)[bufferFrame] = elongation16BitInt;
			
			// was this the last available frame?
			if (dataFrame == numberOfDataFrames - 1)
			{
				[self setState:HAIL_AudioPlayerStatePaused];
				[self setNextFrame:0];
				break;
			}
			
			self.nextFrame++;
		}
	};
	
	// create a block channel
	AEBlockChannel *blockChannel = nil;
	
	blockChannel = [AEBlockChannel channelWithBlock:block];
	
	// add channel to the audio controller
	AEAudioController *ac = [[FT_TAAEAudioEngine singleton] audioController];
	
	[ac addChannels:[NSArray arrayWithObject:blockChannel]];
	
	return self;
}

- (void)play
{
	// do we have audio data?
	if ([[self audioSource] numberOfFrames] == 0)
	{
		[self setState:HAIL_AudioPlayerStatePaused];
		NSLog(@"audio player has no data!");
		return;
	}
	
	// play
	[self setState:HAIL_AudioPlayerStatePlaying];
}

- (void)setNextFrame:(NSInteger)nextFrame
{
	// inform main thread about playing progress
	if (_nextFrame % 2000 == 0 || abs(_nextFrame - nextFrame) > 2000)
	{
		dispatch_async(dispatch_get_main_queue(), ^
					   {
						   [self playingPositionChanged];
					   });
	}
	
	// advance curser
	NSInteger maxIndex = [[self audioSource] numberOfFrames] - 1;
	
	if (nextFrame > maxIndex && maxIndex >= 0)
		_nextFrame = maxIndex;
	
	else if (nextFrame < 0)
		_nextFrame = 0;
	
	else
		_nextFrame = nextFrame;
}

- (void)playingPositionChanged
{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
	[notificationCenter postNotificationName:HAIL_AudioPlayer_PlayingPositionChangedNotification
									  object:self];
}

@end
