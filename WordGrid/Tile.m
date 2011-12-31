#import "Tile.h"

@implementation Tile

static NSArray *imageStates;
static UIImage *errorImage;
static float hoverScale = 1.5;
static SystemSoundID tickSoundID;

@synthesize gridIndex;
@synthesize originalIndex;
@synthesize letter;
@synthesize correctLetter;
@synthesize isHovering;
@synthesize errorMarkVisible;
@synthesize selected;
@synthesize isSelectable;
@synthesize letterShowing;
@synthesize animatingFrom;
@synthesize resultIndex;
@synthesize isResultTile;

NSString * const LETTERS = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";


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

- (id)init
{
    CGRect f = CGRectMake(0, 0, image.size.width, image.size.height);
    self = [self initWithFrame:f]; 
    
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame]; 
    if(self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder 
{
    self = [super initWithCoder:coder];
    if (self) 
    {
        [self setup];
    }
    return self;
}

- (void) setup
{    
    image = [imageStates objectAtIndex:0];
    letter = @""; 
    isSelectable = YES;
    isResultTile = NO;
    resultIndex = -1;
    
    animatingFrom = CGRectNull;
    
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

- (Boolean) isCorrectLetter
{
    return [letter isEqualToString:correctLetter];
}

- (void) setLetter:(NSString *) let
{
    if(let != letter)
    {
        letter = let;            
        [self setNeedsDisplay];
    }
}

- (void) setLetterShowing:(Boolean)isLetterShowing
{
    if(isLetterShowing != letterShowing)
    {
        letterShowing = isLetterShowing;            
        [self setNeedsDisplay];
    }
}

- (void)setIsSelectable:(Boolean) selectable
{    
    if(selectable != isSelectable)
    {
        isSelectable = selectable;
        [self setNeedsDisplay];
    }
}

- (void)setSelected:(Boolean) sel
{
    selected = sel;
    if(sel)
    {
        image = [imageStates objectAtIndex:3];
    }
    else
    {
        image = [imageStates objectAtIndex:0];        
    }
    [self setNeedsDisplay];
}

- (void)setIsHovering:(Boolean) hover
{
    if(hover && !isHovering)
    {
        isHovering = YES;
        
        [UIView  
            animateWithDuration:0.07
            delay:0.0
            options: UIViewAnimationCurveEaseOut
            animations:^
            {
                self.bounds = scaleUpRect;
            } 
            completion:nil
         ];
    }
    else if(!hover && isHovering)
    {
        isHovering = NO;
        
        [UIView  
             animateWithDuration:0.05
             delay:0.0
             options: UIViewAnimationCurveEaseOut
             animations:^
             {
                 self.bounds = scaleNormalRect;
             } 
             completion:nil
         ];  
    }
}

- (void) setErrorMarkVisible:(Boolean) isVisible
{
    errorMarkVisible = isVisible;
    [self setNeedsDisplay];
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
    
    if(letterShowing && letter == @"")
    {
        [correctLetter drawInRect:r withFont:f lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    }
    else
    {
        [letter drawInRect:r withFont:f lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    }
    
    if(isSelectable)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 4);
        CGContextSetRGBStrokeColor(context, 0.2, 0.5, 1.0, 1);
        CGContextStrokeRect(context, [self bounds]);
    }   

}


- (NSComparisonResult) compareOriginalIndex: (Tile *) t
{
    NSComparisonResult result;
    
    if (self.originalIndex == t.originalIndex)
    {
        result = NSOrderedSame;
    }
    else if(t.originalIndex < self.originalIndex)
    {
        result = NSOrderedAscending;
    }
    else
    {
        result = NSOrderedDescending;
    }
    
    return result;
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
    if([self isSelectable])
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
