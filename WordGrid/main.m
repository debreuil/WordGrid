#import <UIKit/UIKit.h>

#import "DDWAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool
    {
        int retVal = 0;
        @autoreleasepool
        {
            NSString *classString = NSStringFromClass([DDWAppDelegate class]);
            @try
            {
                retVal = UIApplicationMain(argc, argv, nil, classString);
            }
            @catch (NSException *exception)
            {
                NSLog(@"Exception - %@",[exception description]);
                NSLog(@"Symbols - %@",[exception callStackSymbols]);
                exit(EXIT_FAILURE);
            }
        }
        return retVal;
    }
}
