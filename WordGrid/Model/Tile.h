//
//  Tile.h
//  WordGridTests
//
//  Created by admin on 12-12-02.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameRating;

@interface Tile : NSObject

@property (nonatomic, readonly) NSString *letter;
@property (nonatomic, readonly) NSString *displayLetter;
@property (nonatomic) CGPoint currentIndex;
@property (nonatomic, readonly) int currentLinearIndex;
@property (nonatomic) CGPoint targetIndex;
@property (nonatomic) Boolean isSelectable;
@property (nonatomic) Boolean isSelected;
@property (nonatomic) Boolean isHidden;

@property (nonatomic) GameRating *rating;


- (id) initWithLetter:(NSString *) letter;
- (NSComparisonResult) compareFromBottomRight:(Tile *)otherObject;

@end
