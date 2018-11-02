#import "HAIL_Voice.h"

@interface HAIL_Voice ()

@property (nonatomic, strong) NSMutableArray *subVoiceArray;

@end

@implementation HAIL_Voice

@synthesize ID, audioSource;

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    
    if (!self) return nil;
    
    [self setID:@(arc4random_uniform(NSIntegerMax))];
    
    return self;
}

#pragma mark - Subvoices

- (BOOL)isComposed
{
    return [self numberOfSubVoices] > 0;
}

- (NSMutableArray *)subVoiceArray
{
    if (!_subVoiceArray)
        _subVoiceArray = [[NSMutableArray alloc] init];
    
    return _subVoiceArray;
}

- (void)addSubVoice:(HAIL_Voice*)voice
{
    [[self subVoiceArray] addObject:voice];
}

- (HAIL_Voice *)subVoiceAt:(NSUInteger)index
{
    if (index >= [self numberOfSubVoices])
        return nil;
    
    return [[self subVoiceArray] objectAtIndex:index];
}

- (NSUInteger)numberOfSubVoices
{
    return [[self subVoiceArray] count];
}

@end