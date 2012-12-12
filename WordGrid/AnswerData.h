#import <Foundation/Foundation.h>

@interface AnswerData : NSObject
{
}

+ (NSArray *)   getQuotePairAt:(int)index;
+ (int)         getQuoteCount;
+ (int)         getCurrentIndex;
+ (void)        setCurrentIndex:(int)value;
+ (NSString *)  getCurrentQuote;
+ (NSString *)  getCurrentSource;
+ (NSArray *)   getCurrentIndexes;
+ (NSString *)  getCurrentGrid;
+ (void)       incrementIndex;

@end
