#import "HAIL_Score.h"

@interface HAIL_ScoreLibrary : NSObject

- (void)addScore:(HAIL_Score *)score;
- (HAIL_Score *)scoreAt:(NSUInteger)index;
- (HAIL_Score *)lastScore;

@end
