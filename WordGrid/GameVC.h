#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
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
    
    IBOutlet UIView *victoryH;
    IBOutlet UIView *victoryV;
    IBOutlet UILabel *txVictory;
           
    NSMutableArray* answerRefs;
    int lastSelectedTileIndex;
}

+ (GameVC *) getCurrentGame;
- (AnswerGrid *) getAnswerGrid;
- (void) nextRound;
- (void) tileSelected:(Tile *) t;
- (void) answerSelected:(NSNotification *)notification;
- (void) setOrientation;
- (void) testWordComplete;
- (IBAction)onDone:(id)sender;

@end
