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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setWantsFullScreenLayout:YES];
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

- (void)viewDidUnload {
    [self setBtInstructions:nil];
    [self setBtPlay:nil];
    [self setBtCreate:nil];
    [super viewDidUnload];
}
@end
