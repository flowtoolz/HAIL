#import "HAIL_Performance.h"
#import "HAIL_Score.h"

@interface HAIL_Performance ()

@property (nonatomic, strong) NSMutableArray *cacheArray;

@end

@implementation HAIL_Performance

#pragma mark - Audio Source Protocol

- (float)elongationAtFrameIndex:(NSUInteger)index
{
    if ([[self cacheArray] count] != [self numberOfFrames])
        [self rebuildCache];
    
    return [[[self cacheArray] objectAtIndex:index] floatValue];
}

- (NSUInteger)numberOfFrames
{
    return [[self part] numberOfFrames];
}

#pragma mark - Caching

- (NSMutableArray *)cacheArray
{
    if (!_cacheArray)
        _cacheArray = [[NSMutableArray alloc] init];
    
    return _cacheArray;
}

- (void)rebuildCache
{
    [[self cacheArray] removeAllObjects];
    
    for (NSInteger frameIndex = 0;
         frameIndex < [self numberOfFrames];
         frameIndex++)
    {
        float frame = [[self musicLibrary] frameAt:frameIndex
                                           forPart:[self part]
                                          andVoice:[self voice]];
        
        [[self cacheArray] addObject:@(frame)];
    }
}

@end
