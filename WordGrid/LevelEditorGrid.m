
#import "LevelEditorGrid.h"
#import "Tile.h"
#import "AnswerData.h"
#import "GameVC.h"

@implementation LevelEditorGrid

@synthesize answerGrid = _answerGrid;

int answerIndex;
int rightmostColumn;
NSMutableArray *sequence;
int wordLength;

- (void) setup
{    
    self.gridWidth = 9;
    self.gridHeight = 7;
    self.margin = 4;    
        
    [self createGrid];
}
- (void) createLetters
{ 
    rightmostColumn = self.gridWidth;  
    
    answer = [AnswerData getCurrentQuote];
    //answer = [answer stringByReplacingOccurrencesOfString:@" " withString:@""];
    answer = [answer stringByReplacingOccurrencesOfString:@"," withString:@""];
    answer = [answer stringByReplacingOccurrencesOfString:@"." withString:@""];
    answer = [answer stringByReplacingOccurrencesOfString:@"'" withString:@""];
    answerIndex = [answer length] - 1;
    
    //answerGrid = [[GameVC getCurrentGame] getAnswerGrid];
    sequence = [[NSMutableArray alloc] initWithCapacity:100];
    wordLength = 0;
        
    for (Tile* t in self.tiles) 
    {
        NSString *s = @" "; 
        [t setLetter:s];
    }
    
    [self setAllIsSelectable:YES];
    [self.answerGrid showAllLetters];
}
- (BOOL) isAtEndOfWord
{
    BOOL result = NO;
    if(answerIndex >= answer.length - 1 || [answer characterAtIndex:answerIndex + 1] == ' ')
    {
        result = YES;
    }
    return result;
}
- (BOOL) tileIndicatesColumnInsert:(Tile *)t
{    
    BOOL result = NO;
    
    // check for top row inserts
    if (t != nil &&
        t.gridIndex < self.gridWidth &&
        t.gridIndex > rightmostColumn &&
        t.letter == @" ")
    {
        Tile *tileUnder = [self.tiles objectAtIndex:t.gridIndex + self.gridWidth];
        if(tileUnder.letter == @" ")
        {
            result = YES;
        }            
    }

    return result;
}
- (BOOL) isValidInsertLocation:(int)index
{
    BOOL result = NO;
    if(index >= 0 && index < self.gridWidth * self.gridHeight)
    {
        Tile *t = [self.tiles objectAtIndex:index];
        if(t != nil && t.hidden == NO && t.gridIndex % self.gridWidth >= rightmostColumn - 1)
        {
            result = YES;
            if(t.gridIndex + self.gridWidth < self.gridWidth * self.gridHeight)
            {
                Tile *lowerTile = [self.tiles objectAtIndex:t.gridIndex + self.gridWidth];
                if(lowerTile.letter == @" ")
                {
                    result = NO;
                }
            }
        }
        
        // check for top row inserts
        if (result == NO && [self isAtEndOfWord] && [self tileIndicatesColumnInsert:t] )
        {
            result = YES;
        }
    }
    return result;
}
-(void) setAllIsSelectable:(Boolean) sel
{
    for (Tile *t in self.tiles) 
    {
        BOOL select = [self isValidInsertLocation:t.gridIndex] ? sel : NO;
        [t setIsSelectable:select];
    }
    
}
- (void) setSelectableByLetter:(NSString *)let
{    
    [self.answerGrid showAllLetters];
}
- (NSMutableArray *) getValidNextInsertionIndexes:(int) index
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:8];
    
    CGPoint gp = [self getPointFromIndex:index];
    for (int i = gp.x - 1; i <= gp.x + 1; i++) 
    {
        for (int j = gp.y - 1; j <= gp.y + 1; j++) 
        {
            if ([self isValidInsertLocation:j * self.gridWidth + i]) 
            {                
                Tile *t = [self getTileFromPoint:CGPointMake(i, j)];
                [result addObject:[NSNumber numberWithInt:j * self.gridWidth + i]];
                [self clearAllSelections];
                [t setIsSelectable:YES];
            }
        }
    }
    return result;
}
- (void) deselectAll
{
    for (Tile *t in self.tiles) 
    {
        [t setSelected:NO];
    }
}
- (void) writeWordIndexes
{
    int end = sequence.count - 1;
    for (int i = end; i > end - wordLength; i--) 
    {
        Tile *t = [sequence objectAtIndex:i];
        t.resultIndex = t.gridIndex;
    }
    wordLength = 0;
}
- (void) insertLetter:(Tile *) tile
{    
    [self setAllIsSelectable:NO];
    
    int tileIndex = tile.gridIndex; 
    if (tileIndex % self.gridWidth < rightmostColumn) 
    {
        rightmostColumn--;
    }
    
    if(tile.letter != @" ")
    {
        // shift letters up         
        CGPoint p = [self getPointFromIndex:tileIndex];
        int srcTileIndex = p.y * self.gridWidth + p.x;
        Tile *srcTile = [self.tiles objectAtIndex:srcTileIndex];        
        Tile *destTile;
        
        for (int i = srcTileIndex; i >= 0; i -= self.gridWidth) 
        {
            destTile = [self.tiles objectAtIndex:i];
            [self.tiles replaceObjectAtIndex:i withObject:srcTile];
            srcTile = destTile;
        }
        [self.tiles replaceObjectAtIndex:tileIndex withObject:srcTile];
        tile = srcTile;
        [self layoutGrid:NO];
    }
    
    [tile setSelected:YES];    
    [tile setLetter:[answer substringWithRange:NSMakeRange(answerIndex, 1)]];
    
    [self.answerGrid setNextTileUsingTile:tile];
    
    [sequence addObject:tile];
    wordLength++;
    
    answerIndex--;
    if(answerIndex < 0)
    {
        [self writeWordIndexes];
        NSLog(@"%@", [self serializeGridLetters]);    
        [[GameVC getCurrentGame] nextRound];
    }
    else
    {
        char nextChar = [answer characterAtIndex:answerIndex];
        if(nextChar == ' ')
        {
            answerIndex--;
            [self setAllIsSelectable:YES];
            [self deselectAll];
            [self writeWordIndexes];
        }
        else
        {
            [self getValidNextInsertionIndexes:tileIndex];
        }
    }
}
- (void) ownTileSelected:(Tile *)tile;
{  
    [self clearAllHovers];
    if([self tileIndicatesColumnInsert:tile])
    {
        int col = tile.gridIndex % self.gridWidth;
        [self moveColumn:0 toColumn:col];
        rightmostColumn--;
        [self layoutGrid:NO];
        [self setAllIsSelectable:YES];
        [self deselectAll];
    }
    else
    {
        [self insertLetter:tile];
    }
}
- (NSString *) serializeGridLetters
{
    /*
     [NSArray arrayWithObjects:
     @"THE TRUE MYSTERY OF THE WORLD IS THE VISIBLE NOT THE INVISIBLE", 
     @"           TRIEHT VTEUNTSYMIHINVERYOSEEOIIBLFISWTSTHEEBLORLDEHT",
     @"Oscar Wilde", 
     @"62,61,60,59,58,49,40,31,22,61,60,59,57,48,39,56,55,54,45,36,27,18,60,61,62,46,47,59,58,57,56,47,37,28,19,44,35,34,33,32,23,24,25,26,20,21,12,11,14,15,16", nil
     ],
     */
    NSMutableString *s = [NSMutableString stringWithCapacity:self.tiles.count];  
    [s appendString:@"\r\r[NSArray arrayWithObjects:\r"];    
    [s appendString:@"@\""]; [s appendString:answer]; [s appendString:@"\",\r"];
    
    
    [s appendString:@"@\""];
    for (Tile *t in self.tiles) 
    {
        [s appendString:t.letter];
    }     
    [s appendString:@"\",\r"];
    
    
    [s appendString:@"@\""];
    [s appendString:[AnswerData getCurrentSource]];
    [s appendString:@"\",\r"];
    
    
    [s appendString:@"@\""];
    NSString *comma = @"";    
    for (int i = sequence.count - 1; i >= 0; i--) 
    {
        Tile *t = [sequence objectAtIndex:i];
        [s appendString:comma];
        [s appendString:[NSString stringWithFormat:@"%i", t.resultIndex] ];
        comma = @",";
    }    
    [s appendString:@"\", nil\r"];
    
    [s appendString:@"],\r"];
    return s;
} 

@end
