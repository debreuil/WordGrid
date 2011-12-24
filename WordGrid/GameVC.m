#import "GameVC.h"
#import "TileGrid.h"
#import "Tile.h"

@implementation GameVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
    }
    return self;
}

#pragma mark - View lifecycle

- (void)onDone:(id)sender
{
    NSLog(@"done");
}

- (void) tileSelected:(NSNotification *)notification
{
    Tile *t = (Tile *)[notification object];
    lastSelectedTileIndex = t.gridIndex;
    
    if(t.isSelectable)
    {        
        Tile *at = [answerGrid getNextTile];//[answerTiles objectAtIndex:answerIndex];
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
             at.frame = orgFrame;//[[answerFrames objectAtIndex:answerIndex] CGRectValue];
         } 
         completion:^(BOOL finished)
         {
             if(finished)
             {
                 [self testWordComplete];
                 [at setIsSelectable:YES];
             }
         }
         ];
        
        [answerRefs addObject:t];
        
        if([answerGrid atWordBoundry])
        {  
            [tileGrid setAllIsSelectable:NO];
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
    
    for (int i = [answerGrid getAnswerIndex] - 1; i >= firstLetter; i--) 
    {
        Tile *rt = [answerGrid removeCurrentTile];  
        [rt setIsSelectable:NO];
        
        Tile *targ;
        if (i < lastRemoved) 
        {
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
}

- (void) testWordComplete
{
    if([answerGrid atWordBoundry]) //answerIndex > 3)
    {        
        [tileGrid resetGrid];  
        [tileGrid removeTilesAndDrop:answerRefs];
        
        [answerRefs removeAllObjects];
    }
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    [self setOrientation];
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
    
    if (io == UIInterfaceOrientationPortrait || 
        io == UIInterfaceOrientationPortraitUpsideDown) 
    {
        bkgV.hidden = NO;
        bkgH.hidden = YES;  
        tileGrid.frame = CGRectMake(50, 180, tf.size.width, tf.size.height); 
    }
    else if (io == UIInterfaceOrientationLandscapeLeft || 
             io == UIInterfaceOrientationLandscapeRight) 
    {
        bkgV.hidden = YES;
        bkgH.hidden = NO;
        tileGrid.frame = CGRectMake(300, 170, tf.size.width, tf.size.height);    
    }  
    
    btDone.frame = CGRectMake( tileGrid.frame.origin.x + tileGrid.frame.size.width - df.size.width,
                              tileGrid.frame.origin.y + tileGrid.frame.size.height + 20,
                              df.size.width, 
                              df.size.height);  
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self setOrientation];
}

@end
