#import <AEAudioFileLoaderOperation.h>
#import "FT_TAAEAudioEngine.h"
#import "HAIL_TAAEAudioFile.h"

@interface HAIL_TAAEAudioFile ()

@property (nonatomic, strong) NSURL *fileURL;

@end

@implementation HAIL_TAAEAudioFile

- (void)setFileName:(NSString*)fileName
{
	// create file url	
	NSURL *bundleDirURL = [[NSBundle mainBundle] bundleURL];
	NSURL *sampleDirURL = [bundleDirURL URLByAppendingPathComponent:@"audio/samples"];
	
	[self setFileURL:[sampleDirURL URLByAppendingPathComponent:fileName]];
	
	//NSLog(@"using %@", [[self fileURL] absoluteString]);
}

- (HAIL_AudioData *)loadAudioData
{
	//NSLog(@"loading audio data from file ...");
	
	// get audio format
	FT_TAAEAudioEngine *engine = [FT_TAAEAudioEngine singleton];
	AudioStreamBasicDescription format = [engine audioFormat];
	
	// create file loading operation
	AEAudioFileLoaderOperation *operation = nil;
	operation = [[AEAudioFileLoaderOperation alloc] initWithFileURL:[self fileURL]
											 targetAudioDescription:format];
	
	// load data from file
	[operation start];
	
	if (operation.error)
	{
		NSLog(@"loading audio file failed!");
		return nil;
	}
	
	//NSLog(@"loading audio file succeeded");
	
	// create audio data object
	HAIL_AudioData *audioData = [[HAIL_AudioData alloc] init];
	[audioData setNumberOfFrames:operation.lengthInFrames];
	
	// copy frames from bufferlist into audio data object
	SInt16 *channelL = operation.bufferList->mBuffers[0].mData;
		//SInt16 *channelR = operation.bufferList->mBuffers[1].mData;
	
	for (UInt32 frameIndex = 0;
		 frameIndex < operation.lengthInFrames;
		 frameIndex++)
	{
		SInt16 frameL = channelL[frameIndex];
			//SInt16 frameR = channelR[frameIndex];
		
		float frame = ((float)frameL) / INT16_MAX;
	
		assert(frame <= 1.f);
		assert(frame >= -1.f);
		
		[audioData setElongation:@(frame)
					   toFrameAt:frameIndex];
	}
	
	return audioData;
}

@end
