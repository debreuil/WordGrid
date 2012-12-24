//
//  Game.h
//  WordGridTests
//
//  Created by admin on 12-12-08.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Round;
@class Answer;
@class QuotePack;

@interface Game : NSObject

+ (Game *)instance;

@property (nonatomic) QuotePack *quotePack;
@property (nonatomic, readonly) int quoteCount;

@property (nonatomic) int currentIndex;
@property (nonatomic, readonly) Round *currentRound;
@property (nonatomic, readonly) Answer *currentAnswer;

- (void) incrementIndex;

@end
