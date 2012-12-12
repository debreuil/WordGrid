
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>

@class Tile;

@interface TileView : UIView

@property (nonatomic, readonly) Tile *tile;
@property (nonatomic) CGRect animatingFrom;
@property (nonatomic) Boolean isHovering;

-(id) initWithFrame:(CGRect)frame andTile:(Tile *) tile;

@end
