//
//  Round.h
//  WordGridTests
//
//  Created by admin on 12-12-06.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import <Foundation/Foundation.h>

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
- (BOOL) guessTileByIndex:(int)index;
- (BOOL) guessTile:(Tile *)guessedTile;
- (void) undoLastWord;

-(BOOL) isFullyGuessed;
-(BOOL) isCorrectlyGuessed;
-(BOOL) isWordCorrectlyGuessed:(int)index;

-(void) setSelectableByLetter:(NSString *)let;

-(void) onWordCorrect;
-(void) onWordIncorrect;
-(void) onRoundComplete;

-(NSString *) getGuessedKeysAsString;
-(void) guessKeysFromString:(NSString *) value;

- (NSString *) trace;

@end
