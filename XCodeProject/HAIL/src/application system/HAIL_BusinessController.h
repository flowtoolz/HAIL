#import <Foundation/Foundation.h>

@interface HAIL_BusinessController : NSObject

- (void)makeSureTestContentExists;

#pragma mark - singleton access

+ (HAIL_BusinessController *)singleton;

@end