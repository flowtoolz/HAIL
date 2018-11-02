#import <Foundation/Foundation.h>

#pragma mark - Type Definition

@protocol HAIL_AudioSourceProtocol;

typedef NSObject<HAIL_AudioSourceProtocol> HAIL_AudioSource;

#pragma mark - Interface

@protocol HAIL_AudioSourceProtocol <NSObject>

- (NSUInteger)numberOfFrames;
- (float)elongationAtFrameIndex:(NSUInteger)index;

@end