#import "HAIL_ScorePresentation.h"
#import "HAIL_EventPresentation.h"

@implementation HAIL_ScorePresentation

#pragma mark - Listening to View/Controller

- (void)viewWasMarkedFromRelativeStart:(float)start
                                 toEnd:(float)end
{
    [[self score] addOrRemoveEventFromRelativeStart:start
                                              toEnd:end];
}

#pragma mark - Listening to Score

- (void)recievedScoreChangedNotification:(NSNotification *)notification
{
    // update this presentation
    [self removeAllChildren];
    [self addEventsOfScore:[self score]];
    
    // inform clients (views or controllers)    
    [self informClientsAboutChange];
}

- (void)informClientsAboutChange
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc postNotificationName:@"HAIL_ScorePresentationChandedNotification"
                      object:self];
}

#pragma mark - Score

- (void)setScore:(HAIL_Score *)score
{
    _score = score;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    [nc removeObserver:self];
    
    if (score != nil)
    {        
        [nc addObserver:self
               selector:@selector(recievedScoreChangedNotification:) name:@"HAIL_ScoreChandedNotification"
                 object:score];
    }
}

- (void)dealloc
{
    NSLog(@"deallocating score presentation ...");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addEventsOfScore:(HAIL_Score *)score
{
    NSUInteger scoreFrames = [score numberOfFrames];
    
    HAIL_Color eventColor = {0.75f, 0.75f, 0.75f, 1.f};
    
    for (int eventIndex = 0;
         eventIndex < [score numberOfEvents];
         eventIndex++)
    {
        HAIL_Event *event = [score eventAtIndex:eventIndex];
        float eventStartFrame = [event startFrame];
        NSUInteger eventFramesInt = [event numberOfFrames];
        float eventFrames = eventFramesInt;
        
        CGRect relFrame;
        relFrame.origin.x = eventStartFrame / scoreFrames;
        relFrame.origin.y = 0.f;
        relFrame.size.width = (eventFrames - 800.f) / scoreFrames;
        relFrame.size.height = 1.f;
        
        HAIL_EventPresentation *eventPresentation = [[HAIL_EventPresentation alloc] init];
  
        [eventPresentation setAudioSource:[[self voice] audioSource]];
        [eventPresentation setFrame:relFrame];
        [eventPresentation setColor:eventColor];
        [eventPresentation setNumberOfFrames:eventFramesInt];
        
        [self addChild:eventPresentation];
    }
}

@end
