#import <UIKit/UIKit.h>
#import "Tile.h"
#import "TileGrid.h"

@interface GameVC : UIViewController
{
    UIButton IBOutlet *btDone;
    UIView IBOutlet *bkgH;
    UIView IBOutlet *bkgV;
    TileGrid IBOutlet *tileGrid;
    Tile  IBOutlet *letter0;
    Tile IBOutlet *letter1;
    Tile IBOutlet *letter2;
    Tile IBOutlet *letter3;
    
    NSArray* answerTiles;
    NSArray* answerFrames;
    NSMutableArray* answerRefs;
    int answerIndex;
    int lastSelectedTileIndex;
}

- (void) tileSelected:(Tile *) t;
- (void) setOrientation;
- (void) testWordComplete;
- (IBAction)onDone:(id)sender;

@end
