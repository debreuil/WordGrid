
#import "Letter.h"

extern NSString * const LETTERS;

@interface Tile : NSObject

@property (nonatomic, readonly) NSString *letter;
@property (nonatomic, readonly) NSString *correctLetter;

@property (nonatomic) Boolean hidden;
@property (nonatomic) int gridIndex;
@property (nonatomic) int resultIndex;
@property (nonatomic) Boolean letterShowing;

@property (nonatomic) int originalIndex;
@property (nonatomic) Boolean isResultTile;

@property (nonatomic) Boolean selected;
@property (nonatomic) Boolean isSelectable;


- (Boolean) isCorrectLetter;
- (NSComparisonResult) compareOriginalIndex: (Tile *) t;

@end
