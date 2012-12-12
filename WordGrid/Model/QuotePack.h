//
//  QuotePack.h
//  WordGridTests
//
//  Created by admin on 12-12-08.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Answer;

@interface QuotePack : NSObject

@property (nonatomic) NSString *quotePackName;
@property (nonatomic) int currentIndex;
@property (nonatomic, readonly) Answer *currentAnswer;
@property (nonatomic, readonly) NSMutableArray *answers;

-(id) initWithData:(NSArray *) quoteData;
-(void) setAnswerIndex:(int) index;

@end
