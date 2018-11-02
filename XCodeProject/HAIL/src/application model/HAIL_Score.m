#import "HAIL_Score.h"

@interface HAIL_Score ()

@property (nonatomic, strong) NSMutableArray *eventArray;

@end

@implementation HAIL_Score

#pragma mark - Properties

- (NSMutableArray *)eventArray
{
    if (!_eventArray)
    _eventArray = [[NSMutableArray alloc] init];
    
    return _eventArray;
}

#pragma mark - Reading

- (NSUInteger)numberOfEvents
{
    return [[self eventArray] count];
}

- (HAIL_Event *)eventAtIndex:(NSUInteger)index
{
    if (index >= [self numberOfEvents])
    return nil;
    
    return (HAIL_Event *)[[self eventArray] objectAtIndex:index];
}

#pragma mark - Editing

- (void)addEventAtBeat:(NSUInteger)beat
        lengthInFrames:(NSUInteger)frames
{
	int beats = 32;
	
	NSUInteger framesPerBeat = [self numberOfFrames] / beats;
	
	NSUInteger startFrame = beat * framesPerBeat;
	
    [self tryToAddEventAtFrame:startFrame
                        length:frames];
}

- (void)tryToAddEventAtFrame:(NSUInteger)frame
                      length:(NSUInteger)frames
{
    // quantize
    float framesPerBeat = ((float)[self numberOfFrames]) / 16;
    NSUInteger beat = frame / framesPerBeat;
    NSUInteger startFrame = ((float)beat / 16.f) * [self numberOfFrames];
    
    // check for collisions
    if ([self indexOfEventAtFrame:startFrame] >= 0) return;
    if ([self indexOfEventAtFrame:startFrame + frames - 1] >= 0) return;
    
    // add
    HAIL_Event *event = [[HAIL_Event alloc] init];
    [event setStartFrame:startFrame];
    [event setNumberOfFrames:frames];
    [[self eventArray] addObject:event];
}

- (void)removeEventAtIndex:(NSUInteger)index
{
    if (index >= [self numberOfEvents])
        return;
    
    [[self eventArray] removeObjectAtIndex:index];
}

- (void)removeEventsAtIndexes:(NSIndexSet *)indexSet
{
    [[self eventArray] removeObjectsAtIndexes:indexSet];
}

- (NSInteger)indexOfEventAtFrame:(NSUInteger)frame
{
    if (frame >= [self numberOfFrames])
        return -1;
    
    for (int i = 0; i < [self numberOfEvents]; i++)
    {
        HAIL_Event *event = [[self eventArray] objectAtIndex:i];
        NSUInteger startFrame = [event startFrame];
        NSUInteger eventFrames = [event numberOfFrames];

        if (frame >= startFrame && frame < startFrame + eventFrames)
            return i;
    }
    
    return -1;
}

- (void)removeEventsFromRelativeStart:(float)start
                                toEnd:(float)end
{
    NSUInteger startFrame = start * [self numberOfFrames];
    NSUInteger endFrame = end * [self numberOfFrames];
    
    NSMutableIndexSet *removeTheseIndexes = [[NSMutableIndexSet alloc] init];
    
    for (NSUInteger eventIndex = 0; eventIndex < [self numberOfEvents]; eventIndex++)
    {
        if ([self eventAtIndex:eventIndex
       isInRangeFromStartFrame:startFrame
                         toEnd:endFrame])
        {
            [removeTheseIndexes addIndex:eventIndex];
        }
    }
    
    [self removeEventsAtIndexes:removeTheseIndexes];
}

- (BOOL)eventAtIndex:(NSUInteger)eventIndex isInRangeFromStartFrame:(NSUInteger)start
               toEnd:(NSUInteger)end
{
    HAIL_Event *event = [[self eventArray] objectAtIndex:eventIndex];
    NSUInteger eventStartFrame = [event startFrame];
    NSUInteger eventEndFrame = eventStartFrame + [event numberOfFrames] - 1;
    
    // event overlaps with range start
    if (eventStartFrame < start && eventEndFrame >= start)
        return YES;
    
    // event overlaps with range end
    if (eventStartFrame < end && eventEndFrame >= end)
        return YES;
    
    // event is inside range
    if (eventStartFrame >= start && eventEndFrame <= end)
        return YES;
    
    return NO;
}

- (void)addOrRemoveEventFromRelativeStart:(float)start
                                    toEnd:(float)end
{
    // remove all events in range
    int numEvents = [self numberOfEvents];
    
    [self removeEventsFromRelativeStart:(float)start
                                  toEnd:(float)end];
    
    // add event if no events were removed
    if (numEvents == [self numberOfEvents])
    {
        NSUInteger frame = (NSUInteger)(start * [self numberOfFrames]);
        NSUInteger length = (NSUInteger)((end - start) * [self numberOfFrames]);
        
        [self tryToAddEventAtFrame:frame
                            length:length];
    }
    
    // in all cases, the score changed
    [self informClientsAboutChange];
}

- (void)informClientsAboutChange
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc postNotificationName:@"HAIL_ScoreChandedNotification"
                      object:self];
}

@end
