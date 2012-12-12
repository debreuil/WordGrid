//
//  Letter.m
//  WordGrid
//
//  Created by admin on 12-12-01.
//
//

#import "Letter.h"

@implementation Letter

@synthesize letter = _letter;
@synthesize gridX = _gridX;
@synthesize gridY = _gridY;

- (id) initLetter:(NSString *) letter
{
    self = [super init];
    if (self)
    {
        _letter = letter;
        _gridX = -1;
        _gridY = -1;
    }
    return self;
}

- (id) initLetter:(NSString *) letter atX: (int) x andY:(int)y
{
    self = [super init];
    if (self)
    {
        _letter = letter;
        _gridX = x;
        _gridY = y;
    }
    return self;
}

@end
