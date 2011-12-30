#import "GameVC.h"
#import "TileGrid.h"
#import "Tile.h"
#import "AnswerData.h"

@implementation GameVC

static GameVC *currentGame;

typedef enum { Game, Victory } GameState;
GameState gameState = Game;
Boolean isLandscape = NO;
NSArray *indexes;


SystemSoundID correctWordSoundID;
SystemSoundID errorSoundID;
SystemSoundID returnWordsSoundID;
SystemSoundID winSoundID;

+ (GameVC *) getCurrentGame
{
    return currentGame;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        currentGame = self;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)onDone:(id)sender
{
    [self nextRound];
}

// for level editor
- (AnswerGrid *) getAnswerGrid
{
    return answerGrid;
}

- (void) tileSelected:(NSNotification *)notification
{
    Tile *t = (Tile *)[notification object];
    lastSelectedTileIndex = t.gridIndex;
    
    if(t.isSelectable)
    {        
        Tile *at = [answerGrid getNextTile];
        CGRect orgFrame = at.frame;//CGRectInset(at.frame, 0, 0);
        at.hidden = NO;
        at.frame = CGRectMake( -answerGrid.frame.origin.x + tileGrid.frame.origin.x + t.frame.origin.x,
                              -answerGrid.frame.origin.y + tileGrid.frame.origin.y + t.frame.origin.y,
                              t.frame.size.width,
                              t.frame.size.height);
        //NSLog(@"org: %f %f", at.frame.origin.x, at.frame.origin.y);
        [answerGrid setNextTileUsingTile:t];        
        
        [UIView  
         animateWithDuration:0.3
         delay:0.0
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
        
        [answerRefs addObject:t];
        
        if([answerGrid atWordBoundry])
        {  
            Boolean correct = [answerGrid testCurrentWordCorrect];
            if(correct)
            {
                [tileGrid setAllIsSelectable:NO];
                AudioServicesPlaySystemSound(correctWordSoundID);
            }
            else
            {
                AudioServicesPlaySystemSound(errorSoundID);
            }
        }
        else
        {
            [tileGrid setSelectableAroundIndex:lastSelectedTileIndex];
        }
    }
}

- (void) answerSelected:(NSNotification *)notification
{
    Tile *t = (Tile *)[notification object];
    int firstLetter = [answerGrid getWordStartIndex:t.gridIndex];
    int lastRemoved = [answerGrid getCurrentWordStart];
    [tileGrid resetAnimationDelay];
    
    for (int i = [answerGrid getAnswerIndex] - 1; i >= firstLetter; i--) 
    {
        Tile *rt = [answerGrid removeCurrentTile];  
        [rt setIsSelectable:NO];
        
        Tile *targ;
        if (i < lastRemoved) 
        {
            if(i + 1 == [answerGrid getWordStartIndex:i + 1])
            {
                [tileGrid insertLastVerticalGaps];
            }
            
            targ = [tileGrid insertTile:rt At:rt.originalIndex];
            
            targ.frame = CGRectMake( answerGrid.frame.origin.x - tileGrid.frame.origin.x + rt.frame.origin.x,
                                    answerGrid.frame.origin.y - tileGrid.frame.origin.y + rt.frame.origin.y,
                                    rt.frame.size.width,
                                    rt.frame.size.height); 
            if(i == [answerGrid getWordStartIndex:i])
            {
                [tileGrid layoutGrid:YES];
            }
        }
        else
        {
            targ = [tileGrid getTileAtIndex:rt.originalIndex]; 
        }  
        
        [targ setSelected:NO];
        [tileGrid bringSubviewToFront:targ];         
        [rt setLetter:@""];
    }
    
    [answerRefs removeAllObjects];
    [tileGrid resetGrid];
    [tileGrid layoutGrid:YES];
    NSString *let = [answerGrid getCurrentCorrectLetter];
    [tileGrid setSelectableByLetter:let];
    AudioServicesPlaySystemSound(returnWordsSoundID);
}

- (void) testWordComplete
{
    if([answerGrid atWordBoundry])
    {        
        [tileGrid resetGrid];
        
        Boolean correct = [answerGrid testCurrentWordCorrect];
        if(correct)
        {
 /*         NSRange r = NSMakeRange([answerGrid getAnswerIndex] - answerRefs.count, answerRefs.count);
            NSArray *correctTileIndexes = [indexes subarrayWithRange:r];
            for (int i = 0; i < correctTileIndexes.count; i++) 
            {      
                NSNumber *corIndex = [correctTileIndexes objectAtIndex:i];
                Tile *corTile = [tileGrid getTileAtIndex:[corIndex integerValue]];
                [answerRefs replaceObjectAtIndex:i withObject:corTile];
            }
 */ 
        }
       
        [tileGrid removeWordAndDrop:answerRefs];
        [answerRefs removeAllObjects];
        
        Tile *nextTile = [answerGrid getNextTile];
        if(nextTile == nil)
        {
            // all letters complete
            if([answerGrid didWin])
            {                
                UIFont *f = [UIFont fontWithName:@"VTC Letterer Pro" size:(42.0)];
                txVictory.font = f;
                NSString *s = @"\"";
                s = [s stringByAppendingString:[AnswerData getCurrentQuote]]; 
                s = [s stringByAppendingString:@"\"\r\r"]; 
                s = [s stringByAppendingString:[AnswerData getCurrentSource]];
                txVictory.text = s;
                gameState = Victory;
                [self setOrientation];
                AudioServicesPlaySystemSound(winSoundID);
            }            
        }
        else if([nextTile letterShowing])
        {
            NSString *let = [answerGrid getCurrentCorrectLetter];
            [tileGrid setSelectableByLetter:let];
        }        
    }
}

- (void) nextRound
{
    gameState = Game;
    
    [AnswerData incrementIndex];
    
    [tileGrid createRound];
    [answerGrid createRound];
    
    NSString *let = [answerGrid getCurrentCorrectLetter];
    [tileGrid setSelectableByLetter:let];
    
    indexes = [AnswerData getCurrentIndexes];
    
    [self setOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [answerGrid setup]; // answer grid needs to be setup first
    [tileGrid setup];
    
    answerRefs = [[NSMutableArray alloc] initWithCapacity:20];    
    
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
    
    NSURL *tickURLRef = [[NSBundle mainBundle] URLForResource:@"correctWord" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &correctWordSoundID);  
    
    tickURLRef = [[NSBundle mainBundle] URLForResource:@"error" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &errorSoundID);     
    
    tickURLRef = [[NSBundle mainBundle] URLForResource:@"returnWords" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &returnWordsSoundID);
    
    tickURLRef = [[NSBundle mainBundle] URLForResource:@"win" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &winSoundID);  
    
    [self nextRound];  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;//(interfaceOrientation == UIInterfaceOrientationLandscapeLeft);;
}

- (void) setOrientation
{
    UIInterfaceOrientation io = [self interfaceOrientation];
    CGRect df = btDone.frame;    
    CGRect tf = tileGrid.frame;  
    CGRect af = answerGrid.frame;
    CGRect vf = txVictory.frame;
    
    if (io == UIInterfaceOrientationPortrait || 
        io == UIInterfaceOrientationPortraitUpsideDown) 
    {
        tileGrid.frame = CGRectMake(45, 180, tf.size.width, tf.size.height); 
        answerGrid.frame = CGRectMake(70, 766, af.size.width, af.size.height); 
        btDone.frame = CGRectMake( 284, 500, df.size.width, df.size.height); 
        txVictory.frame = CGRectMake( 84, 200, vf.size.width, vf.size.height);  
        
        if(gameState == Game)
        {
            bkgV.hidden = NO;
            bkgH.hidden = YES;
            txVictory.hidden = YES;
            victoryH.hidden = YES;
            victoryV.hidden = YES;  
            btDone.hidden = YES;
        }
        else if(gameState == Victory)
        {
            bkgV.hidden = YES;
            bkgH.hidden = YES;
            victoryV.hidden = NO; 
            victoryH.hidden = YES; 
            txVictory.hidden = NO;   
            btDone.hidden = NO;          
        }
    }
    else if (io == UIInterfaceOrientationLandscapeLeft || 
             io == UIInterfaceOrientationLandscapeRight) 
    {
        tileGrid.frame = CGRectMake(278, 14, tf.size.width, tf.size.height); 
        answerGrid.frame = CGRectMake(300, 574, af.size.width, af.size.height);
        btDone.frame = CGRectMake( 100, 570, df.size.width, df.size.height); 
        txVictory.frame = CGRectMake( 244, 193, vf.size.width, vf.size.height);
        
        if(gameState == Game)
        {
            bkgV.hidden = YES;
            bkgH.hidden = NO;
            txVictory.hidden = YES;
            victoryH.hidden = YES;
            victoryV.hidden = YES;   
            btDone.hidden = YES;
        }
        else if(gameState == Victory)
        {
            bkgV.hidden = YES;
            bkgH.hidden = YES;
            victoryV.hidden = YES; 
            victoryH.hidden = NO; 
            txVictory.hidden = NO;     
            btDone.hidden = NO;                    
        }  
    }  
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self setOrientation];
}

@end
