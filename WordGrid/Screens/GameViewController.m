//
//  GameViewController.m
//  WordGrid
//
//  Created by admin on 12-10-14.
//
//

#import "GameViewController.h"
#import "Round.h"
#import "GridView.h"
#import "AnswerView.h"
#import "Tile.h"

@interface GameViewController ()

@property (strong) NSArray *indexes;
@property (strong) NSMutableArray* answerRefs;

@end

@implementation GameViewController

@synthesize round = _round;
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
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self.tileGrid setHidden:NO];
//    
//    [self.answerGrid setup]; // answer grid needs to be setup first
//    [self.tileGrid setup];
    
    self.answerRefs = [[NSMutableArray alloc] initWithCapacity:20];
    
    NSURL *tickURLRef = [[NSBundle mainBundle] URLForResource:@"correctWord" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &correctWordSoundID);
    
    tickURLRef = [[NSBundle mainBundle] URLForResource:@"error" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &errorSoundID);
    
    tickURLRef = [[NSBundle mainBundle] URLForResource:@"returnWords" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &returnWordsSoundID);
    
    tickURLRef = [[NSBundle mainBundle] URLForResource:@"win" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &winSoundID);    

}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(tileSelected:)
     name:@"onGridTileSelected"
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
    
    
//    [self.tileGrid subviewDidAppear];
//    [self.answerGrid subviewDidAppear];
    
}
-(void) viewDidDisappear:(BOOL)animated
{
//    [super viewDidDisappear:animated];
//    [self.tileGrid subviewDidDisappear];
//    [self.answerGrid subviewDidDisappear];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onGridTileSelected" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onAnswerGridTileSelected" object:nil];
}

- (void) newRound
{
//    [self.tileGrid setHidden:NO];
//    
//    [AnswerData incrementIndex];
//    
//    [self.tileGrid createRound];
//    [self.answerGrid createRound];
//    
//    NSString *let = [self.answerGrid getCurrentCorrectLetter];
//    [self.tileGrid setSelectableByLetter:let];
//    
//    self.indexes = [AnswerData getCurrentIndexes];
//    
//    // first letter is a gift
//    [self autoSelectFirstLetter];    
}

- (void) tileSelected:(NSNotification *)notification
{
    Tile *t = (Tile *)[notification object];
    [self onTileSelected:t];
}

- (void) onTileSelected:(Tile *)t
{
//    lastSelectedTileIndex = t.gridIndex;
//    
//    if(t.isSelectable)
//    {
//        Tile *at = [self.answerGrid getNextTile];
//        CGRect orgFrame = at.frame;//CGRectInset(at.frame, 0, 0);
//        at.hidden = NO;
//        at.frame = CGRectMake( -self.answerGrid.frame.origin.x + self.tileGrid.frame.origin.x + t.frame.origin.x,
//                              -self.answerGrid.frame.origin.y + self.tileGrid.frame.origin.y + t.frame.origin.y,
//                              t.frame.size.width,
//                              t.frame.size.height);
//        //NSLog(@"org: %f %f", t.frame.size.width, t.frame.size.height);
//        [self.answerGrid setNextTileUsingTile:t];
//        
//        [UIView
//         animateWithDuration:0.3
//         delay:letterMoveDelay
//         options: UIViewAnimationCurveEaseOut
//         animations:^
//         {
//             at.frame = orgFrame;
//         }
//         completion:^(BOOL finished)
//         {
//             if(finished)
//             {
//                 [at setIsSelectable:YES];
//                 [self testWordComplete];
//             }
//         }
//         ];
//        
//        [self.answerRefs addObject:t];
//        
//        if([self.answerGrid atWordBoundry])
//        {
//            Boolean correct = [self.answerGrid testCurrentWordCorrect];
//            if(correct)
//            {
//                [self.tileGrid setAllIsSelectable:NO];
//                AudioServicesPlaySystemSound(correctWordSoundID);
//            }
//            else
//            {
//                AudioServicesPlaySystemSound(errorSoundID);
//            }
//        }
//        else
//        {
//            [self.tileGrid setSelectableAroundIndex:lastSelectedTileIndex];
//        }
//    }
}

- (void) answerSelected:(NSNotification *)notification
{
//    Tile *t = (Tile *)[notification object];
//    int firstLetter = [self.answerGrid getWordStartIndex:t.gridIndex];
//    int lastRemoved = [self.answerGrid getCurrentWordStart];
//    [self.tileGrid resetAnimationDelay:0];
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
//                [self.tileGrid insertLastVerticalGaps];
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
//                    Tile *targ = [self.tileGrid insertTile:answerSrc At:answerSrc.originalIndex];
//                    
//                    targ.frame = CGRectMake(
//                                            self.answerGrid.frame.origin.x - self.tileGrid.frame.origin.x + answerSrc.frame.origin.x,
//                                            self.answerGrid.frame.origin.y - self.tileGrid.frame.origin.y + answerSrc.frame.origin.y,
//                                            answerSrc.frame.size.width,
//                                            answerSrc.frame.size.height);
//                    
//                    [self.tileGrid bringSubviewToFront:targ];
//                    [targ setSelected:NO];
//                    [answerSrc setLetter:@""];
//                }
//                [self.tileGrid layoutGrid:YES];
//            }
//        }
//        else
//        {
//            Tile *targ = [self.tileGrid getTileAtIndex:rt.originalIndex];
//            [targ setSelected:NO];
//            [self.tileGrid bringSubviewToFront:targ];
//            [rt setLetter:@""];
//        }
//        
//    }
//    
//    [self.answerRefs removeAllObjects];
//    [self.tileGrid resetGrid];
//    [self.tileGrid layoutGrid:YES];
//    NSString *let = [self.answerGrid getCurrentCorrectLetter];
//    [self.tileGrid setSelectableByLetter:let];
//    AudioServicesPlaySystemSound(returnWordsSoundID);
}

- (void) testWordComplete
{
//    if([self.answerGrid atWordBoundry])
//    {
//        [self.tileGrid resetGrid];
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
//                Tile *corTile = [self.tileGrid getTileAtIndex:[corIndex integerValue]];
//                [self.answerRefs replaceObjectAtIndex:i withObject:corTile];
//                
//                Tile *answerTile = [self.answerGrid getTileAtIndex:curAnswerIndex - self.answerRefs.count + i];
//                answerTile.originalIndex = [corIndex integerValue];
//            }
//        }
//        
//        [self.tileGrid removeWordAndDrop:self.answerRefs];
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
//            [self.tileGrid setSelectableByLetter:let];
//        }
//    }
}

- (void) autoSelectFirstLetter
{
//    if([self.tileGrid isMemberOfClass:[TileGrid class]])
//    {
//        letterMoveDelay = 0.5;
//        NSNumber *firstTileIndex = [self.indexes objectAtIndex:0];
//        Tile *t = [self.tileGrid getTileAtIndex:[firstTileIndex integerValue] ];
//        
//        [self.view insertSubview:self.answerGrid aboveSubview:self.tileGrid];
//        [self.tileGrid bringSubviewToFront:t];
//        [self.tileGrid ownTileSelected:t];
//        letterMoveDelay = 0.0;
//    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
