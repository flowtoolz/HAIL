#import <Foundation/Foundation.h>
#import <TheAmazingAudioEngine.h>

@interface FT_TAAEAudioEngine : NSObject

#pragma mark - getters

- (AudioStreamBasicDescription)audioFormat;
- (AEAudioController *)audioController;
 
#pragma mark - singleton access

+ (FT_TAAEAudioEngine *)singleton;

@end
