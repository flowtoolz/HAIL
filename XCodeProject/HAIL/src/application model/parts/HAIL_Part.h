#import <Foundation/Foundation.h>

@interface HAIL_Part : NSObject

@property (nonatomic) NSInteger ID;
@property (nonatomic) NSUInteger numberOfFrames;

- (BOOL)isComposed;
- (void)addSubPart:(HAIL_Part *)part;
- (HAIL_Part *)subPartAt:(NSUInteger)index;
- (NSUInteger)numberOfSubParts;

@end