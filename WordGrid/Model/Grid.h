//
//  Grid.h
//  WordGridTests
//
//  Created by admin on 12-12-02.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import "IntGeometry.h"
#import <Foundation/Foundation.h>
@class Tile;
@class TileWord;
@class Answer;

@interface Grid : NSObject
{
    @private    
    NSMutableArray *selectedLetters;
    
    @protected
    NSMutableArray *grid;
    int elementCount;
}

@property (nonatomic) CGSize gridSize;

-(Tile *) getTileFromIndex:(int)index;
-(Tile *) getTileFromBoxedIndex:(NSNumber *)index;
-(Tile *) getTileFromPoint:(IntPoint)pt;
-(int)    getIndexFromTile:(Tile *)tile;

-(int) getIndexFromPoint:(IntPoint)pt;
-(IntPoint) getPointFromIndex:(int)index;
-(NSString *) getLetterFromIndex:(int)index;
-(TileWord *) getTileWordFromIndexes:(NSArray *)indexes;

- (void)    setAllIsSelectable:(Boolean) isSelectable;

- (void)    setSelectableAroundPoint:(IntPoint) point;
- (void)    setSelectableByLetter:(NSString *)let;

-(void) insertWord:(TileWord *) indexesToRemove;
-(void) removeWord:(TileWord *) indexesToRemove;

-(NSString *) serialize;
-(void) deserializeCurrentRound:(Answer *) ans;
-(void) createSelectionGrid:(int)count;
-(NSString *)  trace;

@end
