#import "HAIL_EditorPresentation.h"

@interface HAIL_PresentationLogic : NSObject

#pragma mark - Input

#pragma mark - Output

- (HAIL_EditorPresentation *)editorPresentation;

#pragma mark - singleton access

+ (HAIL_PresentationLogic *)singleton;

@end
