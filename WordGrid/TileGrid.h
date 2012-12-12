#import <UIKit/UIKit.h>
#import "Tile.h"
#import "TileGridView.h"

@interface TileGrid : NSObject 

@property (nonatomic, strong) TileGridView *tileGridView;
@property (nonatomic, strong) NSMutableArray *tiles;
@property (nonatomic, strong) NSMutableArray *gapsInserted;
@property (nonatomic) int gridWidth;
@property (nonatomic) int gridHeight;

- (void)    setup;
- (void)    createGrid;
- (void)    createLetters;
- (void)    resetGrid;

- (Tile *)  insertTile:(Tile *)tile At:(int) index;
- (void)    removeWord:(NSArray *) indexes;
- (void)    removeTile:(int) index;

- (Tile *)  getTileFromPoint:(CGPoint) p;
- (CGPoint) getPointFromIndex:(int)index;
- (Tile *)  getTileAtIndex:(int) index;

- (void)    removeVerticalGaps;
- (void)    insertLastVerticalGaps;

- (void)    didAppear;
- (void)    didDisappear;

- (NSString *) serializeGridLetters;




@end
