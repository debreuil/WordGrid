//
//  TileGridView.h
//  WordGrid
//
//  Created by admin on 12-12-01.
//
//

#import <Foundation/Foundation.h>

@class Round;
@class Grid;
@class Tile;

#define MAX_ROWS 5

@interface GridView : UIView

@property (nonatomic, weak) Round *round;
@property (nonatomic, weak) Grid *grid;
@property (nonatomic, strong) NSMutableArray *tileViews;

@property (nonatomic) int   margin;
@property (nonatomic) int   lastHoverTileIndex;
@property (nonatomic) float tileWidth;
@property (nonatomic) float tileHeight;
@property (nonatomic) float slotWidth;
@property (nonatomic) float slotHeight;
@property (nonatomic) float animationDelay;
@property (nonatomic) float maxRows;

- (void)    clearAllHovers;

- (Tile *)  getTileFromMousePoint:(CGPoint) point centerOnly:(BOOL) centerOnly;
- (int)     getTileIndexFromMousePoint:(CGPoint) point centerOnly:(BOOL) centerOnly;
- (int)     hoverTileAtPoint:(CGPoint) p centerOnly:(BOOL) centerOnly;
- (CGPoint)  getCenterFromTile:(Tile *) tile;

- (void)    resetAnimationDelay:(int) delay;
- (void)    layoutGrid:(Boolean) useAnimation;
- (void)    finishMultiTileDrag;


@end
