#import <UIKit/UIKit.h>
#import "GridProtocol.h"

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
- (void)    insertTile:(Tile *)tile At:(int) index;
- (void)    checkForVerticalGaps;
- (void)    setSelectableAroundIndex:(int) index;

@end
