#import "HAIL_SynchronizedScrollContentView.h"

@implementation HAIL_SynchronizedScrollContentView

@synthesize syncMaster=_syncMaster;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(synchronizedScrollContentViewBecameMaster:)
												 name:@"SyncMasterView"
											   object:nil];
	
	[self setSyncMaster:NO];
	
	return self;
}

- (void)synchronizedScrollContentViewBecameMaster:(NSNotification *)notification
{
	//UIView *syncMaster = [notification object];
	
	//NSLog(@"recieved notification from %@", NSStringFromClass([syncMaster class]));
	
	[self setSyncMaster:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SyncMasterView"
														object:self];
	
	[self setSyncMaster:YES];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

@end
