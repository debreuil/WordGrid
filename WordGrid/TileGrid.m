#import "Tile.h"
#import "TileGrid.h"
#import "AnswerData.h"

@implementation TileGrid

//static NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"; 
float tw;
float th;

-(id)init
{
    self = [super init];
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self genericSetup];
        [self setup];
    }
    return self;    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self genericSetup];
        [self setup];   
    }
    return self;
}

- (void) genericSetup
{  
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(onSelectTile:) 
     name:@"onTileSelected" 
     object:nil]; 
}
- (void) setup
    {    
    gw = 9;
    gh = 7;
    margin = 4;    
    
    [self createGrid];
}

-(void) createGrid
{     
    lastHoverTileIndex = -1;
    Tile *tile;    
    tiles = [NSMutableArray arrayWithCapacity:gw * gh]; 
    tw = (self.bounds.size.width - margin * (gw - 2)) / gw;
    th = (self.bounds.size.height - margin * (gh - 2)) / gh;    
    slotWidth = tw + margin;   
    slotHeight = th + margin;
    
    CGRect r = CGRectMake(0, 0, tw, th);
    for (int i = 0; i < gh; i++) 
    {
        for (int j = 0; j < gw; j++) 
        {
            tile = [[Tile alloc] initWithFrame:r];
            [tiles addObject:tile];
            tile.gridIndex = i * gw + j;
            [self addSubview:tile];
        }
    }
    [self createLetters];
    [self layoutGrid:NO];
}

- (void) layoutGrid:(Boolean) useAnimation
{            
    float l = margin / 2.0 + (gw - 1) * slotWidth;
    float t = margin / 2.0 + (gh - 1) * slotHeight;
    
    CGRect fr = CGRectMake(l, t, tw, th);
    Tile *tile;
    
    for (int i = gh - 1; i >= 0; i--) 
    {
        for (int j = gw - 1; j >= 0; j--) 
        {
            tile = [tiles objectAtIndex: i * gw + j];
            tile.gridIndex = i * gw + j;
            if(!tile.hidden)
            {
                if(useAnimation && !CGRectEqualToRect(fr, tile.frame))
                {
                    if(!CGRectEqualToRect(tile.animatingFrom, CGRectNull))
                    {
                        tile.frame = tile.animatingFrom;
                        tile.animatingFrom = CGRectNull;
                    }  
                    
                    tile.animatingFrom = tile.frame;
                    animationDelay += .01;
                    [UIView  
                        animateWithDuration:0.3
                        delay:animationDelay
                        options: UIViewAnimationCurveEaseOut
                        animations:^
                        {
                            tile.frame = fr;
                        } 
                        completion:^(BOOL finished){tile.animatingFrom = CGRectNull;}
                     ];
                }
                else
                {
                    tile.frame = fr;
                }
            }
            fr.origin.x -= slotWidth;
        }
        fr.origin.x = l;
        fr.origin.y -= slotHeight;
    }    
}

- (void) createLetters
{ 
    NSString *testString = [AnswerData getCurrentGrid];
    int index = 0;
    for (Tile* t in tiles) 
    {
        //NSString *s = [LETTERS substringWithRange:[LETTERS rangeOfComposedCharacterSequenceAtIndex:arc4random()%[LETTERS length]]]; 
        NSString *s = [testString substringWithRange:NSMakeRange(index++, 1)];
        [t setLetter:s];
        if(![s compare:@" "])
        {
            t.hidden = YES;
        }
    }
    NSLog(@"%@",[self serializeGridLetters]);
}

- (int) getTileIndexFromMousePoint:(CGPoint) point
{
    int tileIndex = -1;    
    if(CGRectContainsPoint(self.bounds, point))
    {
        int tx = (int)(point.x / slotWidth);
        int ty = (int)(point.y / slotHeight);
        tileIndex = ty * gw + tx;
        Tile *t = [tiles objectAtIndex:tileIndex];
        if(tileIndex >= [tiles count] || t.hidden == YES || !t.isSelectable) // || t.selected
        {
            tileIndex = -1;
        }
    }
    return tileIndex;
}

-(void) hoverTileAtPoint:(CGPoint) p
{  
    int tileIndex = [self getTileIndexFromMousePoint:p];
    if(tileIndex > -1)
    {
        if(tileIndex != lastHoverTileIndex && lastHoverTileIndex != -1)
        {
            [[tiles objectAtIndex:lastHoverTileIndex] setIsHovering:(NO)];
        }
        [[tiles objectAtIndex:(tileIndex)] setIsHovering:(YES)];
        [self bringSubviewToFront:[tiles objectAtIndex:(tileIndex)]];
        lastHoverTileIndex = tileIndex;
    }
}

-(void) clearAllHovers
{  
    for (int i = 0; i < [tiles count]; i++) 
    {
        [[tiles objectAtIndex:i] setIsHovering:(NO)];
    }
    lastHoverTileIndex = -1;
}

-(void) clearAllSelections
{  
    for (int i = 0; i < [tiles count]; i++) 
    {
        [[tiles objectAtIndex:i] setSelected:(NO)];
    }
}

-(void) setAllIsSelectable:(Boolean) sel
{
    for (Tile *t in tiles) 
    {
        [t setIsSelectable:sel];
    }
}

- (void) setSelectableByLetter:(NSString *)let
{    
    for (Tile *t in tiles) 
    {
        if([t.letter isEqualToString:let])
        {
            [t setIsSelectable:YES];            
        }
        else
        {
            [t setIsSelectable:NO]; 
        }
    }
}

- (Tile *)  getTileAtIndex:(int) index
{
    return [tiles objectAtIndex:index];
}

- (CGPoint) getPointFromIndex:(int)index
{
    CGPoint p = CGPointMake(floor(index % gw), floor(index / gw));
    //NSLog(@"x: %f, y: %f", p.x, p.y);
    return p;
}
                  
- (Tile *) getTileFromPoint:(CGPoint)p
{
    Tile *result = nil;
    if(p.x >= 0 && p.x < gw && p.y >= 0 && p.y < gh)
    {
        result = [tiles objectAtIndex:(p.y * gw + p.x)];
    }
    return result;
}

-(void) setSelectableAroundIndex:(int) index
{
    [self setAllIsSelectable:NO];
    
    CGPoint gp = [self getPointFromIndex:index];
    for (int i = gp.x - 1; i <= gp.x + 1; i++) 
    {
        for (int j = gp.y - 1; j <= gp.y + 1; j++) 
        {
            Tile *t = [self getTileFromPoint:CGPointMake(i, j)];
            if(t != nil && t.hidden == NO && t.selected == NO)
            {
                [t setIsSelectable:YES];
            }
        }
    }
}

-(void) checkForVerticalGaps
{
    //NSMutableArray gaps = [[NSMutableArray alloc] init];
    hasGap = NO;    
    Boolean hasTiles = NO;
    int firstColumnToCheck = gw * (gh - 1) + 1;
    
    for (int i = firstColumnToCheck; i < gw * gh; i++) 
    {
        Tile *t = [tiles objectAtIndex:i];
        if(t.hidden == YES)
        {
            if(hasTiles)
            {
                hasGap = YES;
                if(hasTiles)
                {
                    for (int j = 0; j < gh; j++) 
                    {
                        int cutIndex = i - (gw * j);
                        Tile *cutTile = [tiles objectAtIndex:cutIndex];
                        [tiles removeObjectAtIndex:cutIndex];
                        [tiles insertObject:cutTile atIndex:(gw * (gh - j - 1))];           
                    }
                }
            }
        }
        else
        {
            hasTiles = YES;
        }    
    }    
    
    if(hasGap)
    {
        [self layoutGrid:YES];
    }
}

-(void) removeTilesAndDrop:(NSArray *) indexes
{
    animationDelay = 0.3;
    for (Tile *t in indexes) 
    {
        [self removeTile:t.gridIndex];
    }
    [self layoutGrid:YES];
    animationDelay += 0.1;
    [self checkForVerticalGaps];
}

-(void) removeTile:(int) index
{
    Tile *t = [tiles objectAtIndex:index];
    if(t.hidden == NO)
    {
        t.hidden = YES;
        CGPoint p = [self getPointFromIndex:index];
        CGPoint prevPoint = CGPointMake(p.x, p.y);
        Tile *nextT;
        int nextIndex = t.gridIndex;
        t.gridIndex = -1;
        
        for (int i = p.y - 1; i >= 0; i--) 
        {
            prevPoint = CGPointMake(prevPoint.x, prevPoint.y - 1);
            nextT = [self getTileFromPoint:prevPoint];
            if(nextT.hidden == NO)
            {
                [tiles exchangeObjectAtIndex:nextIndex withObjectAtIndex:nextT.gridIndex];
                int temp = nextT.gridIndex;
                nextT.gridIndex = nextIndex;
                nextIndex = temp;            
            }
        } 
    }
}

- (Tile *) insertTile:(Tile *)tile At:(int) index
{    
    int topIndex = index % gw;
    Tile *result = [tiles objectAtIndex:topIndex];
    [result setLetter:tile.letter];
    [result setHidden:NO];

    for (int i = index; i >= gw; i -= gw) 
    {           
        if([[tiles objectAtIndex:i] gridIndex] != -1)
        {
            [tiles exchangeObjectAtIndex:i withObjectAtIndex:topIndex];
        }
    }
    [result setGridIndex:-1];

    return result;
}

-(void) resetGrid
{
    [self clearAllHovers];
    [self clearAllSelections];
    [self setAllIsSelectable:YES];
}

- (void) onSelectTile:(NSNotification *)notification
{    
    Tile *tile = (Tile *)[notification object];
    if([tile superview] == self)
    {
        [self ownTileSelected:tile];
    }
}

- (void) ownTileSelected:(Tile *)tile;
{   
    [tile setSelected:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onGridTileSelected" object:tile];    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *t = [touches anyObject];
    [self hoverTileAtPoint:[t locationInView:self]];    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *t = [touches anyObject];
    [self hoverTileAtPoint:[t locationInView:self]];        
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{ 
    [super touchesEnded:touches withEvent:event];
    
    [self clearAllHovers];
    
    /*
    UITouch *t = [touches anyObject];
    int tileIndex = [self getTileIndexFromMousePoint:[t locationInView:self]];    
    if(tileIndex > -1)
    {
        Tile *tile = [tiles objectAtIndex:tileIndex];
        [self onSelectTile:tile];
    }  
    */
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

- (NSString *) serializeGridLetters
{
    NSMutableString *s = [NSMutableString stringWithCapacity:tiles.count];
    
    for (Tile *t in tiles) 
    {
        if(t.gridIndex % gw == 0)
        {
            [s appendString:@"\r"];
        }
        [s appendString:t.letter];
    }    
    return s;
}

@end







