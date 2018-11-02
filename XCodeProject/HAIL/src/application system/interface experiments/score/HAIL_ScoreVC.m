#import "HAIL_ScoreVC.h"

@implementation HAIL_ScoreVC

- (void) didReceiveMemoryWarning
{
	NSLog(@"score view eats too much memory!!!");
}

- (void) didMoveToParentViewController:(UIViewController *)parent
{
	//NSLog(@"score view was moved to parent controller");
	
	// find a size for the score view
	CGRect scrollFrame = [[self scrollView] frame];
	
	float scrollViewAspectRatio = scrollFrame.size.width / scrollFrame.size.height;
	
	int pianoKeys = 24;
	float pianoKeyHeight = scrollFrame.size.height / 12; // maximum zoom: down to 3 keys
	float scoreFrameHeight = pianoKeys * pianoKeyHeight;
	float scoreFrameWidth = scoreFrameHeight * scrollViewAspectRatio;
	
	CGRect scoreViewFrame = CGRectMake(0, 0, scoreFrameWidth, scoreFrameHeight);
	
	// blub
	[self setScoreView:[[HAIL_ScoreViewOLD alloc] initWithFrame:scoreViewFrame]];
	[[self scoreView] setBackgroundColor:[UIColor clearColor]];
	
	[[self scrollView] addSubview:[self scoreView]];
	[[self scrollView] setContentSize:scoreViewFrame.size];
	[[self scrollView] setMinimumZoomScale:scrollFrame.size.height / scoreViewFrame.size.height];
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	//NSLog(@"score view did load");
}

- (void) viewWillAppear:(BOOL)animated
{
	//NSLog(@"score view will appear");
	
	[[self scrollView] setZoomScale:[[self scrollView] minimumZoomScale] animated:NO];
}

@end
