//
//  GridOverlay.m
//  WordGrid
//
//  Created by admin on 2013-09-22.
//
//

#import "GridOverlay.h"
#import "Round.h"
#import "Tile.h"
#import "TileView.h"

@implementation GridOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setGridView:(GridView *)gv
{
    _gridView = gv;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if(_gridView != nil)
    {
        NSArray *tiles = [_gridView.round getGuessedTiles];
        if(tiles.count > 0)
        {
            UIBezierPath *aPath = [UIBezierPath bezierPath];
            aPath.lineWidth = 55;
            aPath.lineJoinStyle = kCGLineJoinRound;
            aPath.lineCapStyle = kCGLineCapRound;
            
            Tile *tl = (Tile *)tiles[0];
            [aPath moveToPoint:[_gridView getCenterFromTile:tl]];
            for (Tile *t in tiles)
            {
                CGPoint cp = [_gridView getCenterFromTile:t];
                [aPath addLineToPoint:cp];
            }
            
            [[UIColor colorWithRed:0x10 green:0xD0 blue:0x10 alpha:0.2] setStroke];
            [aPath stroke];
        }
    
    }
}
@end
