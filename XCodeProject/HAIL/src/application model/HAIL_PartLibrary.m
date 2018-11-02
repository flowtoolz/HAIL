#import "HAIL_PartLibrary.h"

@implementation HAIL_PartLibrary

- (NSMutableArray *)partArray
{
    if (!_partArray)
        _partArray = [[NSMutableArray alloc] init];
    
    return _partArray;
}

@end
