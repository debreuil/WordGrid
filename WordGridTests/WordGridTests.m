//
//  WordGridTestsTests.m
//  WordGridTestsTests
//
//  Created by admin on 12-12-02.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import "WordGridTests.h"
#import "Grid.h"
#import "Answer.h"
#import "TileWord.h"
#import "Tile.h"
#import "Game.h"

@interface WordGridTests()
- (void) checkSerialization;
- (void) checkAnswer;
@end

@implementation WordGridTests

Game *testGame;
Grid *grid;

- (void)setUp
{
    [super setUp];
    testGame = [Game instance];
    grid = [[Grid alloc]init];
}
- (void)tearDown
{
    [super tearDown];
}

- (void)testSerialization
{
    for (int i = 0; i < testGame.quoteCount; i++)
    {
        testGame.currentIndex = i;
        [grid deserializeCurrentRound:testGame.currentAnswer];
        [self checkSerialization];        
    }
}
- (void)testWordArrays
{
    testGame.currentIndex = 15;
    Answer *ans = testGame.currentAnswer;
    
    NSArray *wordArray = ans.quoteWords;
    NSString *words = [wordArray componentsJoinedByString:@" "];
    STAssertEqualObjects(words, @"THERE ARE LIES DAMNED LIES AND STATISTICS", @"word parsing test, 15");
}


- (void) checkSerialization
{
    Answer *ans = testGame.currentAnswer;
    NSString *gridString = ans.gridLetters;
    NSString *gridSerialized = [grid serialize];
    
    STAssertEqualObjects(gridString,
                         gridSerialized,
                         [NSString stringWithFormat:@"grid serialization %d.", testGame.currentIndex]);
}
- (void) checkAnswer
{
    int answerIndex = testGame.currentIndex;
    Answer *ans = testGame.currentAnswer;
    NSString *quote = ans.quoteLettersOnly;
    NSLog(@"\n\nquote: %@\n\n", quote);
    
    NSArray *answerKeys = ans.keys;
    NSLog(@"\nanswerKeys: %@\n\n", answerKeys);
    
    for (int i = 0; i < answerKeys.count; i++)
    {
        NSNumber *answerKey = [answerKeys objectAtIndex:i];
        NSString *gridLetter = [grid getLetterFromIndex:[answerKey intValue]];
        NSString *answerLetter = [quote substringWithRange:NSMakeRange(i, 1)];
        
        STAssertEqualObjects(gridLetter, answerLetter, [NSString stringWithFormat:@"grid answer %d letter %d.", answerIndex, i]);
    }
}

@end
