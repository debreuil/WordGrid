//
//  QuotePack.m
//  WordGridTests
//
//  Created by admin on 12-12-08.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import "QuotePack.h"
#import "Answer.h"

@implementation QuotePack

@synthesize quotePackName = _quotePackName;
@synthesize currentIndex = _currentIndex;
@synthesize answers = _answers;

-(id) initWithData:(NSArray *) quoteData
{
    self = [super init];
    if(self)
    {
        _currentIndex = 0;
        _answers = [[NSMutableArray alloc]initWithCapacity:quoteData.count];
        for (NSArray *ar in quoteData)
        {
            Answer *ans = [[Answer alloc] initWithData:ar];
            [_answers addObject:ans];
        }
    }
    return self;
}


-(void) setAnswerIndex:(int) index
{
    _currentIndex = index;
}
-(Answer *) currentAnswer
{
    return [_answers objectAtIndex:_currentIndex];
}



@end
