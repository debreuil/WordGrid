#import "TileGrid.h"
#import "Tile.h"
#import "AnswerData.h"


@implementation TileGrid

@synthesize tileGridView = _tileGridView;
@synthesize tiles = _tiles;
@synthesize gapsInserted = _gapsInserted;
@synthesize gridWidth = _gridWidth;
@synthesize gridHeight = _gridHeight;

- (void) didAppear
{
    [self.tileGridView subviewDidAppear];
}
- (void) didDisappear
{
    [self.tileGridView subviewDidDisappear];
}
- (void) setup
{    
    self.gridWidth = 9;
    self.gridHeight = 7;
    self.gapsInserted = [[NSMutableArray alloc] initWithCapacity:20];
    
    [self createGrid];
}

-(void) createGrid
{     
    Tile *tile;    
    self.tiles = [NSMutableArray arrayWithCapacity:self.gridWidth * self.gridHeight];
    
    for (int i = 0; i < self.gridHeight; i++) 
    {
        for (int j = 0; j < self.gridWidth; j++) 
        {
            tile = [[Tile alloc] init];
            [self.tiles addObject:tile];
            tile.gridIndex = i * self.gridWidth + j;
        }
    }
    [self createLetters];
}

- (void) createLetters
{
    NSString *testString = [AnswerData getCurrentGrid];
    int index = 0;
    for (Tile* t in self.tiles)
    {
        NSString *s = [testString substringWithRange:NSMakeRange(index++, 1)];
        [t setLetter:s];
    }
    NSLog(@"%@",[self serializeGridLetters]);
}

- (Tile *)  getTileAtIndex:(int) index
{
    return [self.tiles objectAtIndex:index];
}

- (CGPoint) getPointFromIndex:(int)index
{
    CGPoint p = CGPointMake(floor(index % self.gridWidth), floor(index / self.gridWidth));
    //NSLog(@"x: %f, y: %f", p.x, p.y);
    return p;
}
                  
- (Tile *) getTileFromPoint:(CGPoint)p
{
    Tile *result = nil;
    if(p.x >= 0 && p.x < self.gridWidth && p.y >= 0 && p.y < self.gridHeight)
    {
        result = [self.tiles objectAtIndex:(p.y * self.gridWidth + p.x)];
    }
    return result;
}
- (void) moveColumn:(int)src toColumn:(int)dest
{    
    for (int j = 0; j < self.gridHeight; j++) 
    {
        // put this column into the left most column
        int cutIndex = src + (self.gridWidth * j);
        Tile *cutTile = [self.tiles objectAtIndex:cutIndex];
        [self.tiles removeObjectAtIndex:cutIndex];
        [self.tiles insertObject:cutTile atIndex:dest + (self.gridWidth * j)];           
    }
}

- (void) insertLastVerticalGaps
{
    if(self.gapsInserted.count > 0)
    {
        NSMutableArray *gaps = [self.gapsInserted objectAtIndex:self.gapsInserted.count - 1];
        [self.gapsInserted removeObjectAtIndex:self.gapsInserted.count - 1];
        
        for(int i = gaps.count - 1; i >= 0; i--)
        {
            NSNumber *val = [gaps objectAtIndex:i];
            [self moveColumn:0 toColumn:[val intValue]];
        }
    }
}

- (void) removeVerticalGaps
{
    Boolean hasGap = NO;
    Boolean hasTiles = NO;
    int firstColumnToCheck = self.gridWidth * (self.gridHeight - 1) + 1;
    NSMutableArray *gaps = [[NSMutableArray alloc] init];
    
    for (int i = firstColumnToCheck; i < self.gridWidth * self.gridHeight; i++) 
    {
        Tile *t = [self.tiles objectAtIndex:i];
        if(t.hidden == YES)
        {
            if(hasTiles) // ignore leading blank columns
            {
                hasGap = YES;
                [gaps addObject:[NSNumber numberWithInt:(i % self.gridWidth)]];
                [self moveColumn:(i % self.gridWidth) toColumn:0];
            }
        }
        else
        {
            hasTiles = YES;
        }    
    }    
    
    [self.gapsInserted addObject:gaps];
    
    if(hasGap)
    {
        [self.tileGridView layoutGrid:YES];
    }
}

-(void) removeWord:(NSArray *) indexesToRemove
{
    for (Tile *t in indexesToRemove)
    {
        [self removeTile:t.gridIndex];
    }
    [self.tileGridView dropRemovedWord];
}

-(void) removeTile:(int) index
{
    //NSLog(@"remove: %i (x:%i y:%i)", index, index % gw, (int)(index / gw));
    Tile *t = [self.tiles objectAtIndex:index];
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
                [self.tiles exchangeObjectAtIndex:nextIndex withObjectAtIndex:nextT.gridIndex];
                int temp = nextT.gridIndex;
                nextT.gridIndex = nextIndex;
                nextIndex = temp;            
            }
        } 
    }
}

- (Tile *) insertTile:(Tile *)tile At:(int) index
{    
    //NSLog(@"insert: %i (x:%i y:%i)", index, index % gw, (int)(index / gw));
    int topIndex = index % self.gridWidth;
    Tile *result = [self.tiles objectAtIndex:topIndex];
    [result setLetter:tile.letter];
    [result setHidden:NO];

    for (int i = index; i >= self.gridWidth; i -= self.gridWidth) 
    {           
        if([[self.tiles objectAtIndex:i] gridIndex] != -1)
        {
            [self.tiles exchangeObjectAtIndex:i withObjectAtIndex:topIndex];
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

- (NSString *) serializeGridLetters
{
    NSMutableString *s = [NSMutableString stringWithCapacity:self.tiles.count];
    
    for (Tile *t in self.tiles) 
    {
        if(t.gridIndex % self.gridWidth == 0)
        {
            [s appendString:@"\r"];
        }
        [s appendString:t.letter];
    }    
    return s;
}

@end







