#import <Foundation/Foundation.h>
#import "HAIL_AudioSourceProtocol.h"

@interface HAIL_Voice : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, weak) HAIL_AudioSource *audioSource;

- (BOOL)isComposed;
- (void)addSubVoice:(HAIL_Voice *)voice;
- (HAIL_Voice *)subVoiceAt:(NSUInteger)index;
- (NSUInteger)numberOfSubVoices;

@end