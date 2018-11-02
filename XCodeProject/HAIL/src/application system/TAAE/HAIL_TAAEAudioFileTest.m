// Class under test
#import "HAIL_TAAEAudioFile.h"

// Collaborators


// Test support
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

// test class
@interface HAIL_TAAEAudioFileTest : XCTestCase @end

@implementation HAIL_TAAEAudioFileTest
{
    // test fixture ivars
	HAIL_TAAEAudioFile *cut;
}

#pragma mark - test fixture

- (void)setUp
{
	[super setUp];
	cut = [[HAIL_TAAEAudioFile alloc] init];
}

- (void)tearDown
{
	cut = nil;
	[super tearDown];
}

#pragma mark - test cases

- (void)testTesting
{
	assertThatInt(1, is(@1));
}

@end
