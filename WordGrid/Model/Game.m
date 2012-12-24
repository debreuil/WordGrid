//
//  Game.m
//  WordGridTests
//
//  Created by admin on 12-12-08.
//  Copyright (c) 2012 Debreuil Digital Works. All rights reserved.
//

#import "Game.h"
#import "QuotePack.h"
#import "Round.h"

@interface Game()
{
    int _currentIndex;
}
@end

@implementation Game

@synthesize currentRound = _currentRound;
@synthesize quotePack = _quotePack;

+ (Game *)instance
{
    static Game *inst;
    
    @synchronized(self)
    {
        if (!inst)
        {
            inst = [[Game alloc] init];
            NSString *name = @"QuotePackMain";
            NSArray *data = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"plist"]];
            inst.quotePack = [[QuotePack alloc] initWithData:data];
            inst.quotePack.quotePackName = name;
        }
        return inst;
    }
}

-(int)currentIndex
{
    return _currentIndex;
}
- (void) setCurrentIndex:(int) answerIndex
{
    _currentIndex = answerIndex;
    [_quotePack setAnswerIndex:_currentIndex];
    _currentRound = [[Round alloc] initWithAnswer:_quotePack.currentAnswer];
    [self loadRound];
}

-(Answer *) currentAnswer
{
    return _quotePack.currentAnswer;
}

- (void) incrementIndex
{
    int answerIndex = _currentIndex + 1;
    if(answerIndex > self.quoteCount)
    {
        answerIndex = 0;
    }
    
    [self setCurrentIndex:answerIndex];
}

- (int) quoteCount
{
    return _quotePack.answers.count;
}

- (void) saveRound
{
    if(_currentRound != nil)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *guessedKeys = [_currentRound getGuessedKeysAsString];
        NSString *saveName = [_quotePack.quotePackName stringByAppendingString:[NSString stringWithFormat:@"%d",_currentIndex]];
        [defaults setObject:guessedKeys forKey:saveName];
        [defaults synchronize];
    }
}
-(void) loadRound
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *loadName = [_quotePack.quotePackName stringByAppendingString:[NSString stringWithFormat:@"%d",_currentIndex]];
    NSString *guessedKeys = [defaults objectForKey:loadName];
    [_currentRound guessKeysFromString:guessedKeys];
}

-(void) resetRound
{
    
}

@end
