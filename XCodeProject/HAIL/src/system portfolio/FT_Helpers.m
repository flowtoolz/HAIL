#import "FT_Helpers.h"

@implementation FT_Helpers

+ (NSString *)stringFromRect:(CGRect)rect
{
	return [NSString stringWithFormat:@"x = %.2f\ty = %.2f\twidth = %.2f\theight = %.2f",
			rect.origin.x,
			rect.origin.y,
			rect.size.width,
			rect.size.height];
}

+ (NSString *)stringFromPoint:(CGPoint)point
{
    return [NSString stringWithFormat:@"x = %.2f\ty = %.2f",
            point.x, point.y];
}

+ (NSString *)stringFromSize:(CGSize)size
{
    return [NSString stringWithFormat:@"width = %.2f\theight = %.2f",
            size.width, size.height];
}

// TODO: make print functions accessible

- (void)printRect:(CGRect)rect
            named:(NSString *)name
{
    NSLog(@"%@:\t%@", name, [FT_Helpers stringFromRect:rect]);
}

- (void)printPoint:(CGPoint)point
             named:(NSString *)name
{
    NSLog(@"%@:\t%@", name, [FT_Helpers stringFromPoint:point]);
}

- (void)printSize:(CGSize)size
            named:(NSString *)name
{
    NSLog(@"%@:\t%@", name, [FT_Helpers stringFromSize:size]);
}

- (void)printFloat:(float)floatNumber
             named:(NSString *)name
{
    NSLog(@"%@: %.2f", name, floatNumber);
}

@end
