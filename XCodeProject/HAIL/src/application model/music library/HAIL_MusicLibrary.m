#import "HAIL_MusicLibrary.h"
#import "HAIL_Part.h"

@interface HAIL_AbsoluteFramePosition : NSObject

@property (nonatomic, weak) HAIL_Part *atomicPart;
@property (nonatomic) NSUInteger index;

@end

@implementation HAIL_AbsoluteFramePosition

@synthesize atomicPart;

@end

@interface HAIL_MusicLibrary ()

// contains section dictionaries which contain atomic comps ...
// hash for voice first, then for section
@property (nonatomic, strong) NSMutableDictionary *voiceDictionary;

@end

@implementation HAIL_MusicLibrary

#pragma mark - Accessing Audio

- (float)frameAt:(NSUInteger)index
         forPart:(HAIL_Part *)part
        andVoice:(HAIL_Voice *)voice
{
    HAIL_AbsoluteFramePosition *absPos = [self absoluteIndexInPart:part
                                                           atIndex:index];
    
    return [self frameAt:[absPos index]
           forAtomicPart:[absPos atomicPart]
                   voice:voice];
}

- (HAIL_AbsoluteFramePosition *)absoluteIndexInPart:(HAIL_Part *)part
                                            atIndex:(NSUInteger)index
{
    // base case: atomic part
    if (![part isComposed])
    {
        HAIL_AbsoluteFramePosition *pos = [[HAIL_AbsoluteFramePosition alloc] init];
        
        [pos setAtomicPart:part];
        [pos setIndex:index];
        
        return pos;
    }
    
    // go through sub parts
    HAIL_Part *subPart = nil;
    NSUInteger indexInSubPart = index;
    
    for (int i = 0; i < [part numberOfSubParts]; i++)
    {
        subPart = [part subPartAt:i];
        
        if (indexInSubPart < [subPart numberOfFrames])
            break;
        
        else indexInSubPart -= [subPart numberOfFrames];
    }
    
    return [self absoluteIndexInPart:subPart
                             atIndex:indexInSubPart];
}

- (float)frameAt:(NSUInteger)index
   forAtomicPart:(HAIL_Part *)part
           voice:(HAIL_Voice *)voice
{
    // base case: atomic voice
    if (![voice isComposed])
    {
        HAIL_Score *score = [self scoreForPart:part
                                         voice:voice];
        
        return [self frameForAtomicPart:part
                            atomicVoice:voice
                                  score:score
                                  index:index];
    }
    
    // go through sub voices
    float frame = 0.f;
    
    for (int i = 0; i < [voice numberOfSubVoices]; i++)
    {
        HAIL_Voice *subVoice = [voice subVoiceAt:i];
        
        frame += [self frameAt:index
                 forAtomicPart:part
                         voice:subVoice];
    }
    
    return frame;
}

- (float)frameForAtomicPart:(HAIL_Part *)part
                atomicVoice:(HAIL_Voice *)voice
                      score:(HAIL_Score *)score
                      index:(NSUInteger)index
{
    if (index >= [part numberOfFrames]) return 0.f;
    
    NSUInteger eventFrames = [[voice audioSource] numberOfFrames];
    
    float frame = 0;
    
    for (int i = 0; i < [score numberOfEvents]; i++)
    {
        HAIL_Event *event = [score eventAtIndex:i];
        NSUInteger eventStartFrame = [event startFrame];
        NSInteger eventFrame = index - eventStartFrame;
        
        if (eventFrame >= 0 && eventFrame < eventFrames)
        {
            frame += [[voice audioSource] elongationAtFrameIndex:eventFrame];
        }
    }
    
    return frame;
}

#pragma mark - mapping scores to part/voice-combinations

- (HAIL_Score *)scoreForPart:(HAIL_Part *)part voice:(HAIL_Voice *)voice
{
    return [self scoreForSectionID:[part ID]
                           voiceID:[voice ID]];
}

- (HAIL_Score *)scoreForSectionID:(NSInteger)sectionID
                          voiceID:(NSNumber *)voiceID
{
    NSMutableDictionary *sectionDictionary = [[self voiceDictionary] objectForKey:voiceID];
    
    if (!sectionDictionary) return nil;
    
    HAIL_Score *score = [sectionDictionary objectForKey:@(sectionID)];
    
    return score;
}

- (void)associateScore:(HAIL_Score *)score
        withAtomicPart:(HAIL_Part *)part
           atomicVoice:(HAIL_Voice *)voice
{
     NSNumber *voiceID = [voice ID];
     NSInteger partID = [part ID];
     
     // get part dictionary for voice
     NSMutableDictionary *sectionDictionary = [[self voiceDictionary] objectForKey:voiceID];
     
     // if voice doesn't exist ...
     if (!sectionDictionary)
     {
         sectionDictionary = [[NSMutableDictionary alloc] init];
         [[self voiceDictionary] setObject:sectionDictionary forKey:voiceID];
     }
     
     // set score with part key into part dictionary
     [sectionDictionary setObject:score forKey:@(partID)];
}

- (NSMutableDictionary *)voiceDictionary
{
    if (!_voiceDictionary)
        _voiceDictionary = [[NSMutableDictionary alloc] init];

    return _voiceDictionary;
}

#pragma mark - Sub-Libraries

- (HAIL_AudioLibrary *)audioLibrary
{
    if (!_audioLibrary)
        _audioLibrary = [[HAIL_AudioLibrary alloc] init];
    
    return _audioLibrary;
}

- (HAIL_VoiceLibrary *)voiceLibrary
{
    if (!_voiceLibrary)
        _voiceLibrary = [[HAIL_VoiceLibrary alloc] init];
    
    return _voiceLibrary;
}

- (HAIL_PartLibrary *)partLibrary
{
    if (!_partLibrary)
        _partLibrary = [[HAIL_PartLibrary alloc] init];
    
    return _partLibrary;
}

- (HAIL_ScoreLibrary *)scoreLibrary
{
    if (!_scoreLibrary)
        _scoreLibrary = [[HAIL_ScoreLibrary alloc] init];
    
    return _scoreLibrary;
}

@end