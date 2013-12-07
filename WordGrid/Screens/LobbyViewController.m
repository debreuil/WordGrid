//
//  LobbyViewController.m
//  WordGrid
//
//  Created by admin on 12-10-14.
//
//

#import "LobbyViewController.h"

@interface LobbyViewController ()

@end

@implementation LobbyViewController

@synthesize btInstructions = _btInstructions;
@synthesize btPlay = _btPlay;
@synthesize btCreate = _btCreate;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [[self navigationController] setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    BOOL result = NO;
	if (toInterfaceOrientation & UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight )
    {
        result = YES;
    }
	return result;
}

- (void)viewDidUnload {
    [self setBtInstructions:nil];
    [self setBtPlay:nil];
    [self setBtCreate:nil];
    [super viewDidUnload];
}
@end
