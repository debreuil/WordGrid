//
//  Round.m
//  WordGridTests
//
//  Created by admin on 12-12-06.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import "Round.h"
#import "Grid.h"
#import "Answer.h"
#import "TileWord.h"
#import "Tile.h"

@interface Round()
{
    Grid *grid;    
    Answer *answer;    
    
    NSMutableArray *tileWords;
    NSMutableArray *guessedKeys;
}

- (void) resetRound;
@end

@implementation Round

@synthesize letterIndex = _letterIndex;
@synthesize wordIndex = _wordIndex;
@synthesize currentFullGuess = _currentFullGuess;
@synthesize currentWord = _currentWord;

- (id)initWithAnswer:(Answer *)ans
{
    self = [super init];
    if(self)
    {
        answer = ans;
        [self resetRound];
    }
    return self;
}

- (void) resetRound
{
    _letterIndex = 0;
    _wordIndex = 0;
    _currentFullGuess = @"";
        
    grid = [[Grid alloc]init];
    [grid deserializeCurrentRound:answer];
    
    if(tileWords == nil)
    {
        tileWords = [[NSMutableArray alloc] initWithCapacity:answer.quoteWords.count];
    }
    else
    {
        [tileWords removeAllObjects];
    }
    
    if(guessedKeys == nil)
    {
        guessedKeys = [[NSMutableArray alloc] initWithCapacity:answer.quoteLettersOnly.length];
    }
    else
    {
        [guessedKeys removeAllObjects];
    }
    
    if(_currentWord == nil)
    {
        _currentWord = [[TileWord alloc] initWithAnswer:[answer.quoteWords objectAtIndex:_wordIndex]];
    }
    else
    {
        [_currentWord reset];
    }        
}

- (Boolean) guessTile:(int)index
{
    Tile *guessedTile = [grid getTileFromIndex:index];
    [_currentWord addTile:guessedTile];
    [guessedKeys addObject:[NSNumber numberWithInt:index]];
    _currentFullGuess = [_currentFullGuess stringByAppendingString:guessedTile.letter];
    
    NSString *correctLetter = [[answer quoteLettersOnly] substringWithRange:NSMakeRange(_letterIndex, 1)];
    Boolean result = [correctLetter isEqualToString:guessedTile.letter];
    _letterIndex++;
    if([_currentWord isFullyGuessed])
    {
        if([_currentWord isCorrectlyGuessed])
        {
            [self onWordCorrect];
        }
        else
        {
            [self onWordIncorrect];
        }
        
        [tileWords addObject:_currentWord];
        [grid removeWord:_currentWord];
        _wordIndex++;
        
        if(_wordIndex >= answer.quoteWords.count)
        {
            [self onRoundComplete];
        }
        else
        {
            _currentWord = [[TileWord alloc] initWithAnswer:[answer.quoteWords objectAtIndex:_wordIndex]];
        }
    }
    return result;
}
- (void) undoLastWord
{
    if(_currentWord.guessedLetterCount == 0)
    {
        if(_wordIndex > 0)
        {
            _wordIndex--;
            _currentWord = [tileWords objectAtIndex:_wordIndex];
        }
    }
    
    int guessedLetterCount = [_currentWord guessedLetterCount];
    [guessedKeys removeObjectsInRange:NSMakeRange(guessedKeys.count - guessedLetterCount, guessedKeys.count)];
     _letterIndex -= guessedLetterCount;
    [_currentWord reset];
}

-(Boolean) isFullyGuessed
{
    return _letterIndex == answer.quoteLettersOnly.length;
}

-(Boolean) isCorrectlyGuessed
{
    Boolean result = [self isFullyGuessed];
    if(result)
    {
        result = [answer.quoteLettersOnly isEqualToString:_currentFullGuess];
    }
    return result;
}

-(NSString *) getGuessedKeysAsString
{
    return [guessedKeys componentsJoinedByString:@","];
}
-(void) guessKeysFromString:(NSString *) value
{
    [self resetRound];
    
    NSArray *ar = [value componentsSeparatedByString:@","];
    for(int i = 0; i < ar.count; i++)
    {
        NSString *val = (NSString *)ar[i];
        int index = [val intValue];
        [self guessTile:index];
    }
}

-(void) onWordCorrect
{
    
}
-(void) onWordIncorrect
{
    
}
-(void) onRoundComplete
{
    
}

- (NSString *) trace
{
    NSMutableString *s = [NSMutableString stringWithString:[grid trace]];
    [s appendString:@"\ranswer:\r"];
    for(int i = 0; i < tileWords.count; i++)
    for(TileWord *tw in tileWords)
    {
        [s appendString:[tw getGuessedWord]];
    }
    
    [s appendString:[_currentWord getGuessedWord]];
    
    [s appendString:[[answer.quoteLettersOnly substringFromIndex:_letterIndex] lowercaseString]];
    [s appendString:@"\r"];
    
    return s;
}

@end
