// Class under test
#import "HAIL_AudioData.h"

// Collaborators


// Test support
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

// test class
@interface HAIL_AudioDataTest : XCTestCase @end

@implementation HAIL_AudioDataTest
{
    // test fixture ivars
	HAIL_AudioData *cut;
}

#pragma mark - test fixture

- (void)setUp
{
	[super setUp];
	cut = [[HAIL_AudioData alloc] init];
}

- (void)tearDown
{
	cut = nil;
	[super tearDown];
}

#pragma mark - test cases

- (void)testThatClassExists
{
    assertThat(cut, notNilValue());
}

- (void)testThatNewInstanceHasNoFrames
{
    assertThatInteger([cut numberOfFrames], equalToInteger(0));
}

- (void)testThatNumberOfFramesCanBeSet
{
	// when
	[cut setNumberOfFrames:42];
	
	// then
    assertThatInteger([cut numberOfFrames], equalToInteger(42));
}

- (void)testThatOutOfBoundaryFramesAreZero
{
	// when
	[cut setNumberOfFrames:42];
	
	// then
    assertThatFloat([cut elongationAtFrameIndex:42], equalToFloat(0.f));
}

- (void)testThatNewFramesWithinBoundaryAreZero
{
	// when
	[cut setNumberOfFrames:42];
	
	// then
    assertThatFloat([cut elongationAtFrameIndex:41], equalToFloat(0.f));
}

- (void)setFrameWithinBoundary
{
	[cut setNumberOfFrames:42];
	[cut setElongation:@0.12345 toFrameAt:41];
}

- (void)testThatFramesInBoundaryCanBeSet
{
	// when
	[self setFrameWithinBoundary];
	
	// then
    assertThatFloat([cut elongationAtFrameIndex:41], equalToFloat(0.12345f));
}

- (void)setFrameBeyondBoundary
{
	[cut setNumberOfFrames:42];
	[cut setElongation:@0.12345 toFrameAt:42];
}

- (void)testThatFramesOutOfBoundariesCanNotBeSet
{
	// when
	[self setFrameBeyondBoundary];
	
	// then
    assertThatFloat([cut elongationAtFrameIndex:42], equalToFloat(0.f));
}

- (void)testThatDifferentFramesCanBeSet
{
	// when
	[cut setNumberOfFrames:42];
	[cut setElongation:@0.54321 toFrameAt:0];
	[cut setElongation:@0.12345 toFrameAt:41];
	
	// then
    assertThatFloat([cut elongationAtFrameIndex:0], equalToFloat(0.54321f));
	assertThatFloat([cut elongationAtFrameIndex:41], equalToFloat(0.12345f));
}

- (void)testThatBoundariesCanBeExtended
{
	// given
	[self setFrameBeyondBoundary];
	
	// when
	[cut setNumberOfFrames:84];
	[cut setElongation:@0.12345 toFrameAt:83];
	
	// then
    assertThatFloat([cut elongationAtFrameIndex:83], equalToFloat(0.12345f));
}

- (void)testThatBoundariesCanBeShrinked
{
	// given
	[self setFrameWithinBoundary];
	
	// when
	[cut setNumberOfFrames:21];
	[cut setElongation:@0.12345 toFrameAt:41];
	
	// then
    assertThatFloat([cut elongationAtFrameIndex:41], equalToFloat(0.f));
}

- (void)testThatDefaultIntendedFramerateIs44100
{
    assertThatInteger([cut intendedFramerate], equalToInteger(44100));
}

- (void)testThatIntendedFramerateCanBeSet
{
	// when
	[cut setIntendedFramerate:88200];
	
	// then
    assertThatInteger([cut intendedFramerate], equalToInteger(88200));
}

- (void)testThatIntendedDurationIsCalculated
{
	// when
	[cut setNumberOfFrames:441];
	
	// then
	float seconds = (float)[cut numberOfFrames] / [cut intendedFramerate];

    assertThat([cut intendedDurationInSeconds], equalTo(@(seconds)));
}

@end