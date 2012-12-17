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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    Game *g = [Game instance];
    NSMutableArray *answers = [g.quotePack answers];
    NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:g.quoteCount];
    for(int i = 0; i < g.quoteCount; i++)
    {
        Answer *ans = [answers objectAtIndex:i];
        [ar addObject:[NSNumber numberWithInt:ans.savedRating]];
    }
    grid = [[Grid alloc] init];
    [grid deserializeSelections:[NSArray arrayWithArray:ar]];
    [grid setAllIsSelectable:YES];
    
    _gridView.isEmptyHidden = YES;
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
}
-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onTileSelected" object:nil];
}

-(void) createGrid
{return;
    int ansCount = [[Game instance] quoteCount];
    int itemsPerRow = 8;
    float l =  self.txTitle.frame.origin.x;
    float t = self.txTitle.frame.origin.y + self.txTitle.frame.size.height + 100;
    float w =  self.txTitle.frame.size.width;
    
    tiles = [[NSMutableArray alloc] initWithCapacity:ansCount];
    Tile *tile;
    TileView *tv;

    int tw = 48;
    int th = 48;
    int slotWidth = (int)((w - (tw * itemsPerRow)) / (float)(itemsPerRow - 1));
    int slotHeight = slotWidth;
    int curLeft = l;
    int curTop = t;
    
    int col = 0;
    for (int i = 0; i < ansCount; i++)
    {
        CGRect r = CGRectMake(curLeft, curTop, tw, th);
        tile = [[Tile alloc] initWithLetter:[NSString stringWithFormat:@"%i", i]];
        tv = [[TileView alloc] initWithFrame:r andTile:tile];
        tv.tile.isSelectable = YES;
        [tiles addObject:tv];
        [self.view addSubview:tv];
        col++;
        if(col >= itemsPerRow)
        {
            col = 0;
            curLeft = l;
            curTop += th + slotHeight;            
        }
        else
        {
            curLeft += tw + slotWidth;
        }
    }
}

- (void) onSelectTile:(NSNotification *)notification
{
    Tile *tile = (Tile *)[notification object];
    int index = [tile.letter integerValue];
    [Game instance].currentIndex = index;
    
    [self performSegueWithIdentifier:@"toPlayScreen" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setTxTitle:nil];
    [super viewDidUnload];
}



@end
