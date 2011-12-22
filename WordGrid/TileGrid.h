#import <UIKit/UIKit.h>
#import "GridProtocol.h"
#import "Tile.h"

@interface TileGrid : UIView <GridProtocol>
{    
    int gw;
    int gh;
    int margin;
    float slotWidth;
    float slotHeight;
    NSMutableArray *tiles;
    UIInterfaceOrientation io;
    int lastHoverTileIndex;
    float animationDelay;
    Boolean hasGap;
}

- (void)    setup;
- (void)    createLetters;
- (void)    clearAllHovers;
- (Tile *)    insertTile:(Tile *)tile At:(int) index;
- (void)    checkForVerticalGaps;
- (CGPoint)  getPointFromIndex:(int)index;
- (void)    setSelectableAroundIndex:(int) index;
- (void)    onSelectTile:(Tile *) tile;
- (Tile *)  getTileAtIndex:(int) index;

@end
