#import <UIKit/UIKit.h>

@interface TileGrid : UIView
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

- (void)    createGrid;
- (void)    createLetters;
- (void)    layoutGrid:(Boolean) useAnimation;
- (void)    resetGrid;
- (int)     getTileIndexFromMousePoint:(CGPoint) point;
- (Tile *)  getTileFromPoint:(CGPoint) p;
- (void)    hoverTileAtPoint:(CGPoint) point;
- (void)    removeTilesAndDrop:(NSArray *) indexes;
- (void)    removeTile:(int) index;
- (void)    checkForVerticalGaps;

-(void)     setAllIsSelectable:(Boolean) sel;
-(void)     setSelectableAroundIndex:(int) index;

@end
