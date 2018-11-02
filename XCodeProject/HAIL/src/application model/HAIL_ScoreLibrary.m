#import "HAIL_ScoreLibrary.h"

@interface HAIL_ScoreLibrary ()

@property (nonatomic, strong) NSMutableArray *scoreArray;

@end


@implementation HAIL_ScoreLibrary


- (void)addScore:(HAIL_Score *)score
{
	[[self scoreArray] addObject:score];
}

#pragma mark - Array Access

- (NSMutableArray *)scoreArray
{
	if (!_scoreArray)
		_scoreArray = [[NSMutableArray alloc] init];
	
	return _scoreArray;
}

- (HAIL_Score *)scoreAt:(NSUInteger)index
{
	if ([[self scoreArray] count] <= index)
		return nil;
	
	return [[self scoreArray] objectAtIndex:index];
}

- (HAIL_Score *)lastScore
{
    if ([[self scoreArray] count] == 0)
        return nil;
    
    return [[self scoreArray] lastObject];
}

@end
