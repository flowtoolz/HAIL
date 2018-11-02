#import <Foundation/Foundation.h>

#import "HAIL_MusicLibrary.h"
#import "HAIL_AudioSourceProtocol.h"

@interface HAIL_Performance : NSObject <HAIL_AudioSourceProtocol>

@property (nonatomic, weak) HAIL_Voice *voice;
@property (nonatomic, weak) HAIL_Part *part;
@property (nonatomic, weak) HAIL_MusicLibrary *musicLibrary;

@end
