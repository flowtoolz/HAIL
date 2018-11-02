#import <Foundation/Foundation.h>

#import "HAIL_AudioData.h"

@interface HAIL_AudioLibrary : NSObject

- (void)addAudioData:(HAIL_AudioData *)audioData;

- (HAIL_AudioData *)audioDataAt:(NSUInteger)index;

@end
