//
//  SelectionViewController.m
//  WordGrid
//
//  Created by admin on 12-10-16.
//
//

#import "SelectionViewController.h"
#import "Tile.h"
#import "Game.h"
#import "Grid.h"
#import "GridView.h"
#import "TileView.h"
#import "QuotePack.h"
#import "Answer.h"
#import "GameRating.h"

@interface SelectionViewController ()
{
    Grid *grid;
}
- (void) createChoices;

@end

@implementation SelectionViewController

@synthesize txTitle = _txTitle;
@synthesize gridView = _gridView;

NSMutableArray *tiles;

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
	
    Game *g = [Game instance];
        
    grid = [[Grid alloc] init];
    [grid createSelectionGrid:g.quoteCount];
    [grid setAllIsSelectable:YES];
    
    _gridView.margin = 15;
    [_gridView setGrid:grid];
    
    //[self createGrid];
}

- (void) createChoices
{
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onSelectTile:)
     name:@"onTileSelected"
     object:nil];
    
    Game *g = [Game instance];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *roundRatingsName = [g.quotePack.quotePackName stringByAppendingString:@"_ratings"];
    NSData *data = [defaults objectForKey:roundRatingsName];
    
    NSArray *roundRatings;
    BOOL firstTime = YES;
    if(data != nil)
    {
        firstTime = NO;
        roundRatings = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    for(int i = 0; i < g.quoteCount; i++)
    {
        GameRating *rating = firstTime ? [[GameRating alloc]init] : (GameRating *)[roundRatings objectAtIndex:i];
        Tile *t = [grid getTileFromIndex:i];
        t.rating = rating;
        [[_gridView.tileViews objectAtIndex:i] setNeedsDisplay];
    }    
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onTileSelected" object:nil];
}

- (void) onSelectTile:(NSNotification *)notification
{
    Tile *tile = (Tile *)[notification object];
    int index = [tile.letter integerValue] - 1;
    [Game instance].currentIndex = index;
    
    [self performSegueWithIdentifier:@"toPlayScreen" sender:self];
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

- (void)viewDidUnload
{
    [self setTxTitle:nil];
    [super viewDidUnload];
}



@end
