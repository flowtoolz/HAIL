#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HAIL_SynchronizedScrollContentView : UIView

@property (readwrite) BOOL syncMaster;

- (void)synchronizedScrollContentViewBecameMaster:(NSNotification *)notification;

@end
