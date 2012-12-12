#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Game.h"
#import "Tile.h"

@interface GameVC : UIViewController
{
    IBOutlet Game *game;
    
    IBOutlet UIButton *btDone;
    IBOutlet UIView *bkg;    
    IBOutlet UIView *victory;
    IBOutlet UILabel *txVictory;
           
    NSMutableArray* answerRefs;
    int lastSelectedTileIndex;
}

+ (GameVC *) getCurrentGame;

- (void) nextRound;
- (void) setOrientation;

- (void) tileSelected:(Tile *) t;
- (void) onTileSelected:(Tile *)t;
- (void) answerSelected:(NSNotification *)notification;
- (void) testWordComplete;
- (IBAction)onDone:(id)sender;

@end
