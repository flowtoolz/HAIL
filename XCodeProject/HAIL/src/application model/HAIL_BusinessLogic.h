#import <Foundation/Foundation.h>

@interface HAIL_BusinessLogic : NSObject

#pragma mark - use cases

- (void)playComposition;

- (void)removeEventAtIndex:(NSUInteger)eventIndex
fromAtomicCompositionAtIndex:(NSUInteger)atomicCompIndex;

- (void)addEventAtRelativeTime:(float)time
    toAtomicCompositionAtIndex:(NSUInteger)index;

#pragma mark - create test content

- (void)makeSureTestContentExists;

#pragma mark - singleton access

+ (HAIL_BusinessLogic *)singleton;

@end
