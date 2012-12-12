
#import <Foundation/Foundation.h>

@class Tile;

@interface TileWord : NSObject

@property (nonatomic, readonly) NSMutableArray *tiles;
@property (nonatomic) NSMutableArray *gaps;
@property (nonatomic, readonly) int guessedLetterCount;

-(id) initWithAnswer:(NSString *) answer;
//-(id) initWithTiles:(NSArray *) tiles;

-(void) addTile:(Tile *) tile;
-(void) addTiles:(NSArray *) tiles;
-(void) removeLastTile;
-(void) reset;

-(NSString *) getGuessedWord;
-(Boolean) isFullyGuessed;
-(Boolean) isCorrectlyGuessed;

-(NSArray *) getTilesSortedFromBottomRight;

@end
