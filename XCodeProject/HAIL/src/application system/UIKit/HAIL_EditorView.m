#import "HAIL_EditorView.h"
#import "UIView+AutoLayout.h"
#import "HAIL_Voice.h"
#import "HAIL_VoiceView.h"
#import "HAIL_PartView.h"
#import "HAIL_PerformanceView.h"
#import "FT_Helpers.h"
#import "HAIL_ScrollView.h"
#import "HAIL_PlayButton.h"

@interface HAIL_EditorView ()

@property (nonatomic, strong) HAIL_ScrollView *partScrollView;
@property (nonatomic, strong) HAIL_PartView *partView;

@property (nonatomic, strong) HAIL_ScrollView *voiceScrollView;
@property (nonatomic, strong) HAIL_VoiceView *voiceView;

@property (nonatomic, strong) HAIL_ScrollView *testScrollView;
@property (nonatomic, strong) HAIL_PerformanceView *performanceView;
@property (nonatomic, strong) UIView *cursorView;

@property (nonatomic, strong) HAIL_PlayButton *playButton;

@end

@implementation HAIL_EditorView

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    
    if (!self) return nil;
    
    [self initialize];
    
    return self;
}

- (void)initialize
{
    [self setBackgroundColor:[UIColor clearColor]];
    
    // register for presentation logic notifications
    NSNotificationCenter *board = [NSNotificationCenter defaultCenter];
    
    [board addObserver:self
              selector:@selector(recievedPositionPresentationChangedNotification:)
                  name:@"PositionPresentationChangedNotification"
                object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Listening to Presentation Logic

- (void)recievedPositionPresentationChangedNotification:(NSNotification *)notification
{
    CGRect curserFrame = [[self cursorView] frame];
    
    float frameWidth = [[self performanceView] frame].size.width;
    float relativePosition = [[self presentation] relativePlayingPosition];
    
    curserFrame.origin.x = frameWidth * relativePosition;
    
    [[self cursorView] setFrame:curserFrame];
}

#pragma mark - Listenng to User Input

- (void)PlayButtonAction:(id)sender
{
    [[self presentation] playButtonPressed];
}

#pragma mark - Properties

- (HAIL_PlayButton *)playButton
{
    if (_playButton) return _playButton;
    
    _playButton = [HAIL_PlayButton autoLayoutView];
    
    [[self playButton] addTarget:self
                          action:@selector(PlayButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    
    return _playButton;
}

- (HAIL_ScrollView *)partScrollView
{
    if (_partScrollView) return _partScrollView;
    
    _partScrollView = [[HAIL_ScrollView alloc] init];
    
    [_partScrollView setVerticalZoomDisabled:YES];
    [_partScrollView setDelegate:self];
    
    return _partScrollView;
}

- (HAIL_PartView *)partView
{
    if (_partView) return _partView;
    
    _partView = [[HAIL_PartView alloc] init];
    
    return _partView;
}

- (HAIL_ScrollView *)voiceScrollView
{
    if (_voiceScrollView) return _voiceScrollView;
    
    _voiceScrollView = [[HAIL_ScrollView alloc] init];
    
    [_voiceScrollView setHorizontalZoomDisabled:YES];
    [_voiceScrollView setDelegate:self];
    
    return _voiceScrollView;
}

- (HAIL_VoiceView *)voiceView
{
    if (_voiceView) return _voiceView;
    
    _voiceView = [[HAIL_VoiceView alloc] init];
    
    return _voiceView;
}

- (HAIL_ScrollView *)performanceScrollView
{
    if (_testScrollView) return _testScrollView;
    
    _testScrollView = [[HAIL_ScrollView alloc] init];
    
    [_testScrollView setDelegate:self];
    
    return _testScrollView;
}

- (HAIL_PerformanceView *)performanceView
{
    if (_performanceView)
        return _performanceView;
    
    _performanceView = [[HAIL_PerformanceView alloc] init];;
    
    [_performanceView setPerformancePresentation:[[self presentation] performancePresentation]];
    
    return _performanceView;
}

- (UIView *)cursorView
{
    if (_cursorView)
        return _cursorView;
    
    _cursorView = [UIView autoLayoutView];
    
    [_cursorView setBackgroundColor:[UIColor whiteColor]];
    
    _cursorView.layer.shadowOffset = CGSizeMake(0, 0);
    _cursorView.layer.shadowRadius = 5;
    _cursorView.layer.shadowOpacity = 1.f;
    
    return _cursorView;
}

#pragma mark - Layout

- (void)updateLayout
{
    // play button
    [self addView:[self playButton] forPresentation:[[self presentation] playButtonPresentation]];
    
    // part scroll view
    [HAIL_PresentationView addView:[self partScrollView]
                   forPresentation:[[self presentation] partPresentation]
                       toSuperview:self
                        autolayout:NO];
    [[self partScrollView] setContentView:[self partView]];
    [self addPartViewsToPartsScrollContentView];
    
    // voice scroll view
    [HAIL_PresentationView addView:[self voiceScrollView]
                   forPresentation:[[self presentation] voicePresentation]
                       toSuperview:self
                        autolayout:NO];
    [[self voiceScrollView] setContentView:[self voiceView]];
    [self addVoiceViewsToVoicesScrollContentView];
    
    // performance scroll view
    [HAIL_PresentationView addView:[self performanceScrollView]
                   forPresentation:[[self presentation] performancePresentation]
                       toSuperview:self
                        autolayout:NO];
    [[self performanceScrollView] setContentView:[self performanceView]];
    [[self performanceView] updateScoreViews];
    
    // cursor view
    [[self performanceView] addSubview:[self cursorView]];
    [[self cursorView] pinToSuperviewEdges:JRTViewPinTopEdge | JRTViewPinBottomEdge
                                     inset:0];
    [[self cursorView] constrainToWidth:2.f];
}

#pragma mark - adding subviews

- (void)addPartViewsToPartsScrollContentView
{
    HAIL_Part *rootPart = [[[[self presentation] performancePresentation] performance] part];
    
    NSUInteger numParts = [rootPart numberOfSubParts];
    
    for (int i = 0; i < numParts; i++)
    {
        HAIL_PresentationView *subPartView = [HAIL_PresentationView autoLayoutView];
        
        UILabel *label = [UILabel autoLayoutView];
        [label setText:[NSString stringWithFormat:@"P A R T %d", i]];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [subPartView addSubview:label];
        [label pinToSuperviewEdges:JRTViewPinAllEdges inset:0];
        
        subPartView.layer.borderColor = [[UIColor blackColor] CGColor];
        subPartView.layer.borderWidth = 0.5f;
        
        HAIL_Presentation *p = [[HAIL_Presentation alloc] init];
        [p setFrame:CGRectMake((1.f / numParts) * i, 0.f,
                               (1.f / numParts), 1.f)];
        float color = 1.f / 2;
        [p setColor:(HAIL_Color){color, color, color, 1.f}];

        [[self partView] addView:subPartView
                 forPresentation:p];
    }
}

- (void)addVoiceViewsToVoicesScrollContentView
{
    HAIL_Voice *rootVoice = [[[[self presentation] performancePresentation] performance] voice];
    
    NSUInteger numSubvoices = [rootVoice numberOfSubVoices];
    
    for (int i = 0; i < numSubvoices; i++)
    {
        HAIL_PresentationView *subVoiceView = [HAIL_PresentationView autoLayoutView];
        
        UILabel *label = [UILabel autoLayoutView];
        [label setText:[NSString stringWithFormat:@"V O I C E %d", i]];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [subVoiceView addSubview:label];
        [label pinToSuperviewEdges:JRTViewPinAllEdges inset:0];
        
        subVoiceView.layer.borderColor = [[UIColor blackColor] CGColor];
        subVoiceView.layer.borderWidth = 0.5f;
        
        HAIL_Presentation *p = [[HAIL_Presentation alloc] init];
        [p setFrame:CGRectMake(0.f, (1.f / numSubvoices) * i,
                               1.f, (1.f / numSubvoices))];
        float color = 1.f / 2;
        [p setColor:(HAIL_Color){color, color, color, 1.f}];
        
        [[self voiceView] addView:subVoiceView
                  forPresentation:p];
    }
}

#pragma mark - sync scroll views

- (void)scrollViewDidChange:(HAIL_ScrollView *)scrollView
{
    if (scrollView != [self performanceScrollView])
        [[self performanceScrollView] adjustToScrollView:scrollView];
    
    if (scrollView != [self partScrollView])
        [[self partScrollView] adjustToScrollView:scrollView];
    
    if (scrollView != [self voiceScrollView])
        [[self voiceScrollView] adjustToScrollView:scrollView];
}

@end