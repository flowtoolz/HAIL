#import "HAIL_PerformancePresentation.h"
#import "HAIL_ScorePresentation.h"
#import "HAIL_DomainLogic.h"
#import "HAIL_Performance.h"
#import "HAIL_Part.h"

@implementation HAIL_PerformancePresentation

- (id)init
{
    self = [super init];
    
    if (!self) return nil;
    
    [self initialize];
    
    return self;
}

- (void)initialize
{
    [self setFrame:CGRectMake(0.f, 0.f, 0.8f, 0.8f)];
    [self setColor:(HAIL_Color){0.f, 0.f, 0.f, 1.f}];
    
    [self setPerformance:[[HAIL_DomainLogic singleton] performance]];
    
    [self createSubPresentationsForPart:[[self performance] part]
                                 inRect:CGRectMake(0.f, 0.f, 1.f, 1.f)];
}

- (void)createSubPresentationsForPart:(HAIL_Part *)part
                               inRect:(CGRect)rect
{
    // base case: atomic part
    if (![part isComposed])
    {
        [self createSubPresentationsForAtomicPart:part
                                         andVoice:[[self performance] voice]
                                           inRect:rect];
    }
    // recursion: composed part
    else
    {
        // go through subparts
        CGRect subRect = rect;
        subRect.size.width = rect.size.width / [part numberOfSubParts];
    
        for (int subPartIndex = 0;
             subPartIndex < [part numberOfSubParts];
             subPartIndex++)
        {
            subRect.origin.x = rect.origin.x + subPartIndex * subRect.size.width;
            
            HAIL_Part *subPart = [part subPartAt:subPartIndex];

            [self createSubPresentationsForPart:subPart
                                         inRect:subRect];
        }
    }
}

- (void)createSubPresentationsForAtomicPart:(HAIL_Part *)atomicPart
                                   andVoice:(HAIL_Voice *)voice
                                     inRect:(CGRect)rect
{
    // base case: atomic voice
    if (![voice isComposed])
    {
        HAIL_MusicLibrary *library = [[self performance] musicLibrary];

        HAIL_Score *score = [library scoreForPart:atomicPart
                                            voice:voice];

        [self createSubPresentationForScore:score
                                     inRect:rect
                                       part:atomicPart
                                      voice:voice];
    }
    // recursion: composed voice
    else
    {
        // go through subvoices
        CGRect subRect = rect;
        subRect.size.height = rect.size.height / [voice numberOfSubVoices];
        
        for (int subVoiceIndex = 0;
             subVoiceIndex < [voice numberOfSubVoices];
             subVoiceIndex++)
        {
            subRect.origin.y = rect.origin.y + subVoiceIndex * subRect.size.height;
            
            HAIL_Voice *subVoice = [voice subVoiceAt:subVoiceIndex];
            
            [self createSubPresentationsForAtomicPart:atomicPart
                                             andVoice:subVoice
                                               inRect:subRect];
        }
    }
}

- (void)createSubPresentationForScore:(HAIL_Score *)score
                               inRect:(CGRect)rect
                                 part:(HAIL_Part *)part
                                voice:(HAIL_Voice *)voice
{
    if (score == nil) return;
    
    HAIL_ScorePresentation *sP = [[HAIL_ScorePresentation alloc] init];
    [sP setScore:score];
    [sP setVoice:voice];
    
    [sP setFrame:rect];
    [sP setColor:(HAIL_Color){0.f, 0.f, 0.f, 1.f}];
    [sP addEventsOfScore:score];
    
    [self addChild:sP];
}

@end