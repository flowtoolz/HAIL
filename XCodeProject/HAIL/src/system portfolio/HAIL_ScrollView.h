#import <UIKit/UIKit.h>
#import "HAIL_PresentationView.h"

#pragma mark - Delegate Type

@protocol HAIL_ScrollViewDelegateProtocol;

typedef NSObject<HAIL_ScrollViewDelegateProtocol> FT_ScrollViewDelegate;

#pragma mark - Delegate Interface

@class HAIL_ScrollView;

@protocol HAIL_ScrollViewDelegateProtocol <NSObject>

- (void)scrollViewDidChange:(HAIL_ScrollView *)scrollView;

@end

#pragma mark - Scroll View Interface

@interface HAIL_ScrollView : HAIL_PresentationView

@property (nonatomic, weak) FT_ScrollViewDelegate *delegate;

@property (nonatomic) BOOL verticalZoomDisabled;
@property (nonatomic) BOOL horizontalZoomDisabled;
@property (nonatomic) double zoomX;
@property (nonatomic) double zoomY;

- (void)setContentView:(HAIL_PresentationView *)contentView;
- (void)adjustToScrollView:(HAIL_ScrollView *)scrollView;

@end
