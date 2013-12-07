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


- (CGPoint) getPointFromIndex:(int)index;
- (void) removeTile:(Tile *) t;
- (void) removeVerticalGaps:(TileWord *) word;
- (void) insertVerticalGaps:(TileWord *) word;
- (void) swapColumns:(int)src toColumn:(int)dest;
- (void) setTile:(id) t atPoint:(CGPoint)pt;
- (void) clearAllSelections;

@end


@implementation Grid

@synthesize gridSize = _gridSize;

- (id)init
{
    self = [super init];
    if(self)
    {
        _gridSize = CGSizeMake(8, 7); // default
        
        grid = [[NSMutableArray alloc] initWithCapacity:127];
        selectedLetters = [[NSMutableArray alloc] initWithCapacity:30];
    }
    return self;
}

-(int) getIndexFromPoint:(CGPoint)pt
{
    int result = -1;    
    if(pt.x >= 0 && pt.x < _gridSize.width && pt.y >= 0 && pt.y < _gridSize.height)
    {
        result = pt.y * self.gridSize.width + pt.x;
    }
    return result;
}

-(Tile *) getTileFromPoint:(CGPoint)pt
{
    Tile *t = nil;
    if(pt.x >= 0 && pt.x < _gridSize.width && pt.y >= 0 && pt.y < _gridSize.height)
    {
        int index = pt.y * self.gridSize.width + pt.x;
        t = [grid objectAtIndex:index];
    }
    return t;
}
-(void) setTile:(id) t atPoint:(CGPoint)pt
{
    if(pt.x >= 0 && pt.x < _gridSize.width && pt.y >= 0 && pt.y < _gridSize.height)
    {
        [grid setObject:t atIndexedSubscript:pt.y * self.gridSize.width + pt.x];
    }
}

-(Tile *) getTileFromIndex:(int)index
{
    Tile *t = nil;
    if(index >= 0 && index < grid.count)
    {
        t = [grid objectAtIndex:index];
    }
    return t;
}

- (int) getIndexFromTile:(Tile *)tile
{
    return tile.currentIndex.x + tile.currentIndex.y * self.gridSize.width;
}

-(Tile *) getTileFromBoxedIndex:(NSNumber *)boxedIndex
{
    Tile *t = nil;
    int index = [boxedIndex intValue];
    if(index >= 0 && index < grid.count)
    {
        t = [grid objectAtIndex:index];
    }
    return t;
}
-(CGPoint) getPointFromIndex:(int)index
{
    return CGPointMake(floor(index % (int)self.gridSize.width), floor(index / (int)self.gridSize.width));
}

-(NSString *) getLetterFromIndex:(int)index
{
    Tile *t = [self getTileFromIndex:index];
    return (t == nil) ? @"" : t.letter;
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
    t.isHidden = YES;
    t.isSelected = NO;
    t.isSelectable = NO;
    
    int index = [self getIndexFromPoint:t.currentIndex];
    [grid replaceObjectAtIndex:index withObject:[NSNull null]];
    
    for (int i = t.currentIndex.y - 1; i >= 0; i--)
    {
        int newIndex = [self getIndexFromPoint:CGPointMake(t.currentIndex.x, i)];
        Tile *stackedTile = [grid objectAtIndex:newIndex];
        if(stackedTile != (id)[NSNull null])
        {
            [grid replaceObjectAtIndex:newIndex withObject:[NSNull null]];
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
    t.isHidden = NO;
    t.isSelected = NO;
    t.isSelectable = NO;
    
    int index = [self getIndexFromPoint:t.currentIndex];
    Tile * oldTile = [grid objectAtIndex:index];
    [grid replaceObjectAtIndex:index withObject:t];
    
    Tile *temp;
    for (int i = t.currentIndex.y - 1; i >= 0; i--)
    {
        if(oldTile != (id)[NSNull null] && !oldTile.isHidden)//todo:check
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
        if(t == (id)[NSNull null]) continue;
        
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
        
        if(t == (id)[NSNull null]) continue;
                
        [self insertTile:t];
    }
    //NSLog(@"\n***full\n%@",  [self getGridTrace]);
}

-(void) clearAllSelections
{
    for(Tile *t in grid)
    {
        if(t != (id)[NSNull null])
        {
            t.isSelected = NO;
        }
    }
}

-(void) setAllIsSelectable:(Boolean) isSelectable
{
    for (Tile *t in grid)
    {
        if(t == (id)[NSNull null]) continue;
        
        t.isSelectable = isSelectable;
    }
}

- (void) setSelectableByLetter:(NSString *)let
{
    [self clearAllSelections];
    
    for (Tile *t in grid)
    {
        if(t == (id)[NSNull null]) continue;
        
        t.isSelectable = [t.letter isEqualToString:let];
    }
}

-(void) setSelectableAroundPoint:(CGPoint) point
{
    [self setAllIsSelectable:NO];
    
    for (int i = point.x - 1; i <= point.x + 1; i++)
    {
        for (int j = point.y - 1; j <= point.y + 1; j++)
        {
            Tile *t = [self getTileFromPoint:CGPointMake(i, j)];
            if(t != (id)[NSNull null] && !t.isSelected)
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
        if(t != (id)[NSNull null] && !t.isHidden) // todo:check
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
        if(t == (id)[NSNull null])
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
    //NSLog(@"\n%@ ff: %d\n%@", word.gaps, firstFilled, [self trace]);
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
        //NSLog(@"%@ \n%@", revGaps, [self getGridTrace]);
    }
    else
    {        
        //NSLog(@"No Gaps \n%@",  [self getGridTrace]);
    }
    
    [word.gaps removeAllObjects];
}

- (void) swapColumns:(int)src toColumn:(int)dest
{
    for (int j = 0; j < self.gridSize.height; j++)
    {
        CGPoint srcPt = CGPointMake(src, j);
        CGPoint destPt = CGPointMake(dest, j);
        id srcTile = [self getTileFromPoint:srcPt];
        id destTile = [self getTileFromPoint:destPt];
        [self setTile:srcTile atPoint:destPt];        
        [self setTile:destTile atPoint:srcPt];
        
        if(srcTile != (id)[NSNull null])
        {
            ((Tile *)srcTile).currentIndex = destPt;
        }
        
        if(destTile != (id)[NSNull null])
        {
            ((Tile *)destTile).currentIndex = srcPt;
        }
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
            [s appendString:[NSString stringWithFormat:@"\n% 1d|", (int)(count / self.gridSize.width)]];
        }
        
        if(t == (id)[NSNull null])
        {
            [s appendString:@" "];
        }
        else
        {
            [s appendString:t.letter];
        }
    }
    [s appendString:@"\n   ----------"];
    [s appendString:@"\n   0123456789"];
    return s;
}

-(NSString *) serialize
{
    NSMutableString *s = [NSMutableString stringWithCapacity:elementCount];
    
    for (Tile *t in grid)
    {
        if(t == (id)[NSNull null])
        {
            [s appendString:@" "];
        }
        else
        {
            [s appendString:t.letter];
        }
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
         
        if(![s isEqualToString:@" "]) //YES)
        {
            Tile *t = [[Tile alloc] initWithLetter:s];
            t.currentIndex = [self getPointFromIndex:i];
            [grid addObject:t];
        }
        else
        {
            [grid addObject:[NSNull null]];
        }        
    }      
}

-(void) createSelectionGrid:(int)count
{
    [grid removeAllObjects];
    int len = _gridSize.width * _gridSize.height;
    
    for (int i = 0; i < len; i++)
    {
        NSString *s = [NSString stringWithFormat:@"%d", i + 1];
        
        if(i < count)
        {
            Tile *t = [[Tile alloc] initWithLetter:s];
            t.currentIndex = [self getPointFromIndex:i];
            [grid addObject:t];
        }
        else
        {
            [grid addObject:[NSNull null]];
        }
    }
}

@end















