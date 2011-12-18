//
//  DDWAppDelegate.h
//  WordGrid
//
//  Created by admin on 11-12-18.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class DDWViewController;
@class GameVC;

@interface DDWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) DDWViewController *viewController;
@property (strong, nonatomic) GameVC *viewController;

@end
