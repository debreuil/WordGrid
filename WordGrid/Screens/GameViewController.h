//
//  GameViewController.h
//  WordGrid
//
//  Created by admin on 12-10-14.
//
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@class Round;
@class GridView;
@class AnswerView;
@class Tile;

@interface GameViewController : UIViewController

@property (strong, nonatomic) IBOutlet GridView *gridView;
@property (strong, nonatomic) IBOutlet AnswerView *answerView;
@property (strong, nonatomic) IBOutlet UIButton *btReset;
@property (strong, nonatomic) IBOutlet UIButton *btMenu;


- (void) tileSelected:(Tile *) t;
- (void) onTileSelected:(Tile *)t;
- (void) answerSelected:(NSNotification *)notification;
- (void) testWordComplete;

@end
