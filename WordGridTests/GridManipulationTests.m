//
//  GridManipulationTests.m
//  WordGridTests
//
//  Created by admin on 12-12-04.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import "GridManipulationTests.h"
#import "Grid.h"
#import "Answer.h"
#import "TileWord.h"
#import "Tile.h"
#import "Game.h"

@interface GridManipulationTests()
- (void)roundRemoveAddAll:(int) puzzleIndex;
@end

@implementation GridManipulationTests

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

- (void)testTileWordSorting
{
    testGame.currentIndex = 15;
    Answer *ans = testGame.currentAnswer;
    [grid deserializeCurrentRound:ans];
    
    NSArray *keys = ans.keys;
    
    Tile *t0 = [grid getTileFromBoxedIndex:[keys objectAtIndex:0]];
    Tile *h1 = [grid getTileFromBoxedIndex:[keys objectAtIndex:1]];
    Tile *e2 = [grid getTileFromBoxedIndex:[keys objectAtIndex:2]];
    Tile *r3 = [grid getTileFromBoxedIndex:[keys objectAtIndex:3]];
    Tile *e4 = [grid getTileFromBoxedIndex:[keys objectAtIndex:4]];
    
    NSArray *wordTiles = [NSArray arrayWithObjects:t0, h1, e2, r3, e4, nil];
    TileWord *word = [[TileWord alloc] initWithAnswer:@"THERE"];
    [word addTiles:wordTiles];
    STAssertEqualObjects([word getGuessedWord], @"THERE", @"string from TileWord");
    
    NSArray *sorted = [word getTilesSortedFromBottomRight];
    // 56,47,38,29,37
    
    STAssertTrue(![t0 isEqual:[sorted objectAtIndex:0]], @"not equal");
    STAssertEqualObjects([sorted objectAtIndex:0], e4, @"sorted letter");
    STAssertEqualObjects([sorted objectAtIndex:1], r3, @"sorted letter");
    STAssertEqualObjects([sorted objectAtIndex:2], h1, @"sorted letter");
    STAssertEqualObjects([sorted objectAtIndex:3], e2, @"sorted letter");
    STAssertEqualObjects([sorted objectAtIndex:4], t0, @"sorted letter");
    
    NSString *orgGrid = [grid serialize];
    [grid removeWord:word];
    [grid insertWord:word];
    NSString *readdGrid = [grid serialize];
    STAssertEqualObjects(orgGrid, readdGrid, @"remove and readd word");
}

- (void)testRemoveAddAll
{
    for(int i = 0; i < testGame.quoteCount; i++)
    {
        [self roundRemoveAddAll:i];
    }
}

- (void)roundRemoveAddAll:(int) puzzleIndex
{
    testGame.currentIndex = puzzleIndex;
    Answer *ans = testGame.currentAnswer;
    [grid deserializeCurrentRound:ans];
        
    NSArray *words = ans.quoteWords;
    NSArray *indexes = ans.keyWordArrays;
    NSMutableArray *tileWords = [[NSMutableArray alloc] initWithCapacity:indexes.count];
    
    for(int i = 0; i < indexes.count; i++)
    {
        //NSLog(@"%@\n\n",[grid getGridTrace]);
        TileWord *tw = [grid getTileWordFromIndexes:indexes[i]];
        [tileWords addObject:tw];
        NSString *word = [tw getGuessedWord];
        [grid removeWord:tw];
        STAssertEqualObjects(word, words[i], [NSString stringWithFormat: @"round %d.", i]);
    }
    
    for(int i = tileWords.count - 1; i >= 0; i--)
    {
        //NSLog(@"%@\n\n",[grid getGridTrace]);
        [grid insertWord:[tileWords objectAtIndex:i]];
    }
    NSString *finalGrid = [grid serialize];
    STAssertEqualObjects(finalGrid, ans.gridLetters, @"RemoveAddAll regenerated words");
}


@end
