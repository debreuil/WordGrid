
#import "Answer.h"

@implementation Answer

static NSRegularExpression *letRegex;
static NSCharacterSet *nonLetterSet;
static NSCharacterSet *nonLetterSpaceSet;
+ (void)initialize
{
    NSError *regexError;
    letRegex = [NSRegularExpression regularExpressionWithPattern:@"\\w"
               options:NSRegularExpressionCaseInsensitive error:&regexError];
    
    nonLetterSet = [[NSCharacterSet letterCharacterSet]invertedSet];    
    NSMutableCharacterSet *letterSpaceSet = [NSMutableCharacterSet characterSetWithCharactersInString:@" "];
    [letterSpaceSet formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
    
    nonLetterSpaceSet = [letterSpaceSet invertedSet];
}

@synthesize gridSize = _gridSize;
@synthesize quote = _quote;
@synthesize quoteUnderscores = _quoteUnderscores;
@synthesize quoteLettersOnly = _quoteLettersOnly;
@synthesize quoteWords = _quoteWords;
@synthesize gridLetters = _gridLetters;
@synthesize keys = _keys;
@synthesize keyWordArrays = _keyWordArrays;
@synthesize letterPositionsInQuote = _letterPositionsInQuote;
@synthesize victoryBlurb = _victoryBlurb;

-(id) initWithData:(NSArray *) quoteData
{
    self = [super init];
    if(self)
    {
        [self parseData:quoteData];
    }
    return self;
}

- (void) parseData:(NSArray *)quoteData
{
    //        @"FIND ALL THE WORDS.",
    //        @"                                       WO R     THFIND   ALLEDS",
    //        @"GOOD JOB!",
    //        @"50,51,52,53,57,58,59,58,59,60,58,59,60,61,62",
    //        @"{9,7}", nil
    _quote = [quoteData objectAtIndex:0];
    _gridLetters = [quoteData objectAtIndex:1];
    _victoryBlurb = [quoteData objectAtIndex:2];
    _gridSize = CGSizeFromString([quoteData objectAtIndex:4]);
    
    NSString *quoteUpper = [_quote uppercaseString];
        
    _quoteUnderscores = [letRegex stringByReplacingMatchesInString:_quote
                              options:0 range:NSMakeRange(0, _quote.length) withTemplate:@"□"];
    
    
    _quoteLettersOnly = [[quoteUpper componentsSeparatedByCharactersInSet:nonLetterSet]componentsJoinedByString:@""];
    NSString *wordsWithSpaces = [[quoteUpper componentsSeparatedByCharactersInSet:nonLetterSpaceSet]componentsJoinedByString:@""];
    _quoteWords = [wordsWithSpaces componentsSeparatedByString:@" "];
    
    // answerKeys
    NSString *s = [quoteData objectAtIndex:3];
    NSArray *sInts = [s componentsSeparatedByString:@","];
    int count = sInts.count;
    id nums[count];    
    for (int i = 0; i < count; i++)
    {
        int num = [[sInts objectAtIndex:i] intValue];
        nums[i] = [NSNumber numberWithInt:num];
    }    
    _keys = [NSArray arrayWithObjects:nums count:count];
    
    id kws[_quoteWords.count];
    int start = 0;
    int i = 0;
    for (NSString *s in _quoteWords)
    {
        NSRange range = NSMakeRange(start, s.length);
        kws[i] = [_keys subarrayWithRange:range];
        start += s.length;
        i++;
    }
    _keyWordArrays = [NSArray arrayWithObjects:kws count:_quoteWords.count];
    
    // note: obj c doesn't allow '‿' as a character
    NSString *us = [letRegex stringByReplacingMatchesInString:_quote
                    options:0 range:NSMakeRange(0, _quote.length) withTemplate:@"|"];
    NSMutableArray *positions = [[NSMutableArray alloc]initWithCapacity:us.length];
    for(int i = 0; i < _quoteUnderscores.length; i++)
    {
        if([us characterAtIndex:i] == '|')
        {
            [positions addObject:[NSNumber numberWithInt:i]];
        }
    }    
    _letterPositionsInQuote = [NSArray arrayWithArray:positions];
    
    //NSLog(@"_answerKeyWords: %@", _keyWordArrays);
}



@end
