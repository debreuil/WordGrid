//
//  GameRating.m
//  WordGrid
//
//  Created by admin on 12-12-26.
//
//

#import "GameRating.h"

@implementation GameRating

@synthesize roundRating = _roundRating;
@synthesize percentComplete = _percentComplete;
@synthesize points = _points;

- (id)init
{
    self = [super init];
    if(self)
    {
        _roundRating = notStarted;
        _percentComplete = 0;
        _points = 0;
    }
    return self;
}

- (id)initWithRating:(RoundRating) roundRating percentComplete:(int) percentComplete points:(int)points
{
    self = [super init];
    if(self)
    {
        _roundRating = roundRating;
        _percentComplete = percentComplete;
        _points = points;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[NSNumber numberWithInt:_roundRating] forKey:@"roundRating"];
    [encoder encodeObject:[NSNumber numberWithInt:_percentComplete] forKey:@"percentComplete"];
    [encoder encodeObject:[NSNumber numberWithInt:_points] forKey:@"points"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    _roundRating = [[decoder decodeObjectForKey:@"roundRating"] intValue];
    _percentComplete = [[decoder decodeObjectForKey:@"percentComplete"] intValue];
    _points = [[decoder decodeObjectForKey:@"points"] intValue];    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"rating:%d pc:%d pts:%d", _roundRating, _percentComplete, _points];
}

@end
