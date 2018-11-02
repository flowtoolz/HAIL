#import <Foundation/Foundation.h>
#import "HAIL_Event.h"

@interface HAIL_Score : NSObject

@property (nonatomic) NSUInteger numberOfFrames;

#pragma mark - Reading

- (NSUInteger)numberOfEvents;
- (HAIL_Event *)eventAtIndex:(NSUInteger)index;

#pragma mark - Editing

- (void)addEventAtBeat:(NSUInteger)beat
        lengthInFrames:(NSUInteger)frames;
- (void)removeEventAtIndex:(NSUInteger)index;
- (void)addOrRemoveEventFromRelativeStart:(float)start
                                    toEnd:(float)end;

@end
