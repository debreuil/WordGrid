//
//  Tile.m
//  WordGridTests
//
//  Created by admin on 12-12-02.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import "Tile.h"

@implementation Tile

@synthesize letter = _letter;
@synthesize displayLetter = _displayLetter;
@synthesize currentIndex = _currentIndex;
@synthesize targetIndex = _targetIndex;
@synthesize isSelectable = _isSelectable;
@synthesize isSelected = _isSelected;
@synthesize isHidden = _isHidden;
@synthesize rating = _rating;

-(id) initWithLetter:(NSString *) letter
{    
    self = [super init];
    if(self)
    {
        _letter = letter;
    }
    return self;
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
    return [NSString stringWithFormat:@"Tile l:%@ x:%d y:%d h:%@", self.letter, (int)self.currentIndex.x, (int)self.currentIndex.y, self.isHidden ? @"Y":@"N"];
}
@end
