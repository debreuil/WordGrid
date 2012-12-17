//
//  Tile.m
//  WordGridTests
//
//  Created by admin on 12-12-02.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import "Tile.h"

@implementation Tile

static Tile *emptyTileHolder;

@synthesize letter = _letter;
@synthesize displayLetter;
@synthesize currentIndex;
@synthesize targetIndex;
@synthesize isSelectable;
@synthesize isSelected;

-(id) initWithLetter:(NSString *) letter
{    
    self = [super init];
    if(self)
    {
        _letter = letter;
    }
    return self;
}

+(Tile *)emptyTile
{
    if(emptyTileHolder == nil)
    {
        emptyTileHolder = [[Tile alloc] initWithLetter:@" "];
    }
    return emptyTileHolder;
}

- (Boolean) isEmptyTile
{
    return [self.letter isEqual:@" "] || [self.letter isEqual:@""];
}

- (NSComparisonResult)compareFromBottomRight:(Tile *)otherObject
{
    if(self.currentIndex.y > otherObject.currentIndex.y)
    {
        return NSOrderedAscending;
    }
    else if(self.currentIndex.y == otherObject.currentIndex.y)
    {
        if(self.currentIndex.x > otherObject.currentIndex.x)
        {
            return NSOrderedAscending;
        }
        else if(self.currentIndex.x < otherObject.currentIndex.x)
        {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }
    else
    {
        return NSOrderedDescending;
    }
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"Tile l:%@ x:%d y:%d", self.letter, (int)self.currentIndex.x, (int)self.currentIndex.y];
}
@end
