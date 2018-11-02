#import <Foundation/Foundation.h>

@interface HAIL_DomainController : NSObject

- (void)injectAudioIntoDomain;

#pragma mark - singleton access

+ (HAIL_DomainController *)singleton;

@end
