#import "HAIL_PresentationView.h"
#import "HAIL_EditorPresentation.h"
#import "HAIL_ScrollView.h"

@interface HAIL_EditorView : HAIL_PresentationView <HAIL_ScrollViewDelegateProtocol>

@property (nonatomic, weak) HAIL_EditorPresentation *presentation;

- (void)updateLayout;

@end
