//
//  Grid.m
//  WordGridTests
//
//  Created by admin on 12-12-02.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import "Grid.h"
#import "Tile.h"
#import "TileWord.h"
#import "Answer.h"

@interface Grid()
{
    NSMutableArray *grid;
    NSMutableArray *selectedLetters;
    int elementCount;
}

- (CGPoint) getPointFromIndex:(int)index;
- (void) removeTile:(Tile *) t;
- (void) removeVerticalGaps:(TileWord *) word;
- (void) insertVerticalGaps:(TileWord *) word;
- (void) swapColumns:(int)src toColumn:(int)dest;
- (void) setTile:(Tile *) t atPoint:(CGPoint)pt;

@end


@implementation Grid

@synthesize gridSize = _gridSize;

- (id)init
{
    self = [super init];
    if(self)
    {
        grid = [[NSMutableArray alloc] initWithCapacity:100];
        selectedLetters = [[NSMutableArray alloc] initWithCapacity:30];
    }
    return self;
}

- (id)initWithAnswer:(Answer *)answer
{
    self = [super init];
    if(self)
    {
        grid = [[NSMutableArray alloc] initWithCapacity:answer.gridSize.width * answer.gridSize.height];
        selectedLetters = [[NSMutableArray alloc] initWithCapacity:30];
    }
    return self;
}

-(int) getIndexFromPoint:(CGPoint)pt
{
    return pt.y * self.gridSize.width + pt.x;
}

-(Tile *) getTileFromPoint:(CGPoint)pt
{
    return (Tile *)[grid objectAtIndex:pt.y * self.gridSize.width + pt.x];
}
-(void) setTile:(Tile *) t atPoint:(CGPoint)pt
{
    [grid setObject:t atIndexedSubscript:pt.y * self.gridSize.width + pt.x];
}

-(Tile *) getTileFromIndex:(int)index
{
    return (Tile *)[grid objectAtIndex:index];
}

-(Tile *) getTileFromBoxedIndex:(NSNumber *)index
{
    return (Tile *)[grid objectAtIndex:[index intValue]];
}
-(CGPoint) getPointFromIndex:(int)index
{
    return CGPointMake(floor(index % (int)self.gridSize.width), floor(index / (int)self.gridSize.width));
}

-(NSString *) getLetterFromIndex:(int)index
{
    Tile *t = [grid objectAtIndex:index];
    return t.letter;
}

-(TileWord *) getTileWordFromIndexes:(NSArray *)indexes
{
    id wordTiles[indexes.count];
    NSString *answer = @"";
    for (int i = 0; i < indexes.count; i++)
    {
        NSNumber *gridIndex = [indexes objectAtIndex:i];
        Tile *t = [grid objectAtIndex:[gridIndex intValue]];
        wordTiles[i] = t;
        answer = [answer stringByAppendingString:t.letter];
    }
    NSArray *ar = [NSArray arrayWithObjects:wordTiles count:indexes.count];
    TileWord *result = [[TileWord alloc]initWithAnswer:answer];
    [result addTiles:ar];
    return result;
}

-(void) removeTile:(Tile *) t
{
    int index = [self getIndexFromPoint:t.currentIndex];
    [grid replaceObjectAtIndex:index withObject:[Tile emptyTile]];
    
    for (int i = t.currentIndex.y - 1; i >= 0; i--)
    {
        int newIndex = [self getIndexFromPoint:CGPointMake(t.currentIndex.x, i)];
        Tile *stackedTile = [grid objectAtIndex:newIndex];
        if(![stackedTile isEmptyTile])
        {
            [grid replaceObjectAtIndex:newIndex withObject:[Tile emptyTile]];
            [grid setObject:stackedTile atIndexedSubscript:index];
            stackedTile.currentIndex = CGPointMake(stackedTile.currentIndex.x, i + 1);
            index = newIndex;
        }
        else
        {
            break;
        }
    }
}

-(void) insertTile:(Tile *) t
{
    int index = [self getIndexFromPoint:t.currentIndex];
    Tile * oldTile = [grid objectAtIndex:index];
    [grid replaceObjectAtIndex:index withObject:t];
    
    Tile *temp;
    for (int i = t.currentIndex.y - 1; i >= 0; i--)
    {
        if(![oldTile isEmptyTile])
        {
            CGPoint p = CGPointMake(t.currentIndex.x, i);
            int newIndex = [self getIndexFromPoint:p];
            temp = [grid objectAtIndex:newIndex];
            [grid replaceObjectAtIndex:newIndex withObject:oldTile];
            oldTile.currentIndex = p;
            oldTile = temp;
        }
        else
        {
            break;
        }
    }
}

-(void) removeWord:(TileWord *) word
{
    for (Tile *t in word.tiles)
    {
        [self removeTile:t];
    }
    
    [self removeVerticalGaps:word];
}

-(void) insertWord:(TileWord *) word
{
    [self insertVerticalGaps:word];
    //NSArray *sorted = [word getTilesSortedFromBottomRight];
    NSArray *reversed = [[word.tiles reverseObjectEnumerator] allObjects];
    for (Tile *t in reversed)
    {
        [self insertTile:t];
    }
    //NSLog(@"\r***full\r%@",  [self getGridTrace]);
}

-(void) clearAllSelections
{
    for(Tile *t in grid)
    {
        t.isSelected = NO;
    }
}

-(void) setAllIsSelectable:(Boolean) isSelectable
{
    for (Tile *t in grid)
    {
        t.isSelectable = isSelectable;
    }
}

- (void) setSelectableByLetter:(NSString *)let
{
    for (Tile *t in grid)
    {
        t.isSelectable = [t.letter isEqualToString:let];
    }
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
            if(t && !t.isEmptyTile && !t.isSelected)
            {
                t.isSelectable = YES;
            }
        }
    }
}


-(int) getFirstFilledColumn
{
    int firstFilled;
    for(firstFilled = 0; firstFilled < self.gridSize.width; firstFilled++)
    {
        CGPoint p = CGPointMake(firstFilled, self.gridSize.height - 1);
        Tile *t = [self getTileFromPoint:p];
        if(!t.isEmptyTile)
        {
            break;
        }
    }
    return firstFilled;
}

-(void) removeVerticalGaps:(TileWord *) word
{
    [word.gaps removeAllObjects];
    
    // find first filled element
    int firstFilled = [self getFirstFilledColumn];    
    
    for(int i = self.gridSize.width - 1; i >= 0; i--)
    {        
        CGPoint p = CGPointMake(i, self.gridSize.height - 1);
        Tile *t = [self getTileFromPoint:p];
        if(t.isEmptyTile)
        {
            if(i < firstFilled)// + (int)word.gaps.count + 1)
            {
                break;
            }
            else
            {
                [word.gaps addObject:[NSNumber numberWithInt:i]];
            }
        }
        else if(word.gaps.count > 0)
        {
            [self swapColumns:i toColumn:i + word.gaps.count];
        }        
    }
    //NSLog(@"\r%@ ff: %d\r%@", word.gaps, firstFilled, [self getGridTrace]);
}
-(void) insertVerticalGaps:(TileWord *) word
{
    if(word.gaps.count > 0)
    {
        NSArray *revGaps = [[word.gaps reverseObjectEnumerator] allObjects];
        int head = [self getFirstFilledColumn];

        int shiftCount = revGaps.count;        
        int lastGapIndex = 0;
        int lastGapVal = [[revGaps objectAtIndex:lastGapIndex] intValue];
        
        Boolean finished = NO;
        while(lastGapIndex < revGaps.count && !finished)
        {
            while(head - shiftCount == lastGapVal)
            {
                shiftCount--;
                lastGapIndex++;
                if(lastGapIndex < revGaps.count)
                {
                    lastGapVal = [[revGaps objectAtIndex:lastGapIndex] intValue];
                }
                else
                {
                    finished = YES;
                }
            }
            
            if(!finished)
            {
                [self swapColumns:head toColumn:head - shiftCount];
                head++;
            }
        }
        //NSLog(@"%@ \r%@", revGaps, [self getGridTrace]);
    }
    else
    {        
        //NSLog(@"No Gaps \r%@",  [self getGridTrace]);
    }
    
    [word.gaps removeAllObjects];
}

- (void) swapColumns:(int)src toColumn:(int)dest
{
    for (int j = 0; j < self.gridSize.height; j++)
    {
        CGPoint srcPt = CGPointMake(src, j);
        CGPoint destPt = CGPointMake(dest, j);
        Tile *srcTile = [self getTileFromPoint:srcPt];
        Tile *destTile = [self getTileFromPoint:destPt];
        [self setTile:srcTile atPoint:destPt];        
        [self setTile:destTile atPoint:srcPt];
        srcTile.currentIndex = destPt;        
        destTile.currentIndex = srcPt;
    }
}

- (NSString *) trace
{    
    NSMutableString *s = [NSMutableString stringWithCapacity:elementCount];
    
    int count = 0;
    for (Tile *t in grid)
    {
        if(count++ % (int)(self.gridSize.width) == 0)
        {
            [s appendString:[NSString stringWithFormat:@"\r% 1d|", (int)(count / self.gridSize.width)]];
        }
        [s appendString:t.letter];
    }
    [s appendString:@"\r   ----------"];
    [s appendString:@"\r   0123456789"];
    return s;
}

-(NSString *) serialize
{
    NSMutableString *s = [NSMutableString stringWithCapacity:elementCount];
    
    for (Tile *t in grid)
    {
        [s appendString:t.letter];
    }
    return s;
}

-(void) deserializeCurrentRound:(Answer *) ans
{
    [grid removeAllObjects];
        
    _gridSize = ans.gridSize;
    elementCount = _gridSize.width * _gridSize.height;
    
    NSString *testString = ans.gridLetters;
    int index = 0;
    for (int i = 0; i < elementCount; i++)
    {
        NSString *s = [testString substringWithRange:NSMakeRange(index++, 1)];
        Tile *t;
        if(s == @" ")
        {
            t = [Tile emptyTile];
        }
        else
        {
            t = [[Tile alloc] initWithLetter:s];
        }
        
        t.currentIndex = [self getPointFromIndex:i];
        [grid addObject:t];
    }      
}

@end















