//
//  Answer.h
//  WordGridTests
//
//  Created by admin on 12-12-04.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    notStarted = 0,
    inProgress,
    complete0,
    complete1,
    complete2
} RoundRating;


@interface Answer : NSObject

@property (nonatomic, readonly) CGSize gridSize;
@property (nonatomic, readonly) NSString *quote;
@property (nonatomic, readonly) NSString *quoteUnderscores;
@property (nonatomic, readonly) NSString *quoteLettersOnly;
@property (nonatomic, readonly) NSArray *quoteWords;
@property (nonatomic, readonly) NSString *victoryBlurb;
@property (nonatomic, readonly) NSString *gridLetters;

@property (nonatomic, readonly) NSArray *keys;
@property (nonatomic, readonly) NSArray *keyWordArrays;
@property (nonatomic, readonly) NSArray *letterPositionsInQuote;

@property (nonatomic, readonly) Boolean savedWasCompleted;

-(id) initWithData:(NSArray *) data;

@end
