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
        _tile = t;
        [self setup];
    }
    return self;
}

-(void) setIsHovering:(Boolean)hovering
{
    if(_isHovering != hovering)
    {
        _isHovering = hovering;
        
        if(_isHovering)
        {        
            [self.superview bringSubviewToFront:self];
            self.bounds = scaleUpRect;
        }
        else
        {
            self.bounds = scaleNormalRect;        
        }
        
        [self setNeedsDisplay];
    }
}

- (void) setup
{
    image = [imageStates objectAtIndex:0];
    self.animatingFrom = CGRectNull;
    _isHovering = NO;
    
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
    self.clipsToBounds = NO;
    
    CGRect r = self.bounds;
    
	//[image drawAtPoint:(CGPointMake(0.0f, 0.0f))];
    [image drawInRect:r];
    
    if(errorMarkVisible)
    {
        [errorImage drawInRect:r];
    }
    
    
    [[UIColor whiteColor] set];
    float sc = r.size.width / 48.0;
    UIFont *f = [UIFont fontWithName:@"VTC Letterer Pro" size:(48.0 * sc)];
    
    CGRect letR = CGRectOffset(r, 0.0, 2.0);
    if(![self.tile isEmptyTile] && self.tile.letter == @"")
    {
        [self.tile.letter drawInRect:letR
                                 withFont:f
                                 lineBreakMode:UILineBreakModeClip
                                 alignment:UITextAlignmentCenter];
    }
    else
    {
        [self.tile.letter drawInRect:letR withFont:f lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    }
    
    if(self.tile.isSelectable)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 4);
        CGContextSetRGBStrokeColor(context, 0.2, 0.5, 1.0, 1);
        CGContextStrokeRect(context, r);
    }    
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    // move hover to grid
    self.isHovering = YES;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.isHovering = NO;
    //NSLog(@"%i", gridIndex);
    if(self.tile.isSelectable)
    {
        AudioServicesPlaySystemSound(tickSoundID);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"onTileSelected" object:self];
    }
    [self setNeedsDisplay];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

@end
