#import <Foundation/Foundation.h>

@interface AnswerData : NSObject
{
}

+ (NSArray *)   getQuotePairAt:(int)index;
+ (int)        getQuoteCount;
+ (int)        getCurrentIndex;
+ (NSString *)  getCurrentQuote;
+ (NSString *)  getCurrentGrid;
+ (void)       incrementIndex;

@end
