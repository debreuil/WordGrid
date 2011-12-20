#import <UIKit/UIKit.h>

extern NSString * const LETTERS;

@interface Tile : UIView
{
    UIImage *image;
    NSString *letter;
    NSString *correctLetter;
    Boolean isHovering;
    Boolean selected;
    Boolean isSelectable;
    int gridIndex;
    CGRect animatingFrom;
    int resultIndex;
    Boolean isResultTile;
    CGRect scaleNormalRect;
    CGRect scaleUpRect;
    int originalIndex;

}

@property int gridIndex;
@property int originalIndex;
@property (nonatomic, retain) NSString *letter;
@property (nonatomic, retain) NSString *correctLetter;
@property (nonatomic) Boolean isHovering;
@property (nonatomic) Boolean selected;
@property (nonatomic) Boolean isSelectable;
@property (nonatomic) CGRect animatingFrom;
@property int resultIndex;
@property (nonatomic) Boolean isResultTile;

- (void)setup;

@end
