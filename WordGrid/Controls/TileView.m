//
//  TileView.m
//  WordGrid
//
//  Created by admin on 12-12-01.
//
//

#import "TileView.h"
#import "Tile.h"

@interface TileView()
{
    UIImage *image;
    CGRect scaleNormalRect;
    CGRect scaleUpRect;
    Boolean errorMarkVisible;
}

@property (nonatomic, weak) Tile *tile;

@end

@implementation TileView

@synthesize tile = _tile;
@synthesize animatingFrom = _animatingFrom;
@synthesize isHovering = _isHovering;

static NSArray *imageStates;
static UIImage *errorImage;
static float hoverScale = 1.5;
static SystemSoundID tickSoundID;

- (id) initWithFrame:(CGRect)frame andTile:(Tile *) t
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.tile = t;
        [self setup];
    }
    return self;
}


- (void) setup
{
    image = [imageStates objectAtIndex:0];
    self.animatingFrom = CGRectNull;
    
    CGRect f = [self frame];
    float xBorder = ((f.size.width * hoverScale) - f.size.width) / 2.0;
    float yBorder = ((f.size.height * hoverScale) - f.size.height) / 2.0;
    scaleNormalRect = f;
    scaleUpRect = CGRectMake(
                             f.origin.x - xBorder,
                             f.origin.y - yBorder,
                             f.size.width + xBorder * 2,
                             f.size.height + yBorder * 2);
}


+ (void) load
{
    errorImage = [UIImage imageNamed:@"errorTile.png"];
    
    imageStates = [[NSArray alloc] initWithObjects:
                   [UIImage imageNamed:@"let_norm.png"],
                   [UIImage imageNamed:@"let_sel0.png"],
                   [UIImage imageNamed:@"let_sel1.png"],
                   [UIImage imageNamed:@"let_sel2.png"], nil];
    
    NSURL *tickURLRef = [[NSBundle mainBundle] URLForResource:@"smallTick" withExtension:@"caf"];
    AudioServicesCreateSystemSoundID ( (__bridge CFURLRef) tickURLRef, &tickSoundID);
}

- (void)drawRect:(CGRect)rect
{
	//[image drawAtPoint:(CGPointMake(0.0f, 0.0f))];
    [image drawInRect:[self bounds]];
    
    if(errorMarkVisible)
    {
        [errorImage drawInRect:[self bounds]];
    }
    
    float sc = self.bounds.size.width / 48.0;
    
    [[UIColor whiteColor] set];
    UIFont *f = [UIFont fontWithName:@"VTC Letterer Pro" size:(48.0 * sc)];
    CGRect r = CGRectOffset([self bounds], 0.0,(2.0 * sc));
    
    if(![self.tile isEmptyTile] && self.tile.letter == @"")
    {
        [self.tile.letter drawInRect:r
                                 withFont:f
                                 lineBreakMode:UILineBreakModeClip
                                 alignment:UITextAlignmentCenter];
    }
    else
    {
        [self.tile.letter drawInRect:r withFont:f lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    }
    
    if(self.tile.isSelectable)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 4);
        CGContextSetRGBStrokeColor(context, 0.2, 0.5, 1.0, 1);
        CGContextStrokeRect(context, [self bounds]);
    }
    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    //NSLog(@"%i", gridIndex);
    if(self.tile.isSelectable)
    {
        AudioServicesPlaySystemSound(tickSoundID);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"onTileSelected" object:self];
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

@end
