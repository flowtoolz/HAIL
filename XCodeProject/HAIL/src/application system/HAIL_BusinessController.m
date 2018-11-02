#import "HAIL_BusinessController.h"
#import "HAIL_BusinessLogic.h"

@implementation HAIL_BusinessController

- (void)makeSureTestContentExists
{
    [[HAIL_BusinessLogic singleton] makeSureTestContentExists];
}

#pragma mark - Singleton Access

+ (HAIL_BusinessController *)singleton
{
    static HAIL_BusinessController *c = nil;
    
    if (!c)
    {
        c = [[super allocWithZone:nil] init];
    }
    
    return c;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self singleton];
}

@end