//
//  Answer.h
//  WordGridTests
//
//  Created by admin on 12-12-04.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Answer : NSObject

@property (nonatomic, readonly) CGSize gridSize;
@property (nonatomic, readonly) NSString *quote;
@property (nonatomic, readonly) NSString *quoteLettersOnly;
@property (nonatomic, readonly) NSArray *quoteWords;
@property (nonatomic, readonly) NSString *victoryBlurb;
@property (nonatomic, readonly) NSString *gridLetters;

@property (nonatomic, readonly) NSArray *keys;
@property (nonatomic, readonly) NSArray *keyWordArrays;

@property (nonatomic, readonly) Boolean savedWasCompleted;
@property (nonatomic, readonly) int savedRating;
@property (nonatomic, readonly) NSArray *savedKeyGuesses;


-(id) initWithData:(NSArray *) data;

@end
