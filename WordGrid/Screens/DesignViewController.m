
//
//  DesignViewController.m
//  WordGrid
//
//  Created by admin on 12-10-14.
//
//

#import "DesignViewController.h"
#import "Game.h"
#import "Round.h"
#import "DesignGrid.h"

@interface DesignViewController ()
{
    Game *game;
}

@property (nonatomic, readonly)DesignGrid *designGrid;

@end

@implementation DesignViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;    
}

- (DesignGrid *) ensureDesignGrid
{
    DesignGrid *result = (DesignGrid *)_gridView.grid;
    if(result == nil)
    {
        result = [[DesignGrid alloc] init];
        [result createEmptyGrid];
        [_gridView setGrid:result];
    }
    return result;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    game = [Game instance];  
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[self setupRound];
    
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void) setupRound
{
    //[self.answerGrid setDirection:-1];
    
    [self ensureDesignGrid];
    
//    game.currentIndex = 2;
//    [game.currentRound exposeAllLetters];
//    
//    self.gridView.hidden = NO;
//    self.gridView.maxRows = MAX_ROWS;
//    
//    self.gridView.grid = game.currentRound.grid;
//    self.answerView.round = game.currentRound;

    
    [self.gridView layoutGrid:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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

@end
