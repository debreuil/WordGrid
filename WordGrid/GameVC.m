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
        Tile *at = [answerTiles objectAtIndex:answerIndex];
        at.hidden = NO;
        at.frame = CGRectOffset(t.frame, tileGrid.frame.origin.x, tileGrid.frame.origin.y);  
        [at setLetter:t.letter];
        [at setSelected:YES];
        
        [UIView  
         animateWithDuration:0.3
         delay:0.0
         options: UIViewAnimationCurveEaseOut
         animations:^
         {
             at.frame = [[answerFrames objectAtIndex:answerIndex] CGRectValue];
         } 
         completion:^(BOOL finished)
         {
             if(finished)
             {
                 [self testWordComplete];
             }
         }
         ];
        
        [answerRefs addObject:t];
        answerIndex++;
        if(answerIndex < 4)
        {  
            [tileGrid setSelectableAroundIndex:lastSelectedTileIndex];
        }
        else
        {
            [tileGrid setAllIsSelectable:NO];
        }
    }
}

- (void) testWordComplete
{
    if(answerIndex > 3)
    {        
        answerIndex = 0;
        [tileGrid  resetGrid];   
        for (Tile *t in answerTiles) 
        {
            t.hidden = YES;
        }
        
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
    
    answerIndex = 0;
    answerRefs = [[NSMutableArray alloc] initWithCapacity:4];
    answerTiles = [[NSArray alloc] initWithObjects:letter0, letter1, letter2, letter3, nil]; 
    answerFrames = [[NSArray alloc] initWithObjects:
                    [NSValue valueWithCGRect:letter0.frame],
                    [NSValue valueWithCGRect:letter1.frame],
                    [NSValue valueWithCGRect:letter2.frame],
                    [NSValue valueWithCGRect:letter3.frame],
                    nil]; 
    for (Tile *t in answerTiles) 
    {
        t.hidden = YES;
    }
    
	[[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(tileSelected:) 
     name:@"onTileSelected" 
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
        tileGrid.frame = CGRectMake(50, 220, tf.size.width, tf.size.height); 
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
