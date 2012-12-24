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
    NSMutableArray *isCorrectGuessedWords;
    NSMutableArray *guessedKeys;
}
- (void) replaceCurrentWordWithCorrectTiles;

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
    _currentWord = [[TileWord alloc] initWithAnswer:[_answer.quoteWords objectAtIndex:_wordIndex]];
        
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
        guessedKeys = [[NSMutableArray alloc] initWithCapacity:_answer.keys.count];
    }
    else
    {
        [guessedKeys removeAllObjects];
    }
    
    isCorrectGuessedWords = [[NSMutableArray alloc] initWithCapacity:_answer.quoteWords.count];
    
    [self setSelectableByLetter];
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

-(void) setSelectableByLetter
{
    [self.grid setSelectableByLetter:[self currentCorrectLetter]];
}

-(void) replaceCurrentWordWithCorrectTiles
{
    if([_currentWord isFullyGuessed])
    {
        [guessedKeys removeObjectsInRange:NSMakeRange(guessedKeys.count - _currentWord.tiles.count, _currentWord.tiles.count)];
        
        for(Tile *t in _currentWord.tiles)
        {
            t.isSelected = NO;
        }
        [_currentWord.tiles removeAllObjects];
        
        NSArray *correctIndexes = [_answer.keyWordArrays objectAtIndex:_wordIndex];
        for(int i = 0; i < correctIndexes.count; i++)
        {
            int correctIndex = [[correctIndexes objectAtIndex:i] intValue];
            Tile *t = [_grid getTileFromIndex:correctIndex];            
            t.isSelected = YES;
            [_currentWord addTile:t];
            [guessedKeys addObject:[NSNumber numberWithInt:[self.grid getIndexFromTile:t]]];
        }
    }
}

- (BOOL) guessTileByIndex:(int)index
{
    Tile *guessedTile = [_grid getTileFromIndex:index];
    return [self guessTile:guessedTile];
}

- (BOOL) guessTile:(Tile *)guessedTile
{
    guessedTile.isSelected = YES;
    
    [_currentWord addTile:guessedTile];
    [guessedKeys addObject:[NSNumber numberWithInt:[self.grid getIndexFromTile:guessedTile]]];
    _currentFullGuess = [_currentFullGuess stringByAppendingString:guessedTile.letter];
    
    NSString *correctLetter = [[_answer quoteLettersOnly] substringWithRange:NSMakeRange(_letterIndex, 1)];
    BOOL result = [correctLetter isEqualToString:guessedTile.letter];
    _letterIndex++;
    if([_currentWord isFullyGuessed])
    {
        if([_currentWord isCorrectlyGuessed])
        {
            // make sure the correct letters are from the correct spots
            [self replaceCurrentWordWithCorrectTiles];            
            [self onWordCorrect];
        }
        else
        {
            [self onWordIncorrect];
        }
        
        if(_wordIndex < _answer.quoteWords.count - 1)
        {
            [tileWords addObject:_currentWord];
            [_grid removeWord:_currentWord];
            _wordIndex++;
            _currentWord = [[TileWord alloc] initWithAnswer:[_answer.quoteWords objectAtIndex:_wordIndex]];

            [self setSelectableByLetter];
        }
        else if([self isCorrectlyGuessed])
        {
            [self onRoundComplete];
        }
    }
    else
    {
        [self.grid setSelectableAroundPoint:guessedTile.currentIndex];
    }
    return result;
}
- (void) undoLastWord
{
    int guessedLetterCount = 0;
    if(_currentWord.guessedLetterCount == 0)
    {
        if(_wordIndex > 0)
        {
            _wordIndex--;
            _currentWord = [tileWords objectAtIndex:_wordIndex];
            [isCorrectGuessedWords removeLastObject];
            [_grid insertWord:_currentWord];
            guessedLetterCount = [_currentWord getGuessedWord].length;
        }
    }
    else
    {
        guessedLetterCount = [_currentWord guessedLetterCount];
    }
    
    NSRange removeRange = NSMakeRange(guessedKeys.count - guessedLetterCount, guessedLetterCount);
    [guessedKeys removeObjectsInRange:removeRange];
    _currentFullGuess = [_currentFullGuess substringToIndex:_currentFullGuess.length - guessedLetterCount];
     _letterIndex -= guessedLetterCount;
    [_currentWord reset];
    [tileWords removeObjectsInRange:NSMakeRange(_wordIndex, tileWords.count - _wordIndex)];        
}

-(BOOL) isFullyGuessed
{
    return _letterIndex == _answer.quoteLettersOnly.length;
}

-(BOOL) isCorrectlyGuessed
{
    BOOL result = [self isFullyGuessed];
    if(result)
    {
        result = [_answer.quoteLettersOnly isEqualToString:_currentFullGuess];
    }
    return result;
}

-(BOOL) isWordCorrectlyGuessed:(int)index
{
    BOOL result = NO;
    if(index >= 0 && index < isCorrectGuessedWords.count)
    {
        result = [[isCorrectGuessedWords objectAtIndex:index] boolValue];
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
    
    //NSLog(@"%@", [self trace]);
    if(value.length > 0)
    {
        NSArray *ar = [value componentsSeparatedByString:@","];
        for(int i = 0; i < ar.count; i++)
        {
            NSString *val = (NSString *)ar[i];
            int index = [val intValue];
            [self guessTileByIndex:index];
        }
    }
    //NSLog(@"%@", [self trace]);
}

-(void) onWordCorrect
{
    [isCorrectGuessedWords addObject:[NSNumber numberWithBool:YES]];
}
-(void) onWordIncorrect
{
    [isCorrectGuessedWords addObject:[NSNumber numberWithBool:NO]];    
}
-(void) onRoundComplete
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"onRoundComplete"
     object:self];    
}

- (NSString *) trace
{
    NSMutableString *s = [NSMutableString stringWithString:[_grid trace]];
    [s appendString:@"\nprevious guessed words:\n"];

    for(TileWord *tw in tileWords)
    {
        [s appendString:[tw getGuessedWord]];
        [s appendString:@", "];
    }    
    [s appendString:@"\ncurrent guessed word:\n"];    
    [s appendString:[_currentWord getGuessedWord]];
    
    [s appendString:@"\ncorrect so far:\n"];    
    [s appendString:[_answer.quoteLettersOnly substringToIndex:_letterIndex]];
    
    [s appendString:@"\ntiles:\n"];    
    for(int i = 0; i < _answer.quoteLettersOnly.length; i++)
    {
        Tile *t = [_grid getTileFromIndex:i];
        [s appendString:[t description]];
        [s appendString:@"\n"];
    }
    return s;
}

@end
