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

@property (nonatomic, weak) Grid *tileGrid;
@property (nonatomic, strong) NSMutableArray *tileViews;

@property (nonatomic) int margin;
@property (nonatomic) int lastHoverTileIndex;
@property (nonatomic) float tileWidth;
@property (nonatomic) float tileHeight;
@property (nonatomic) float slotWidth;
@property (nonatomic) float slotHeight;
@property (nonatomic) float animationDelay;

- (void)    createGrid;
- (void)    layoutGrid:(Boolean) useAnimation;

- (void)    subviewDidAppear;
- (void)    subviewDidDisappear;
- (void)    hoverTileAtPoint:(CGPoint) point;
- (void)    clearAllHovers;
- (int)     getTileIndexFromMousePoint:(CGPoint) point;
- (void)    onSelectTile:(NSNotification *)notification;
- (void)    resetAnimationDelay:(int) delay;



@end
