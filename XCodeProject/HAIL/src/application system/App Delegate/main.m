#import "HAIL_AppDelegate.h"

int main(int argc, char *argv[])
{
	@autoreleasepool
	{
		NSString *className = NSStringFromClass([HAIL_AppDelegate class]);

	    return UIApplicationMain(argc, argv, nil, className);
	}
}