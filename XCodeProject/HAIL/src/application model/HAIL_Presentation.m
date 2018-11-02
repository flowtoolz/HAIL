#import "HAIL_Presentation.h"

@interface HAIL_Presentation ()

@property (nonatomic, strong) NSMutableArray *childrenArray;

@end


@implementation HAIL_Presentation

// sub presentations
- (NSMutableArray *)childrenArray
{
	if (!_childrenArray)
		_childrenArray = [[NSMutableArray alloc] init];
	
	return _childrenArray;
}

- (void)addChild:(HAIL_Presentation *)newChild
{
	[[self childrenArray] addObject:newChild];
}

- (HAIL_Presentation *) childAtIndex:(NSUInteger)index
{
	if (index >= [self numberOfChildren])
		return nil;
	
	return [[self childrenArray] objectAtIndex:index];
}

- (NSUInteger)numberOfChildren
{
	return [[self childrenArray] count];
}

- (void)removeChildAtIndex:(NSUInteger)index
{
	[[self childrenArray] removeObjectAtIndex:index];
}

- (void)removeAllChildren
{
	[[self childrenArray] removeAllObjects];
}

@end
