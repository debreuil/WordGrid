
#import "LevelEditorGrid.h"
#import "Tile.h"
#import "AnswerGrid.h"
#import "AnswerData.h"
#import "GameVC.h"

@implementation LevelEditorGrid

int answerIndex;
int rightmostColumn;
NSMutableArray *indexes;
AnswerGrid *answerGrid;

- (void) setup
{    
    answer = [AnswerData getCurrentQuote];
    //answer = [answer stringByReplacingOccurrencesOfString:@" " withString:@""];
    answerIndex = [answer length] - 1;
    
    gw = 9;
    gh = 7;
    margin = 4;
    rightmostColumn = gw;
        
    [self createGrid];  
    [self setAllIsSelectable:YES];
    
}

- (void) createLetters
{ 
    answerGrid = [[GameVC getCurrentGame] getAnswerGrid];    
    [answerGrid setDirection:-1];
    indexes = [[NSMutableArray alloc] initWithCapacity:100];
        
    for (Tile* t in tiles) 
    {
        NSString *s = @" "; 
        [t setLetter:s];
    }
}

- (BOOL) isValidInsertLocation:(int)index
{
    BOOL result = NO;
    if(index >= 0 && index < gw * gh)
    {
        Tile *t = [tiles objectAtIndex:index];
        if(t != nil && t.hidden == NO && t.gridIndex % gw >= rightmostColumn - 1)
        {
            result = YES;
            if(t.gridIndex + gw < gw * gh)
            {
                Tile *lowerTile = [tiles objectAtIndex:t.gridIndex + gw];
                if(lowerTile.letter == @" ")
                {
                    result = NO;
                }
            }
        }
    }
    return result;
}

-(void) setAllIsSelectable:(Boolean) sel
{
    for (Tile *t in tiles) 
    {
        BOOL select = [self isValidInsertLocation:t.gridIndex] ? sel : NO;
        [t setIsSelectable:select];
    }
    
}
- (void) setSelectableByLetter:(NSString *)let
{    
    [answerGrid showAllLetters];
}

- (NSMutableArray *) getValidNextInsertionIndexes:(int) index
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:8];
    
    CGPoint gp = [self getPointFromIndex:index];
    for (int i = gp.x - 1; i <= gp.x + 1; i++) 
    {
        for (int j = gp.y - 1; j <= gp.y + 1; j++) 
        {
            if ([self isValidInsertLocation:j * gw + i]) 
            {                
                Tile *t = [self getTileFromPoint:CGPointMake(i, j)];
                [result addObject:[NSNumber numberWithInt:j * gw + i]];
                [t setIsSelectable:YES];
            }
        }
    }
    return result;
}

- (void) deselectAll
{
    for (Tile *t in tiles) 
    {
        [t setSelected:NO];
    }
}

- (void) ownTileSelected:(Tile *)tile;
{  
    [self clearAllHovers];
    [self setAllIsSelectable:NO];
    [tile setSelected:YES];
    
    int tileIndex = tile.gridIndex; 
    if (tileIndex % gw < rightmostColumn) 
    {
        rightmostColumn--;
    }
    
    if(tile.letter != @" ")
    {
        // shift letters up         
        CGPoint p = [self getPointFromIndex:tileIndex];
        int lastTileIndex = p.y * gw + p.x;
        Tile *lastTile = [tiles objectAtIndex:lastTileIndex];
        NSString *lastLetter = lastTile.letter;
        for (int i = p.y - 1; i >= 0; i--) 
        {
            lastTileIndex -= gw;
            lastTile = [tiles objectAtIndex:lastTileIndex];
            if (!lastTile.selected) 
            {                
                NSString *temp = lastTile.letter;
                [lastTile setLetter:lastLetter];
                lastLetter = temp;
            }
        }
    }
    
    [tile setLetter:[answer substringWithRange:NSMakeRange(answerIndex, 1)]];
    
    [answerGrid setNextTileUsingTile:tile];
    
    [indexes addObject:[NSNumber numberWithInteger:tile.gridIndex]];
    
    answerIndex--;
    if(answerIndex < 0)
    {
        NSLog(@"%@", [self serializeGridLetters]);
    }
    else
    {
        char nextChar = [answer characterAtIndex:answerIndex];
        if(nextChar == ' ')
        {
            answerIndex--;
            [self setAllIsSelectable:YES];
            [self deselectAll];
        }
        else
        {
            [self getValidNextInsertionIndexes:tileIndex];
        }
    }
}

- (NSString *) serializeGridLetters
{
    NSMutableString *s = [NSMutableString stringWithCapacity:tiles.count];
    
    for (Tile *t in tiles) 
    {
        //if(t.gridIndex % gw == 0)
        //{
        //    [s appendString:@"\r"];
        //}
        [s appendString:t.letter];
    } 
    
    [s appendString:@"\r\""];
    NSString *comma = @"";
    
    for (NSNumber *n in indexes) 
    {
        [s appendString:comma];
        [s appendString:[NSString stringWithFormat:@"%i", [n intValue]] ];
        comma = @",";
    }
    
    [s appendString:@"\""];
    return s;
} 

@end
