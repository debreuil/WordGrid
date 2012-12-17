
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>

@class Tile;

@interface TileView : UIView

@property (nonatomic, readonly) Tile *tile;
@property (nonatomic) CGRect animatingFrom;
@property (nonatomic) Boolean isHovering;
@property (nonatomic) BOOL  isEmptyHidden;

@property (nonatomic) CGPoint currentIndex;
@property (nonatomic) Boolean isSelectable;
@property (nonatomic) Boolean isSelected;

-(id) initWithFrame:(CGRect)frame andTile:(Tile *) tile;

@end
