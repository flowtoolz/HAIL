#import <Foundation/Foundation.h>

#import "HAIL_AudioData.h"

@interface HAIL_TAAEAudioFile : NSObject

@property (nonatomic, strong) NSString *fileName;

- (HAIL_AudioData *)loadAudioData;

@end
