#import "Tile.h"

@interface Tile()
- (void) onChange;
@end

@implementation Tile

@synthesize letter = _letter;
@synthesize gridIndex = _gridIndex;
@synthesize originalIndex = _originalIndex;
@synthesize resultIndex = _resultIndex;
@synthesize isResultTile = _isResultTile;


NSString * const LETTERS = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";

- (id) init
{    
    self = [super init];
    if(self)
    {
        _isSelectable = YES;
        _isResultTile = NO;
        _resultIndex = -1;
    }
    return self;
}

- (void) setLetterShowing:(Boolean)isLetterShowing
{
    if(isLetterShowing != self.letterShowing)
    {
        self.letterShowing = isLetterShowing;
        [self.tileView setNeedsDisplay];
    }
}

- (void)setIsSelectable:(Boolean) selectable
{
    if(selectable != self.isSelectable)
    {
        self.isSelectable = selectable;
        [self setNeedsDisplay];
    }
}

- (void)setSelected:(Boolean) sel
{
    self.selected = sel;
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
    if(hover && !self.isHovering)
    {
        self.isHovering = YES;
        
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
    else if(!hover && self.isHovering)
    {
        self.isHovering = NO;
        
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
    self.errorMarkVisible = isVisible;
    [self setNeedsDisplay];
}

- (void) setLetter:(NSString *) let
{
    if(let != self.letter)
    {
        self.letter = let;            
        [self onChange];
    }
}

- (void) onChange
{
}

- (Boolean) isCorrectLetter
{
    return [self.letter isEqualToString:self.correctLetter];
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


@end
