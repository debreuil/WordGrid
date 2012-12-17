//
//  Grid.h
//  WordGridTests
//
//  Created by admin on 12-12-02.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Tile;
@class TileWord;
@class Answer;

@interface Grid : NSObject

@property (nonatomic, readonly) CGSize gridSize;

-(Tile *) getTileFromIndex:(int)index;
-(Tile *) getTileFromBoxedIndex:(NSNumber *)index;
-(Tile *) getTileFromPoint:(CGPoint)pt;

-(int) getIndexFromPoint:(CGPoint)pt;
-(CGPoint) getPointFromIndex:(int)index;
-(NSString *) getLetterFromIndex:(int)index;
-(TileWord *) getTileWordFromIndexes:(NSArray *)indexes;

- (void)    clearAllSelections;
- (void)    setAllIsSelectable:(Boolean) isSelectable;

- (void)    setSelectableAroundIndex:(int) index;
- (void)    setSelectableByLetter:(NSString *)let;

-(void) insertWord:(TileWord *) indexesToRemove;
-(void) removeWord:(TileWord *) indexesToRemove;

-(NSString *) serialize;
-(void) deserializeCurrentRound:(Answer *) ans;
-(NSString *)  trace;

@end
