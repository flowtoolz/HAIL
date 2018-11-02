#import "HAIL_Part.h"

@interface HAIL_Part ()

@property (nonatomic, strong) NSMutableArray *subPartArray;

@end


@implementation HAIL_Part

@synthesize numberOfFrames, ID;

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    
    if (!self) return nil;
    
    [self setID:arc4random_uniform(NSIntegerMax)];
    [self setNumberOfFrames:0];
    
    return self;
}

#pragma mark - Sub Parts

- (BOOL)isComposed
{
    return [self numberOfSubParts] > 0;
}

- (NSMutableArray *)subPartArray
{
    if (!_subPartArray)
        _subPartArray = [[NSMutableArray alloc] init];
    
    return _subPartArray;
}
- (NSUInteger)numberOfSubParts
{
    return [[self subPartArray] count];
}

- (void)addSubPart:(HAIL_Part *)part
{
    [[self subPartArray] addObject:part];
}

- (HAIL_Part *)subPartAt:(NSUInteger)index
{
    if (index >= [[self subPartArray] count])
        return nil;
    
    return [[self subPartArray] objectAtIndex:index];
}

#pragma mark - Length

- (NSUInteger)numberOfFrames
{
    // atomic
    if (![self isComposed])
        return numberOfFrames;
    
    // composed
    NSUInteger frames = 0;
    
    for (HAIL_Part *part in [self subPartArray])
        frames += [part numberOfFrames];
    
    return frames;
}

@end
