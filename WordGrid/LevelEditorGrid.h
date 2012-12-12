#import <Foundation/Foundation.h>
#import "TileGrid.h"
#import "AnswerGrid.h"

@interface LevelEditorGrid : TileGrid
{  
    NSString *answer;
}

@property (nonatomic, weak) AnswerGrid *answerGrid;

- (NSMutableArray *) getValidNextInsertionIndexes:(int) index;

@end
