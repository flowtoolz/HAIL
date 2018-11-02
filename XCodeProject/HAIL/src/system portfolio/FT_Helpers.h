#import <Foundation/Foundation.h>

#import <CoreGraphics/CGGeometry.h>

@interface FT_Helpers : NSObject

+ (NSString *)stringFromRect:(CGRect)rect;
+ (NSString *)stringFromPoint:(CGPoint)point;
+ (NSString *)stringFromSize:(CGSize)size;

@end