#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

typedef struct
{
	Float32 red;
	Float32 green;
	Float32 blue;
	Float32 alpha;
	
} HAIL_Color;

@interface HAIL_Presentation : NSObject

// input


// output
@property (nonatomic) CGRect frame;
@property (nonatomic) HAIL_Color color;

// sub presentations
- (void)addChild:(HAIL_Presentation *)newChild;
- (HAIL_Presentation *) childAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfChildren;
- (void)removeChildAtIndex:(NSUInteger)index;
- (void)removeAllChildren;

@end
