//
//  Word.m
//  WordGridTests
//
//  Created by admin on 12-12-03.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import "TileWord.h"
#import "Tile.h"

@interface TileWord()
{
    NSString *answerText;
    NSSortDescriptor *sortFromBR;
}
@end

@implementation TileWord

@synthesize tiles = _tiles;
@synthesize gaps = _gaps;

//-(id) initWithTiles:(NSArray *) tiles
//{
//    self = [super init];
//    if(self)
//    {
//        _tiles = [[NSMutableArray alloc] initWithArray:tiles copyItems:YES];
//        _gaps = [[NSMutableArray alloc]initWithCapacity:20];
//    }
//    return self;
//}
-(id) initWithAnswer:(NSString *) answer
{
    self = [super init];
    if(self)
    {
        answerText = answer;
        _tiles = [[NSMutableArray alloc] initWithCapacity:answer.length];
        _gaps = [[NSMutableArray alloc] initWithCapacity:answer.length];
    }
    return self;
}


-(NSArray *) getGuessedTiles
{
    return [_tiles copy];
}

-(void) addTile:(Tile *) tile
{
    [self.tiles addObject:tile];
}
-(void) addTiles:(NSArray *) tiles
{
    [self.tiles addObjectsFromArray:tiles];
}
-(void) removeLastTile
{
    [self.tiles removeLastObject];
}
-(void) reset
{
    [self.tiles removeAllObjects];
    [self.gaps removeAllObjects];
}

-(int) guessedLetterCount
{
    return (int)self.tiles.count;
}
-(Boolean) isFullyGuessed
{
    return answerText.length == self.tiles.count;
}

-(Boolean) isCorrectlyGuessed
{
    Boolean result = [self isFullyGuessed];
    if(result)
    {
        result = [answerText isEqualToString:[self getGuessedWord]];
    }
    return result;
}

-(NSString *) getGuessedWord
{
    NSMutableString *s = [[NSMutableString alloc] initWithCapacity:self.tiles.count];
    for (Tile *t in self.tiles)
    {
        if(t == (id)[NSNull null]) continue;
        
        [s appendString:t.letter];
    }
    return [NSString stringWithString:s];
}

-(NSArray *)getTilesSortedFromBottomRight
{
    NSArray *result = [self.tiles sortedArrayUsingSelector:@selector(compareFromBottomRight:)];
    
    NSMutableString *s = [[NSMutableString alloc] initWithCapacity:self.tiles.count];
    for (Tile *t in result)
    {
        if(t == (id)[NSNull null]) continue;
        
        [s appendString:t.letter];
    }
    return result;
}



@end
