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
    NSMutableArray *tileWords;
    NSMutableArray *guessedKeys;
}

- (void) resetRound;
@end

@implementation Round

@synthesize grid = _grid;
@synthesize answer = _answer;
@synthesize letterIndex = _letterIndex;
@synthesize wordIndex = _wordIndex;
@synthesize currentFullGuess = _currentFullGuess;
@synthesize currentWord = _currentWord;
@synthesize currentCorrectLetter = _currentCorrectLetter;

- (id)initWithAnswer:(Answer *)ans
{
    self = [super init];
    if(self)
    {
        _answer = ans;
        [self resetRound];
    }
    return self;
}

- (void) resetRound
{
    _letterIndex = 0;
    _wordIndex = 0;
    _currentFullGuess = @"";
        
    _grid = [[Grid alloc]init];
    [_grid deserializeCurrentRound:_answer];
    
    if(tileWords == nil)
    {
        tileWords = [[NSMutableArray alloc] initWithCapacity:_answer.quoteWords.count];
    }
    else
    {
        [tileWords removeAllObjects];
    }
    
    if(guessedKeys == nil)
    {
        guessedKeys = [[NSMutableArray alloc] initWithCapacity:_answer.quoteLettersOnly.length];
    }
    else
    {
        [guessedKeys removeAllObjects];
    }
    
    if(_currentWord == nil)
    {
        _currentWord = [[TileWord alloc] initWithAnswer:[_answer.quoteWords objectAtIndex:_wordIndex]];
    }
    else
    {
        [_currentWord reset];
    }        
}

- (NSString *) currentCorrectLetter
{
    NSString *let;
    if(_letterIndex >= 0 && _letterIndex < self.answer.keys.count)
    {
        let = [self.answer.quoteLettersOnly substringWithRange:NSMakeRange(_letterIndex, 1)];
    }
    else
    {
        let = @"-";
    }
    return let;
}

-(void) setSelectableByLetter:(NSString *)let
{
    [self.grid setSelectableByLetter:let];
}

- (Boolean) guessTileByIndex:(int)index
{
    Tile *guessedTile = [_grid getTileFromIndex:index];
    return [self guessTile:guessedTile];
}

- (Boolean) guessTile:(Tile *)guessedTile
{
    [_currentWord addTile:guessedTile];
    [guessedKeys addObject:[NSNumber numberWithInt:[self.grid getIndexFromTile:guessedTile]]];
    _currentFullGuess = [_currentFullGuess stringByAppendingString:guessedTile.letter];
    
    NSString *correctLetter = [[_answer quoteLettersOnly] substringWithRange:NSMakeRange(_letterIndex, 1)];
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
        [_grid removeWord:_currentWord];
        _wordIndex++;
        
        if(_wordIndex >= _answer.quoteWords.count)
        {
            [self onRoundComplete];
        }
        else
        {
            _currentWord = [[TileWord alloc] initWithAnswer:[_answer.quoteWords objectAtIndex:_wordIndex]];
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
    return _letterIndex == _answer.quoteLettersOnly.length;
}

-(Boolean) isCorrectlyGuessed
{
    Boolean result = [self isFullyGuessed];
    if(result)
    {
        result = [_answer.quoteLettersOnly isEqualToString:_currentFullGuess];
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
        [self guessTileByIndex:index];
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
    NSMutableString *s = [NSMutableString stringWithString:[_grid trace]];
    [s appendString:@"\ranswer:\r"];
    for(int i = 0; i < tileWords.count; i++)
    for(TileWord *tw in tileWords)
    {
        [s appendString:[tw getGuessedWord]];
    }
    
    [s appendString:[_currentWord getGuessedWord]];
    
    [s appendString:[[_answer.quoteLettersOnly substringFromIndex:_letterIndex] lowercaseString]];
    [s appendString:@"\r"];
    
    return s;
}

@end
