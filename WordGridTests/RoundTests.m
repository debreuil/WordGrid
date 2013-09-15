//
//  RoundTests.m
//  WordGridTests
//
//  Created by admin on 12-12-07.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import "RoundTests.h"
#import "Round.h"
#import "TileWord.h"
#import "Answer.h"
#import "Game.h"

@implementation RoundTests

Game *testGame;
Round *testRound;

- (void)setUp
{
    [super setUp];
    testGame = [Game instance];
    testGame.loadAndSave = NO;
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testAllRounds
{
    for(int i = 0; i < testGame.quoteCount; i++)
    {
        [self roundTestOfIndex:i];
    }
}

//- (void)invertGrid
//{
//    NSString *name = @"QuotePackMain";
//    NSArray *quoteData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"plist"]];
//    
//    for (NSArray *ar in quoteData)
//    {
//        Answer *ans = [[Answer alloc] initWithData:ar];
//        NSArray *keys = ans.keys;
//        NSString *lets = ans.gridLetters;
//    }
//    
//}

- (void)roundTestOfIndex:(int)index
{
    int testRoundIndex = index;
    testGame.currentIndex = testRoundIndex;
    testRound = testGame.currentRound;
    Answer *answer = testGame.currentAnswer;
    
    NSArray *keys = answer.keys;
    
    for (int i = 0; i < keys.count; i++)
    {
        [testRound guessTileByIndex:[[keys objectAtIndex:i] intValue]];
    }
    
    STAssertEquals((NSUInteger)testRound.letterIndex, keys.count, @"at last letter");
    STAssertEquals((NSUInteger)testRound.wordIndex, answer.quoteWords.count - 1, @"at last word");
    STAssertTrue([testRound isCorrectlyGuessed], @"round error %d. Answer: %@", index, testRound.currentFullGuess);
}

- (void)testIncorrectRound
{
    int testRoundIndex = 15;
    testGame.currentIndex = testRoundIndex;
    testRound = testGame.currentRound;
    Answer *answer = testGame.currentAnswer;
    
    
    TileWord *firstWord = testRound.currentWord;
    
    // guess 2 letters
    [testRound guessTileByIndex:37];
    [testRound guessTileByIndex:46];
    
    STAssertEquals(testRound.letterIndex, 2, @"at letter");
    STAssertEquals(testRound.wordIndex, 0, @"at word");
    STAssertTrue([[firstWord getGuessedWord] isEqualToString: @"EI"], @"incorrectly guessed");
    
    [testRound undoLastWord];
    
    STAssertEquals(testRound.letterIndex, 0, @"at letter");
    STAssertEquals(testRound.wordIndex, 0, @"at word");
    STAssertTrue([[firstWord getGuessedWord] isEqualToString: @""], @"correctly guessed");
    
    
    
    NSArray *keys = [[NSArray alloc]initWithObjects:@61, @53, @43, @51, @52, nil];
    // guess wrong word
    for (int i = 0; i < keys.count; i++)
    {
        [testRound guessTileByIndex:[[keys objectAtIndex:i] intValue]];
    }
    NSString *guessedKeys = [testRound getGuessedKeysAsString];
    STAssertTrue([guessedKeys isEqualToString:@"61,53,43,51,52"], @"guessed Keys");
    
    STAssertEquals(testRound.letterIndex, 5, @"at letter");
    STAssertEquals(testRound.wordIndex, 1, @"at word");
    STAssertTrue([[firstWord getGuessedWord] isEqualToString: @"SDEAN"], @"incorrectly guessed");
    
    [testRound undoLastWord];
    
    
    
    // guess correct word
    STAssertEquals(testRound.letterIndex, 0, @"at letter");
    STAssertEquals(testRound.wordIndex, 0, @"at word");
    STAssertTrue([[firstWord getGuessedWord] isEqualToString: @""], @"correctly guessed");
    
    for (int i = 0; i < 5; i++)
    {
        [testRound guessTileByIndex:[[answer.keys objectAtIndex:i] intValue]];
    }
    
    STAssertEquals(testRound.letterIndex, 5, @"at letter");
    STAssertEquals(testRound.wordIndex, 1, @"at word");
    STAssertTrue([[firstWord getGuessedWord] isEqualToString: @"THERE"], @"correctly guessed");
}
@end







 



