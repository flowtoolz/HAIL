#import <Foundation/Foundation.h>

#import "HAIL_AudioSourceProtocol.h"

@interface HAIL_AudioData : HAIL_AudioSource

@property (nonatomic) NSUInteger intendedFramerate;

- (NSNumber *)intendedDurationInSeconds;

- (void)setElongation:(NSNumber *)elongation
			toFrameAt:(NSUInteger)index;

- (void)setNumberOfFrames:(NSUInteger)numberOfFrames;

@end