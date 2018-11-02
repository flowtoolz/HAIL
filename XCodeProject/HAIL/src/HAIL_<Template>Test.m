// Class under test
#import "HAIL_<Template>.h"

// Collaborators


// Test support
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define MOCKITO_SHORTHAND
#import <OCMockitoIOS/OCMockitoIOS.h>

// test class
@interface HAIL_<Template>Test : XCTestCase @end

@implementation HAIL_<Template>Test
{
    // test fixture ivars
	HAIL_<Template> *cut;
}

#pragma mark - test fixture

- (void)setUp
{
	[super setUp];
	cut = [[HAIL_<Template> alloc] init];
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
