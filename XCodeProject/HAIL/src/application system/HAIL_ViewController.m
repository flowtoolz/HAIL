#import "HAIL_ViewController.h"
#import "HAIL_PresentationLogic.h"
#import "HAIL_DomainController.h"
#import "HAIL_BusinessController.h"
#import "UIView+AutoLayout.h"
#import "HAIL_EditorView.h"

@interface HAIL_ViewController ()

@property (nonatomic, strong) HAIL_EditorView *editorView;

@end

@implementation HAIL_ViewController

#pragma mark - Controller Lifecycle

- (id)init
{
    self = [super init];

    if (!self) return nil;
	
	[self initialize];
	
    return self;
}

- (void)initialize
{
    [[HAIL_DomainController singleton] injectAudioIntoDomain];
    [[HAIL_BusinessController singleton] makeSureTestContentExists];
}

#pragma mark - Properties

- (HAIL_EditorView *)editorView
{
    if (_editorView) return _editorView;
    
    _editorView = [[HAIL_EditorView alloc] init];
    
    HAIL_EditorPresentation *editorPresentation = [[HAIL_PresentationLogic singleton] editorPresentation];
    
    [_editorView setPresentation:editorPresentation];
    
    return _editorView;
}

#pragma mark - View Delegation

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self layoutEditorView];
}

- (void)layoutEditorView
{
    [HAIL_PresentationView addView:[self editorView]
                   forPresentation:[[self editorView] presentation]
                       toSuperview:[self view]
                        autolayout:NO];
 
    [[self editorView] updateLayout];
}

@end
