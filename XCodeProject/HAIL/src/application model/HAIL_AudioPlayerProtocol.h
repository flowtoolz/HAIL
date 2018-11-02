#import <Foundation/Foundation.h>

#import "HAIL_AudioSourceProtocol.h"

#pragma mark - Notification Names

extern NSString * const HAIL_AudioPlayer_PlayingPositionChangedNotification;

#pragma mark - Type Definitions

@protocol HAIL_AudioPlayerProtocol;

typedef NSObject<HAIL_AudioPlayerProtocol> HAIL_AudioPlayer;

typedef NS_ENUM(NSInteger, HAIL_AudioPlayerState)
{
	HAIL_AudioPlayerStatePaused,
	HAIL_AudioPlayerStatePlaying
};

#pragma mark - Interface

@protocol HAIL_AudioPlayerProtocol <NSObject>

@property (nonatomic) HAIL_AudioPlayerState state;
@property (nonatomic, weak) HAIL_AudioSource *audioSource;
@property (nonatomic) NSInteger nextFrame;

- (void)play;

@end