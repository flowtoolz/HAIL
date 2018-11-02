#import "HAIL_EditorPresentation.h"
#import "HAIL_BusinessLogic.h"
#import "HAIL_DomainLogic.h"

@interface HAIL_EditorPresentation ()

@property (nonatomic, strong) HAIL_PerformancePresentation *performancePresentation;
@property (nonatomic, strong) HAIL_PartPresentation *partPresentation;
@property (nonatomic, strong) HAIL_VoicePresentation *voicePresentation;
@property (nonatomic, strong) HAIL_Presentation *playButtonPresentation;

@end

@implementation HAIL_EditorPresentation

- (id)init
{
    self = [super init];
    
    if (!self) return nil;
    
    // register for playing position notifications
    NSNotificationCenter *board = [NSNotificationCenter defaultCenter];
    [board addObserver:self
              selector:@selector(recievedPlayingPositionChangedNotification:)
                  name:HAIL_AudioPlayer_PlayingPositionChangedNotification
                object:nil];
    
    return self;
}

#pragma mark - Input

- (void)recievedPlayingPositionChangedNotification:(NSNotification *)notification
{
    // TODO: change position presentation
    
    // inform view controllers about presentation change
    NSNotificationCenter *board = [NSNotificationCenter defaultCenter];
    [board postNotificationName:@"PositionPresentationChangedNotification"
                         object:self];
}

- (void)playButtonPressed
{
    [[HAIL_BusinessLogic singleton] playComposition];
}

#pragma mark - Output

- (HAIL_PerformancePresentation *)performancePresentation;
{
    if (_performancePresentation)
        return _performancePresentation;
    
    _performancePresentation = [[HAIL_PerformancePresentation alloc] init];
    
    return _performancePresentation;
}

- (HAIL_PartPresentation *)partPresentation
{
    if (_partPresentation)
        return _partPresentation;
    
    _partPresentation = [[HAIL_PartPresentation alloc] init];
    
    [_partPresentation setColor:(HAIL_Color){0.f, 0.f, 0.f, 1.f}];
    [_partPresentation setFrame:CGRectMake(0.f, 0.8f, 0.8f, 0.2f)];
    
    return _partPresentation;
}

- (HAIL_Presentation *)voicePresentation
{
    if (_voicePresentation)
        return _voicePresentation;
    
    _voicePresentation = [[HAIL_VoicePresentation alloc] init];
    
    [_voicePresentation setColor:(HAIL_Color){0.f, 0.f, 0.f, 1.f}];
    [_voicePresentation setFrame:CGRectMake(0.8f, 0.f, 0.2f, 0.8f)];
    
    return _voicePresentation;
}

- (HAIL_Presentation *)playButtonPresentation
{
    if (_playButtonPresentation)
        return _playButtonPresentation;
    
    _playButtonPresentation = [[HAIL_Presentation alloc] init];
    
    [_playButtonPresentation setColor:(HAIL_Color){0.f, 0.f, 0.f, 1.f}];
    [_playButtonPresentation setFrame:CGRectMake(0.8f, 0.8f, 0.2f, 0.2f)];
    
    return _playButtonPresentation;
}

- (float)relativePlayingPosition
{
    HAIL_DomainLogic *domain = [HAIL_DomainLogic singleton];
    
    float relPosition = ((float)[[domain player] nextFrame]) /
    [[[domain player] audioSource] numberOfFrames];
    
    return relPosition;
}

@end