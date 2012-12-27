//
//  GameRating.h
//  WordGrid
//
//  Created by admin on 12-12-26.
//
//

#import <Foundation/Foundation.h>
#import "Answer.h"

@interface GameRating : NSObject <NSCoding>

@property (nonatomic) RoundRating roundRating;
@property (nonatomic) int percentComplete;
@property (nonatomic) int points;

- (id)init;
- (id)initWithRating:(RoundRating) roundRating percentComplete:(int) percentComplete points:(int)points;

@end
