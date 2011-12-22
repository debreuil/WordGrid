#import <Foundation/Foundation.h>
#import "TileGrid.h"

@interface LevelEditorGrid : TileGrid
{  
    NSString *answer;
}

- (NSMutableArray *) getValidNextInsertionIndexes:(int) index;
- (void) logGridLetters;

@end
