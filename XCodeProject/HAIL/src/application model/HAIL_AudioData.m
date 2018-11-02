#import "HAIL_AudioData.h"

#pragma mark - private variables

@interface HAIL_AudioData ()

@property NSMutableArray *frames;

@end

#pragma mark - implementation

@implementation HAIL_AudioData

@synthesize intendedFramerate	= _intendedFramerate;

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

	[self setFrames:[[NSMutableArray alloc] init]];
	
	[self setIntendedFramerate:44100];

    return self;
}

- (NSUInteger)numberOfFrames
{
	return [[self frames] count];
}

- (void)setNumberOfFrames:(NSUInteger)numberOfFrames
{
	NSInteger framesToAdd = numberOfFrames - [self numberOfFrames];
	
	if (framesToAdd > 0)
		[self appendFrames:framesToAdd];
	
	if (framesToAdd < 0)
		[self removeLastFrames:-framesToAdd];
}

- (void)removeLastFrames:(NSUInteger)removeFrames
{
	NSInteger firstRemoveIndex = [self numberOfFrames] - removeFrames;
	
	if (![self indexIsValid:firstRemoveIndex]) return;
	
	NSRange removeRange = NSMakeRange(firstRemoveIndex, removeFrames);
	
	[[self frames] removeObjectsInRange:removeRange];
}

- (void)appendFrames:(NSUInteger)appendFrames
{
	for (int i = 0; i < appendFrames; i++)
	{
		[[self frames] addObject:@0.0];
	}
}

- (float)elongationAtFrameIndex:(NSUInteger)index
{
	if (![self indexIsValid:index]) return 0.f;
	
	return [[[self frames] objectAtIndex:index] floatValue];
}

- (void)setElongation:(NSNumber *)elongation
			toFrameAt:(NSUInteger)index
{
	if (![self indexIsValid:index]) return;
		
	[[self frames] replaceObjectAtIndex:index
							 withObject:elongation];
}

- (BOOL)indexIsValid:(NSInteger)index
{
	return (index >= 0 && index < [self numberOfFrames]);
}

- (NSNumber *)intendedDurationInSeconds
{
	float s = (float)[self numberOfFrames] / [self intendedFramerate];
	
	return @(s);
}

@end