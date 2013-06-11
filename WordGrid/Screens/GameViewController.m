//
//  GameViewController.m
//  WordGrid
//
//  Created by admin on 12-10-14.
//
//

#import "GameViewController.h"
#import "Game.h"
#import "Round.h"
#import "GridView.h"
#import "AnswerView.h"
#import "Tile.h"
#import "TileWord.h"
#import "Answer.h"
#import "Grid.h"

extern SystemSoundID correctWordSoundID;
extern SystemSoundID errorSoundID;
extern SystemSoundID returnWordsSoundID;
extern SystemSoundID winSoundID;
extern SystemSoundID tickSoundID;

@interface GameViewController ()
{
    Game *game;
}
@property (strong) NSArray *indexes;
@property (strong) NSMutableArray* answerRefs;
@end

@implementation GameViewController


@synthesize gridView = _gridView;
@synthesize answerView = _answerView;
@synthesize btMenu = _btMenu;
@synthesize btReset = _btReset;

float letterMoveDelay;
int lastSelectedTileIndex;
bool roundComplete;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    game = [Game instance];
    
    
    self.answerRefs = [[NSMutableArray alloc] initWithCapacity:20];
    
    NSURL *tickURLRef = [[NSBundle mainBundle] URLForResource:@"correctWord" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &correctWordSoundID);
    
    tickURLRef = [[NSBundle mainBundle] URLForResource:@"error" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &errorSoundID);
    
    tickURLRef = [[NSBundle mainBundle] URLForResource:@"returnWords" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &returnWordsSoundID);
    
    tickURLRef = [[NSBundle mainBundle] URLForResource:@"win" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &winSoundID);
    
    tickURLRef = [[NSBundle mainBundle] URLForResource:@"smallTick" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &tickSoundID);

    _answerView.showErrors = YES;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(tileSelected:)
     name:@"onTileSelected"
     object:nil];
    
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(answerSelected:)
     name:@"onAnswerWordSelected"
     object:nil];
    
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onRoundComplete:)
     name:@"onRoundComplete"
     object:nil];
    
    [_btReset addTarget:self action:@selector(onReset:) forControlEvents:UIControlEventTouchUpInside];
    [_btMenu addTarget:self action:@selector(onGotoSelectionMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    roundComplete = NO;        
    [self setupRound];
}

-(void) viewDidDisappear:(BOOL)animated
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onTileSelected" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onAnswerWordSelected" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onRoundComplete" object:nil];
    [_btReset removeTarget:self action:@selector(onReset:) forControlEvents:UIControlEventTouchUpInside];
    [_btMenu removeTarget:self action:@selector(onGotoSelectionMenu:) forControlEvents:UIControlEventTouchUpInside];
    [[Game instance] saveRound];
}

- (void) setupRound
{
    [self.gridView setHidden:NO];
    
    self.gridView.grid = game.currentRound.grid;
    self.answerView.round = game.currentRound;              
        
    [self.gridView layoutGrid:YES];
    
    if([game.currentRound isFullyGuessed])
    {
        [game.currentRound undoLastWord];
        [game.currentRound setSelectableByLetter];
        [self.gridView layoutGrid:YES];
    }
}

- (void) tileSelected:(NSNotification *)notification
{
    Tile *t = (Tile *)[notification object];
    [self onTileSelected:t];
}

- (IBAction) onReset:(id) sender
{
    [game.currentRound resetRound];
    [self setupRound];
}
- (IBAction) onGotoSelectionMenu:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onTileSelected:(Tile *)t
{    
    if(t.isSelectable)
    {
        [game.currentRound guessTile:t];
        [self.gridView layoutGrid:YES];
        [self.answerView setNeedsDisplay];        
    }
}

- (void) answerSelected:(NSNotification *)notification
{
    int clearIndexFrom = [[notification.userInfo objectForKey:@"clearIndexFrom"] intValue];
    int addCurWord = game.currentRound.currentWord.tiles.count > 0 ? 1 : 0;
    int wordsToClearCount = game.currentRound.wordIndex - clearIndexFrom + addCurWord;
    
    for(int i = 0; i < wordsToClearCount; i++)
    {
        [game.currentRound undoLastWord];
    }
    
    [game.currentRound setSelectableByLetter];
    [self.gridView layoutGrid:YES];
    
}

- (void) onRoundComplete:(NSNotification *)notification
{       
    [self performSegueWithIdentifier:@"toVictoryScreen" sender:self];
}

- (void) testWordComplete
{
}
- (void) autoSelectFirstLetter
{
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
    [self setBtReset:nil];
    [self setBtMenu:nil];
    [super viewDidUnload];
}

@end
