//
//  DesignGrid.m
//  WordGrid
//
//  Created by admin on 2013-09-16.
//
//

#import "DesignGrid.h"
#import "Tile.h"
#import "TileWord.h"
#import "Answer.h"
#import "GridView.h"

@implementation DesignGrid


-(void) createEmptyGrid
{
    [grid removeAllObjects];
    
    self.gridSize = CGSizeMake(8, MAX_ROWS);
    elementCount = self.gridSize.width * self.gridSize.height;
    
    for (int i = 0; i < elementCount; i++)
    {
        Tile *t = [[Tile alloc] initWithLetter:@" "];
        t.currentIndex = [self getPointFromIndex:i];
        [grid addObject:t];
    }
}

@end
