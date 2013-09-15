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
#import "GameRating.h"

@interface Game()
{
    int _currentIndex;
}

- (void) tempResetSaves;

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
            inst.loadAndSave = YES;
            
            [inst tempResetSaves];
        }
        return inst;
    }
}

- (void) tempResetSaves
{    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *roundRatingsName = [_quotePack.quotePackName stringByAppendingString:@"_ratings"];
    [defaults setObject:nil forKey:roundRatingsName];    
    [defaults synchronize];
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
    if(_loadAndSave && _currentRound != nil)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *guessedKeys = [_currentRound getGuessedKeysAsString];
        NSString *saveName = [_quotePack.quotePackName stringByAppendingString:[NSString stringWithFormat:@"%d",_currentIndex]];
        [defaults setObject:guessedKeys forKey:saveName];
        
        NSMutableArray *ratings;
        NSString *roundRatingsName = [_quotePack.quotePackName stringByAppendingString:@"_ratings"];

        if([defaults objectForKey:roundRatingsName] == nil)
        {
            //roundRatings = [@"" stringByPaddingToLength:self.quoteCount withString: @"0" startingAtIndex:0];
            ratings = [[NSMutableArray alloc] initWithCapacity:self.quoteCount];
            for(int i = 0; i < self.quoteCount; i++)
            {
                [ratings addObject:[[GameRating alloc]init]];
            }
        }
        else
        {
            NSData *data = [defaults objectForKey:roundRatingsName];
            ratings = [[NSKeyedUnarchiver unarchiveObjectWithData:data] mutableCopy];
        }
        
        RoundRating rating = [_currentRound roundRating];
        int pc = floor(_currentRound.letterIndex / _currentRound.answer.quoteLettersOnly.length * 100);
        GameRating *gr = [[GameRating alloc] initWithRating:rating percentComplete:pc points:0];
        [ratings setObject:gr atIndexedSubscript:_currentIndex];
               
        NSData *ratingsData = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithArray:ratings]];
        [defaults setObject:ratingsData forKey:roundRatingsName];
        
        [defaults synchronize];
    }
}
-(void) loadRound
{
    if(_loadAndSave)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *loadName = [_quotePack.quotePackName stringByAppendingString:[NSString stringWithFormat:@"%d",_currentIndex]];
        NSString *guessedKeys = [defaults objectForKey:loadName];
        [_currentRound guessKeysFromString:guessedKeys];
    }
}

-(void) resetRound
{
    
}

@end
