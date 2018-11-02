// Class under test
#import "HAIL_TAAEAudioPlayer.h"

// Collaborators
#import "HAIL_AudioPlayerProtocol.h"
#import "HAIL_AudioData.h"

// Test support
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

// test class
@interface HAIL_TAAEAudioPlayerTest : XCTestCase @end

@implementation HAIL_TAAEAudioPlayerTest
{
    // test fixture ivars
	HAIL_TAAEAudioPlayer *cut;
}

#pragma mark - test fixture

- (void)setUp
{
	[super setUp];
	cut = [[HAIL_TAAEAudioPlayer alloc] init];
}

- (void)tearDown
{
	cut = nil;
	[super tearDown];
}

#pragma mark - test cases

- (void)testThatClassIsAudioPlayer
{
	assertThatBool([cut conformsToProtocol:@protocol(HAIL_AudioPlayerProtocol)],
				  equalToBool(YES));
}

- (void)testThatAudioDataCanBeInjected
{
	// given
	HAIL_AudioData *audioData = [[HAIL_AudioData alloc] init];
	
	// when
	[cut setAudioSource:audioData];
	
	// then
	assertThat([cut audioSource], is(audioData));
}

- (void)testThatInitialStateIsPaused
{
	assertThatInteger([cut state], equalToInteger(HAIL_AudioPlayerStatePaused));
}

- (void)testThatStateIsPlayinAfterPlayingWithData
{
	// given
	HAIL_AudioData *audioData = [[HAIL_AudioData alloc] init];
	
	NSInteger numberOfFrames = 10;
	
	[audioData setNumberOfFrames:numberOfFrames];
	
	for (int frame = 0; frame < [audioData numberOfFrames]; frame++)
	{
		[audioData setElongation:@0.0 toFrameAt:frame];
	}

	// when
	[cut setAudioSource:audioData];
	[cut play];
	
	// then
	assertThatInteger([cut state], equalToInteger(HAIL_AudioPlayerStatePlaying));
}

- (void)testThatStateIsPausedAfterPlayingWithEmptyData
{
	// given
	HAIL_AudioData *audioData = [[HAIL_AudioData alloc] init];
	
	[audioData setNumberOfFrames:0];
	
	// when
	[cut setAudioSource:audioData];
	[cut play];
	
	// then
	assertThatInteger([cut state], equalToInteger(HAIL_AudioPlayerStatePaused));
}

- (void)testThatInitialNextFrameIsZero
{
	assertThatInteger([cut nextFrame], equalToInteger(0));
}

- (void)testThatSettingNextFrameGreaterThanMaxSetsItToMax
{
	// given
	HAIL_AudioData *audioData = [[HAIL_AudioData alloc] init];
	[audioData setNumberOfFrames:10];
	[cut setAudioSource:audioData];
	
	// when
	[cut setNextFrame:10];
	
	// then
	assertThatInteger([cut nextFrame], equalToInteger(9));
}

- (void)testThatSettingNextFrameLowerThanZeroSetsItToZero
{
	// given
	HAIL_AudioData *audioData = [[HAIL_AudioData alloc] init];
	[audioData setNumberOfFrames:10];
	[cut setAudioSource:audioData];
	
	// when
	[cut setNextFrame:-1];
	
	// then
	assertThatInteger([cut nextFrame], equalToInteger(0));
}

@end