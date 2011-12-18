#import <UIKit/UIKit.h>

@interface Tile : UIView
{
    UIImage *image;
    NSString *letter;
    Boolean isHovering;
    Boolean selected;
    Boolean isSelectable;
    int gridIndex;
    CGRect animatingFrom;
}

@property int gridIndex;
@property (nonatomic, retain) NSString *letter;
@property (nonatomic) Boolean isHovering;
@property (nonatomic) Boolean selected;
@property (nonatomic) Boolean isSelectable;
@property (nonatomic) CGRect animatingFrom;

- (void)setup;

@end
