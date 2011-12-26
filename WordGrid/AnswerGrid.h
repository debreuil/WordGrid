#import <UIKit/UIKit.h>
#import "TileGrid.h"
#import "Tile.h"

@interface AnswerGrid : TileGrid 
{  
    NSString *answer;
    NSArray *answerWords;
}

- (int)         getAnswerIndex;
- (int)         getWordStartIndex:(int)index;
- (int)         getCurrentWordStart;
- (NSString *)   getCurrentLetter;
- (NSString *)   getCurrentCorrectLetter;
- (Tile *)      removeCurrentTile;
- (Tile *)      getNextTile;
- (void)        setNextTileUsingTile:(Tile *)srcTile;
- (BOOL)        atWordBoundry;
- (void)        showFirstLetterHints;
- (void)        showVowelHints;
- (Boolean)      testCurrentWordCorrect;
- (Boolean)      didWin;

@end
