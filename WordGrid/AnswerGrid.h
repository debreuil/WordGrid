#import <UIKit/UIKit.h>
#import "TileGrid.h"

@interface AnswerGrid : TileGrid 
{  
    NSString *answer;
    NSArray *answerWords;
}

- (Tile *)  getNextTile;
- (void)    setNextTileUsingTile:(Tile *)srcTile;
- (BOOL)    atWordBoundry;
@end
