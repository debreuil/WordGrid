//
//  TileGridView.h
//  WordGrid
//
//  Created by admin on 12-12-01.
//
//

#import <Foundation/Foundation.h>

@class Grid;
@class Tile;

@interface GridView : UIView

@property (nonatomic, weak) Grid *grid;
@property (nonatomic, strong) NSMutableArray *tileViews;

@property (nonatomic) int   margin;
@property (nonatomic) int   lastHoverTileIndex;
@property (nonatomic) float tileWidth;
@property (nonatomic) float tileHeight;
@property (nonatomic) float slotWidth;
@property (nonatomic) float slotHeight;
@property (nonatomic) float animationDelay;
@property (nonatomic) BOOL  isEmptyHidden;

- (void)    hoverTileAtPoint:(CGPoint) point;
- (void)    clearAllHovers;
- (Tile *)  getTileFromMousePoint:(CGPoint) point;
- (int)     getTileIndexFromMousePoint:(CGPoint) point;
- (void)    resetAnimationDelay:(int) delay;
- (void)    layoutGrid:(Boolean) useAnimation;



@end
