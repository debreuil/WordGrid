//
//  Round.h
//  WordGridTests
//
//  Created by admin on 12-12-06.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Answer.h"

@class Answer;
@class Grid;
@class TileWord;
@class Tile;

@interface Round : NSObject

@property (nonatomic, readonly) Grid *grid;
@property (nonatomic, readonly) Answer *answer;
@property (nonatomic, readonly) int letterIndex;
@property (nonatomic, readonly) int wordIndex;
@property (nonatomic, readonly) NSString *currentFullGuess;
@property (nonatomic, readonly) TileWord *currentWord;
@property (nonatomic, readonly) NSString *currentCorrectLetter;

- (id)initWithAnswer:(Answer *)answer;

- (void) resetRound;
- (NSArray *) getGuessedTiles;
- (BOOL) guessTileByIndex:(int)index;
- (BOOL) guessTile:(Tile *)guessedTile;
- (void) checkWord;
- (void) undoLastWord;

-(BOOL) isFullyGuessed;
-(BOOL) isCorrectlyGuessed;
-(BOOL) isWordCorrectlyGuessed:(int)index;

-(void) setSelectableByLetter;

-(void) onWordCorrect;
-(void) onWordIncorrect;
-(void) onRoundComplete;

-(NSString *) getGuessedKeysAsString;
-(void) guessKeysFromString:(NSString *) value;
-(RoundRating) roundRating;

- (void) exposeAllLetters;

- (NSString *) trace;

@end
