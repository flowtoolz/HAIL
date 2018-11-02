#import "HAIL_PresentationLogic.h"
#import "HAIL_BusinessLogic.h"
#import "HAIL_DomainLogic.h"
#import "HAIL_ScorePresentation.h"

@interface HAIL_PresentationLogic ()

@property (nonatomic, strong) HAIL_EditorPresentation *editorPresentation;

@end

@implementation HAIL_PresentationLogic

#pragma mark - Output

- (HAIL_EditorPresentation *)editorPresentation
{
    if (_editorPresentation)
        return _editorPresentation;
    
    _editorPresentation = [[HAIL_EditorPresentation alloc] init];
    
    [_editorPresentation setColor:(HAIL_Color){0.f, 0.f, 0.f, 1.f}];
    [_editorPresentation setFrame:CGRectMake(0.f, 0.f, 1.f, 1.f)];
    
    return _editorPresentation;
}

#pragma mark - singleton access

+ (HAIL_PresentationLogic *)singleton
{
    static HAIL_PresentationLogic *pl = nil;
    
    if (!pl)
    {
        pl = [[super allocWithZone:nil] init];
    }
    
    return pl;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self singleton];
}

@end
