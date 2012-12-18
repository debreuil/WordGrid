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
#import "Answer.h"
#import "Grid.h"

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

float letterMoveDelay;
int lastSelectedTileIndex;
bool roundComplete = YES;

SystemSoundID correctWordSoundID;
SystemSoundID errorSoundID;
SystemSoundID returnWordsSoundID;
SystemSoundID winSoundID;

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
    
//    [self.gridView setHidden:NO];
//    
//    [self.answerGrid setup]; // answer grid needs to be setup first
//    [self.gridView setup];
    
    self.answerRefs = [[NSMutableArray alloc] initWithCapacity:20];
    
    NSURL *tickURLRef = [[NSBundle mainBundle] URLForResource:@"correctWord" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &correctWordSoundID);
    
    tickURLRef = [[NSBundle mainBundle] URLForResource:@"error" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &errorSoundID);
    
    tickURLRef = [[NSBundle mainBundle] URLForResource:@"returnWords" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &returnWordsSoundID);
    
    tickURLRef = [[NSBundle mainBundle] URLForResource:@"win" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &winSoundID);    

    _gridView.isEmptyHidden = YES;
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(tileSelected:)
     name:@"onTileSelected"
     object:nil];
    
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(answerSelected:)
     name:@"onAnswerGridTileSelected"
     object:nil];
    
    if(roundComplete)
    {
        roundComplete = NO;        
        [self newRound];
    }    
}

-(void) viewDidDisappear:(BOOL)animated
{    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onTileSelected" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onAnswerGridTileSelected" object:nil];
}

- (void) newRound
{
    [self.gridView setHidden:NO];
    
    self.gridView.grid = game.currentRound.grid;
            
    NSString *let = [game.currentRound currentCorrectLetter];
    [game.currentRound setSelectableByLetter:let];    
    
    // first letter is a gift
    //[self autoSelectFirstLetter];
    
    [self.gridView layoutGrid:YES];
}

- (void) tileSelected:(NSNotification *)notification
{
    Tile *t = (Tile *)[notification object];
    [self onTileSelected:t];
}

- (void) onTileSelected:(Tile *)t
{    
    if(t.isSelectable)
    {
        [game.currentRound guessTile:t];
        [self.gridView layoutGrid:YES];
        
        /*
        Tile *at = [self.answerGrid getNextTile];
        CGRect orgFrame = at.frame;//CGRectInset(at.frame, 0, 0);
        at.hidden = NO;
        at.frame = CGRectMake( -self.answerGrid.frame.origin.x + self.gridView.frame.origin.x + t.frame.origin.x,
                              -self.answerGrid.frame.origin.y + self.gridView.frame.origin.y + t.frame.origin.y,
                              t.frame.size.width,
                              t.frame.size.height);
        //NSLog(@"org: %f %f", t.frame.size.width, t.frame.size.height);
        [self.answerGrid setNextTileUsingTile:t];
        
        [UIView
         animateWithDuration:0.3
         delay:letterMoveDelay
         options: UIViewAnimationCurveEaseOut
         animations:^
         {
             at.frame = orgFrame;
         }
         completion:^(BOOL finished)
         {
             if(finished)
             {
                 [at setIsSelectable:YES];
                 [self testWordComplete];
             }
         }
         ];
        
        [self.answerRefs addObject:t];
        
        if([self.answerGrid atWordBoundry])
        {
            Boolean correct = [self.answerGrid testCurrentWordCorrect];
            if(correct)
            {
                [self.gridView setAllIsSelectable:NO];
                AudioServicesPlaySystemSound(correctWordSoundID);
            }
            else
            {
                AudioServicesPlaySystemSound(errorSoundID);
            }
        }
        else
        {
            [self.gridView setSelectableAroundIndex:lastSelectedTileIndex];
        }
         */
    }
}

- (void) answerSelected:(NSNotification *)notification
{
//    Tile *t = (Tile *)[notification object];
//    int firstLetter = [self.answerGrid getWordStartIndex:t.gridIndex];
//    int lastRemoved = [self.answerGrid getCurrentWordStart];
//    [self.gridView resetAnimationDelay:0];
//    
//    NSMutableArray *reinsertWordTiles = [NSMutableArray arrayWithCapacity:10];
//    
//    for (int i = [self.answerGrid getAnswerIndex] - 1; i >= firstLetter; i--)
//    {
//        Tile *rt = [self.answerGrid removeCurrentTile];
//        [rt setIsSelectable:NO];
//        
//        if (i < lastRemoved)
//        {
//            if(i + 1 == [self.answerGrid getWordStartIndex:i + 1])
//            {
//                [self.gridView insertLastVerticalGaps];
//            }
//            
//            [reinsertWordTiles addObject:rt];
//            
//            int startWord = [self.answerGrid getWordStartIndex:i];
//            if(i == startWord)
//            {
//                NSArray *sortedTiles = [reinsertWordTiles sortedArrayUsingSelector:@selector(compareOriginalIndex:)];
//                [reinsertWordTiles removeAllObjects];
//                for (Tile *answerSrc in sortedTiles)
//                {
//                    Tile *targ = [self.gridView insertTile:answerSrc At:answerSrc.originalIndex];
//                    
//                    targ.frame = CGRectMake(
//                                            self.answerGrid.frame.origin.x - self.gridView.frame.origin.x + answerSrc.frame.origin.x,
//                                            self.answerGrid.frame.origin.y - self.gridView.frame.origin.y + answerSrc.frame.origin.y,
//                                            answerSrc.frame.size.width,
//                                            answerSrc.frame.size.height);
//                    
//                    [self.gridView bringSubviewToFront:targ];
//                    [targ setSelected:NO];
//                    [answerSrc setLetter:@""];
//                }
//                [self.gridView layoutGrid:YES];
//            }
//        }
//        else
//        {
//            Tile *targ = [self.gridView getTileAtIndex:rt.originalIndex];
//            [targ setSelected:NO];
//            [self.gridView bringSubviewToFront:targ];
//            [rt setLetter:@""];
//        }
//        
//    }
//    
//    [self.answerRefs removeAllObjects];
//    [self.gridView resetGrid];
//    [self.gridView layoutGrid:YES];
//    NSString *let = [self.answerGrid getCurrentCorrectLetter];
//    [self.gridView setSelectableByLetter:let];
//    AudioServicesPlaySystemSound(returnWordsSoundID);
}

- (void) testWordComplete
{
//    if([self.answerGrid atWordBoundry])
//    {
//        [self.gridView resetGrid];
//        
//        Boolean correct = [self.answerGrid testCurrentWordCorrect];
//        if(correct)
//        {
//            NSRange r = NSMakeRange([self.answerGrid getAnswerIndex] - self.answerRefs.count, self.answerRefs.count);
//            NSArray *correctTileIndexes = [self.indexes subarrayWithRange:r];
//            int curAnswerIndex = [self.answerGrid getAnswerIndex];
//            for (int i = 0; i < correctTileIndexes.count; i++)
//            {
//                NSNumber *corIndex = [correctTileIndexes objectAtIndex:i];
//                Tile *corTile = [self.gridView getTileAtIndex:[corIndex integerValue]];
//                [self.answerRefs replaceObjectAtIndex:i withObject:corTile];
//                
//                Tile *answerTile = [self.answerGrid getTileAtIndex:curAnswerIndex - self.answerRefs.count + i];
//                answerTile.originalIndex = [corIndex integerValue];
//            }
//        }
//        
//        [self.gridView removeWordAndDrop:self.answerRefs];
//        [self.answerRefs removeAllObjects];
//        
//        Tile *nextTile = [self.answerGrid getNextTile];
//        if(nextTile == nil)
//        {
//            // all letters complete
//            if([self.answerGrid didWin])
//            {                
//                roundComplete = YES;
//                
//                [UIView
//                 animateWithDuration:1.0
//                 animations:^
//                 {
//                     [self.answerGrid setCenter:CGPointMake(self.answerGrid.center.x, 0)];
//                 }
//                 completion:^(BOOL finished)
//                 {
//                     if(finished)
//                     {
//                         [self performSegueWithIdentifier:@"toVictoryScreen" sender:self];
//                     }
//                 }
//                 ];
//            }
//        }
//        else if([nextTile letterShowing])
//        {
//            NSString *let = [self.answerGrid getCurrentCorrectLetter];
//            [self.gridView setSelectableByLetter:let];
//        }
//    }
}

- (void) autoSelectFirstLetter
{
//    if([self.gridView isMemberOfClass:[GridView class]])
//    {
//        letterMoveDelay = 0.5;
//        NSNumber *firstTileIndex = [self.indexes objectAtIndex:0];
//        Tile *t = [self.gridView getTileAtIndex:[firstTileIndex integerValue] ];
//        
//        [self.view insertSubview:self.answerGrid aboveSubview:self.gridView];
//        [self.gridView bringSubviewToFront:t];
//        [self.gridView ownTileSelected:t];
//        letterMoveDelay = 0.0;
//    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
