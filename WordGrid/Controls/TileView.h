
#import "IntGeometry.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>

@class Tile;

@interface TileView : UIView

@property (nonatomic, readonly) Tile *tile;
@property (nonatomic) CGRect animatingFrom;
@property (nonatomic) Boolean isHovering;

@property (nonatomic) IntPoint currentIndex;

@property (nonatomic) BOOL isSelectable;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) BOOL isHidden;
@property (nonatomic) BOOL isOffScreen;


-(id) initWithFrame:(CGRect)frame andTile:(Tile *) tile;

@end
