//
//  AnswerView.m
//  WordGrid
//
//  Created by admin on 12-12-09.
//
//

#import "AnswerView.h"
#import "Answer.h"
#import "Round.h"
#import "TileWord.h"

#define margin 20

@interface AnswerView()
{
    NSMutableArray *wordRects;
    UIFont *font;
    CGRect textArea;
    int clearIndexFrom;
}

- (void) calculateWordRects;
- (void) drawCorrect:(CGContextRef) context withRect:(CGRect) r;
- (void) drawIncorrect:(CGContextRef) context withRect:(CGRect) r;
- (void) drawIncomplete:(CGContextRef) context withRect:(CGRect) r;
- (void) strikeOutWord:(CGContextRef) context withRect:(CGRect) r;
- (int) getWordIndexOfPoint:(CGPoint)pt;

@end

@implementation AnswerView

@synthesize round = _round;
@synthesize showErrors = _showErrors;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        wordRects = [[NSMutableArray alloc] initWithCapacity:32];
        font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:42];
        textArea = CGRectMake(margin, 0, self.bounds.size.width - margin * 2, self.bounds.size.height);
    }
    return self;
}

- (void)setRound:(Round *)round
{
    _round = round;
    [self calculateWordRects];
    clearIndexFrom = -1;
    [self setNeedsDisplay];
}
- (void)calculateWordRects
{
    [wordRects removeAllObjects];
    NSArray *lps = self.round.answer.letterPositionsInQuote;
    NSArray *words = _round.answer.quoteWords;
    int row = 0;
    int startSlot = 0;
    float h = 0;    
    int wordIndex = 0;
    
    for(int i = 0; i < lps.count;)
    {
        int wordLen = ((NSString *)[words objectAtIndex:wordIndex]).length;
        int index = [lps[i] intValue] + wordLen;
        NSRange range = NSMakeRange(startSlot, index - startSlot);
        NSString *s = [_round.answer.quote substringWithRange:range];
        CGSize sz = [s sizeWithFont:font constrainedToSize:textArea.size lineBreakMode:UILineBreakModeWordWrap];
        h = (h == 0) ? sz.height : h;
        
        if(sz.height > h) // new line
        {
            row++;
            startSlot = [lps[i] intValue];
            index = startSlot + wordLen;
            range = NSMakeRange(startSlot, index - startSlot);
            s = [_round.answer.quote substringWithRange:range];
            sz = [s sizeWithFont:font constrainedToSize:textArea.size lineBreakMode:UILineBreakModeWordWrap];
        }
        // left location
        range = NSMakeRange(startSlot, index - startSlot - wordLen);
        NSString *ls = [_round.answer.quote substringWithRange:range];
        CGSize leftSize = [ls sizeWithFont:font constrainedToSize:textArea.size lineBreakMode:UILineBreakModeWordWrap];
        int w = (sz.width - leftSize.width) / wordLen;
        i += wordLen;
        wordIndex++;
        CGRect wordRect = CGRectMake(leftSize.width - w / 2.0f + margin, row * h, sz.width - leftSize.width + w, h);
        [wordRects addObject:[NSValue valueWithCGRect:wordRect]];
        
        //NSLog(@"%@ **%@**", NSStringFromCGRect(wordRect), s);
    }
}

- (void)drawRect:(CGRect)rect
{
    if(_round != nil)
    {        
        // draw letters
        [[UIColor whiteColor] set];
        
        NSString *ga = _round.currentFullGuess;
        NSMutableString *s = [_round.answer.quoteUnderscores mutableCopy];
        
        for(int i = 0; i < ga.length; i++)
        {
            int index = [_round.answer.letterPositionsInQuote[i] intValue];
            [s replaceCharactersInRange:NSMakeRange(index, 1)
                             withString:[ga substringWithRange:NSMakeRange(i, 1)]];
        }
        
        [s drawInRect:textArea withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
        
        if(_showErrors)
        {
            // draw bounds
            CGRect r;
            CGContextRef context = UIGraphicsGetCurrentContext();
            for(int i = 0; i < _round.wordIndex; i++)
            {
                r = [wordRects[i] CGRectValue];
                if([_round isWordCorrectlyGuessed:i])
                {
                    [self drawCorrect:context withRect:r];
                }
                else
                {
                    [self drawIncorrect:context withRect:r];
                }
            }
            
            r = [wordRects[_round.wordIndex] CGRectValue];
            [self drawIncomplete:context withRect:r];
            
            
            // strikeout
            if (clearIndexFrom > -1)
            {
                for(int i = _round.wordIndex; i >= clearIndexFrom; i--)
                {
                    r = [wordRects[i] CGRectValue];
                    [self strikeOutWord:context withRect:r];
                }
            }
        }
    }
}

- (void) drawCorrect:(CGContextRef)context withRect:(CGRect) r
{
    CGContextSetLineWidth(context, 1);    
    CGContextSetRGBStrokeColor(context,0.2, 1.0, 0.2, 1); // greenish
    CGContextStrokeRect(context, r);
}

- (void) drawIncorrect:(CGContextRef)context withRect:(CGRect) r
{
    CGContextSetLineWidth(context, 1);
    CGContextSetRGBStrokeColor(context,1.0, 0.2, 0.2, 1); // redish
    CGPoint p1[2] ={    CGPointMake(r.origin.x + 12, r.origin.y),
                        CGPointMake(r.origin.x + r.size.width - 12, r.origin.y + r.size.height)};
    CGContextStrokeLineSegments(context, p1, 2);
    
    CGPoint p2[2] ={    CGPointMake(r.origin.x + 12, r.origin.y + r.size.height),
                        CGPointMake(r.origin.x + r.size.width - 12, r.origin.y),};
    CGContextStrokeLineSegments(context, p2, 2);
}

- (void) drawIncomplete:(CGContextRef)context withRect:(CGRect) r
{
    CGContextSetLineWidth(context, 3);
    CGContextSetRGBStrokeColor(context,1.0, 1.0, 0.5, 1); // yellowish
    
    CGPoint p1[2] ={    CGPointMake(r.origin.x + 12, r.origin.y + r.size.height),
        CGPointMake(r.origin.x + r.size.width - 12, r.origin.y + r.size.height),};
    CGContextStrokeLineSegments(context, p1, 2);
}

- (void) strikeOutWord:(CGContextRef)context withRect:(CGRect) r
{
    CGContextSetLineWidth(context, 4);
    CGContextSetRGBStrokeColor(context,1.0, 0.2, 0.2, 1); // redish
    
    CGPoint p1[2] ={    CGPointMake(r.origin.x, r.origin.y + r.size.height / 2.0f),
        CGPointMake(r.origin.x + r.size.width, r.origin.y + r.size.height / 2.0f),};
    CGContextStrokeLineSegments(context, p1, 2);
}

- (int) getWordIndexOfPoint:(CGPoint)pt
{
    int result = -1;
    for(int i = _round.wordIndex; i >= 0; i--)
    {
        if(CGRectContainsPoint([[wordRects objectAtIndex:i] CGRectValue], pt))
        {
            result = i;
            break;
        }
    }
    return result;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *t = [touches anyObject];
    CGPoint pt = [t locationInView:self];
    clearIndexFrom = [self getWordIndexOfPoint:pt];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *t = [touches anyObject];
    CGPoint pt = [t locationInView:self];
    clearIndexFrom = [self getWordIndexOfPoint:pt];
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if(clearIndexFrom > -1)
    {
        NSDictionary* dict = [NSDictionary dictionaryWithObject:
                                [NSNumber numberWithInt:clearIndexFrom] forKey:@"clearIndexFrom"];
        
        [[NSNotificationCenter defaultCenter]
                                postNotificationName:@"onAnswerWordSelected"
                                object:self
                                userInfo:dict];
    }
    
    clearIndexFrom = -1;
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    clearIndexFrom = -1;
    [self setNeedsDisplay];
}

@end








