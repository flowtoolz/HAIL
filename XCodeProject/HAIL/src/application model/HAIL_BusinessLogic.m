#import "HAIL_BusinessLogic.h"
#import "HAIL_DomainLogic.h"
#import "HAIL_Voice.h"
#import "HAIL_Part.h"
#import "HAIL_Synthesizer.h"

#import "HAIL_DomainController.h"

@interface HAIL_BusinessLogic ()

@property (nonatomic) BOOL testContentWasCreated;

@end

@implementation HAIL_BusinessLogic

#pragma mark - Use Cases

- (void)makeSureTestContentExists
{
    if ([self testContentWasCreated]) return;
    
    [self createTestContent];
    
    [self setTestContentWasCreated:YES];
}

- (void)createTestContent
{
    HAIL_DomainLogic *domain = [HAIL_DomainLogic singleton];
    HAIL_MusicLibrary *lib = [domain musicLibrary];
    HAIL_VoiceLibrary *voiceLib = [lib voiceLibrary];
    
    // create and set parts
    [domain addNewPartWithNumberOfFrames:42100 * 8];
    [domain addNewPartWithNumberOfFrames:42100 * 8];
    [domain addNewPart];
    HAIL_Part *part1 = [[[lib partLibrary] partArray] objectAtIndex:0];
    HAIL_Part *part2 = [[[lib partLibrary] partArray] objectAtIndex:1];
    HAIL_Part *superPart = [[[lib partLibrary] partArray] objectAtIndex:2];
    [superPart addSubPart:part1];
    [superPart addSubPart:part2];
    [[domain performance] setPart:superPart];
    
    // create voices and scores
    for (int audioIndex = 0; audioIndex <= 5; audioIndex++)
    {
        // create voice
        [self addNewVoiceWithAudio:audioIndex];
        HAIL_Voice *voice = [[[lib voiceLibrary] voiceArray] lastObject];
		
        // create scores
        [domain addNewScore];
        HAIL_Score *score1 = [[lib scoreLibrary] lastScore];
		[domain addNewScore];
		HAIL_Score *score2 = [[lib scoreLibrary] lastScore];
        
        // associate score with parts and voice
        [score1 setNumberOfFrames:[part1 numberOfFrames]];
		[score2 setNumberOfFrames:[part2 numberOfFrames]];
        
        [lib associateScore:score1
             withAtomicPart:part1
                atomicVoice:voice];
		
		[lib associateScore:score2
			 withAtomicPart:part2
				atomicVoice:voice];
    }
    
    // create and set performance voice
    [domain addNewVoice];
    HAIL_Voice *voice = [[voiceLib voiceArray] lastObject];
    [[domain performance] setVoice:voice];
    
    for (int subVoiceIndex = 0; subVoiceIndex <= 5; subVoiceIndex++)
    {
        HAIL_Voice *atomicVoice = [[voiceLib voiceArray] objectAtIndex:subVoiceIndex];
        
        [voice addSubVoice:atomicVoice];
    }
    
    // add events to scores (create a beat)
    HAIL_ScoreLibrary *repository = [lib scoreLibrary];
    
    [self writeBeatToScore:[repository scoreAt:0]
                withModulo:4
                    offset:0
                     voice:[[voiceLib voiceArray] objectAtIndex:0]];
    
    [self writeBeatToScore:[repository scoreAt:2]
                withModulo:4
                    offset:2
                     voice:[[voiceLib voiceArray] objectAtIndex:1]];
    
    [self writeBeatToScore:[repository scoreAt:4]
                withModulo:8
                    offset:7
                     voice:[[voiceLib voiceArray] objectAtIndex:2]
                    invert:YES];
    
    [self writeBeatToScore:[repository scoreAt:6]
                withModulo:8
                    offset:7
                     voice:[[voiceLib voiceArray] objectAtIndex:3]];
    
    [self writeBeatToScore:[repository scoreAt:8]
                withModulo:8
                    offset:0
                     voice:[[voiceLib voiceArray] objectAtIndex:4]];
    
    [self writeBeatToScore:[repository scoreAt:10]
                withModulo:4
                    offset:0
                     voice:[[voiceLib voiceArray] objectAtIndex:5]];
}

- (void)writeBeatToScore:(HAIL_Score *)score
              withModulo:(NSUInteger)mod
                  offset:(NSUInteger)offset
                   voice:(HAIL_Voice *)voice
                  invert:(BOOL)invert
{
    for (NSUInteger beat = 0; beat < 32; beat++)
    {
        if ((beat % mod == offset) == !invert)
        {
            [score addEventAtBeat:beat
                   lengthInFrames:[[voice audioSource] numberOfFrames]];
        }
    }
}

- (void)writeBeatToScore:(HAIL_Score *)score
              withModulo:(NSUInteger)mod
                  offset:(NSUInteger)offset
                   voice:(HAIL_Voice *)voice
{
    [self writeBeatToScore:score
                withModulo:mod
                    offset:offset
                     voice:voice
                    invert:NO];
}

- (void)addNewVoiceWithAudio:(NSUInteger)audioIndex
{
    [[HAIL_DomainLogic singleton] addNewVoiceWithAudioData:audioIndex];
}

- (void)addTestAudioDataFromSynth
{
    HAIL_DomainLogic *domain = [HAIL_DomainLogic singleton];
    HAIL_AudioData *synthAudio = [HAIL_Synthesizer synthesizeAudioData];
    [[[domain musicLibrary] audioLibrary] addAudioData:synthAudio];
}

#pragma mark - Use Cases

- (void)playComposition
{
	HAIL_DomainLogic *domain = [HAIL_DomainLogic singleton];
	
	[[domain player] play];
}

- (void)removeEventAtIndex:(NSUInteger)eventIndex fromAtomicCompositionAtIndex:(NSUInteger)atomicCompIndex
{
	NSLog(@"business logic: about to remove event at index %d from atomic comp at index %d",
		  eventIndex, atomicCompIndex);
	
	HAIL_DomainLogic *domain = [HAIL_DomainLogic singleton];
	
	HAIL_Score *atomicComp = [[[domain musicLibrary] scoreLibrary] scoreAt:atomicCompIndex];
	
	[atomicComp removeEventAtIndex:eventIndex];
}

- (void)addEventAtRelativeTime:(float)time toAtomicCompositionAtIndex:(NSUInteger)index
{
	NSLog(@"business logic: about to add event at relative time %.2f to atomic comp at index %d",
		  time, index);
	
	HAIL_DomainLogic *domain = [HAIL_DomainLogic singleton];
	
	HAIL_Score *score = [[[domain musicLibrary] scoreLibrary] scoreAt:index];
	
	NSUInteger beat = time * 32;
	
	NSLog(@"business logic: new event beat = %d", beat);
	
    HAIL_Voice *voice = [[[[domain musicLibrary] voiceLibrary] voiceArray] objectAtIndex:index];
    
	[score addEventAtBeat:beat
           lengthInFrames:[[voice audioSource] numberOfFrames]];
}

#pragma mark - Singleton Access

+ (HAIL_BusinessLogic *)singleton
{
	static HAIL_BusinessLogic *bl = nil;
	
	if (!bl)
	{
		bl = [[super allocWithZone:nil] init];
	}
	
	return bl;
}

+ (id)allocWithZone:(NSZone *)zone
{
	return [self singleton];
}

@end
