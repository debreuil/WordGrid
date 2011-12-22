#import <UIKit/UIKit.h>
#import "Tile.h"
#import "TileGrid.h"
#import "AnswerGrid.h"

@interface GameVC : UIViewController
{
    IBOutlet UIButton *btDone;
    IBOutlet UIView *bkgH;
    IBOutlet UIView *bkgV;
    IBOutlet AnswerGrid *answerGrid;
    IBOutlet TileGrid *tileGrid;
    
    //Tile  IBOutlet *letter0;
    //Tile IBOutlet *letter1;
    //Tile IBOutlet *letter2;
    //Tile IBOutlet *letter3;    
    //NSArray* answerTiles;
    //NSArray* answerFrames;
    
    NSMutableArray* answerRefs;
    //int answerIndex;
    int lastSelectedTileIndex;
}

- (void) tileSelected:(Tile *) t;
- (void) answerSelected:(NSNotification *)notification;
- (void) setOrientation;
- (void) testWordComplete;
- (IBAction)onDone:(id)sender;

@end
