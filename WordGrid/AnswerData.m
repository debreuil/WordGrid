#import "AnswerData.h"

@implementation AnswerData

static NSArray *quotes;

+ (void) initialize
{
    quotes = [NSArray arrayWithObjects:
                [NSArray arrayWithObjects:
                    @"THE BIGGER THEY COME THE HARDER THEY FALL", 
                    @"                      AH    I  OETL GGBMRCHHEEHEEHTYFLTRYTDEREA", nil
                 ],
                [NSArray arrayWithObjects:
                    @"A LEADER LEADS BY EXAMPLE NOT BY FORCE", 
                    @"                 E     M TO    PE CN  ELAELYF EASAYAXO DRDLBBRE", nil
                ],
                [NSArray arrayWithObjects:
                    @"TO KNOW YOUR ENEMY YOU MUST BECOME YOUR ENEMY", 
                    @"     ESOB     EOEE     NYUC    OMUEM   NRUEOM  TYOMYTY  KOWUNRY", nil
                ],
                [NSArray arrayWithObjects:
                    @"OPPORTUNITIES MULTIPLY AS THEY ARE SEIZED", 
                    @"", nil
                ],
                [NSArray arrayWithObjects:
                    @"PRETEND INFERIORITY AND ENCOURAGE HIS ARROGANCE", 
                    @"", nil
                ],
                [NSArray arrayWithObjects:
                    @"BUILD YOUR OPPONENT A GOLDEN BRIDGE TO RETREAT ACROSS", 
                    @"", nil
                ],
                [NSArray arrayWithObjects:
                    @"ALL WARFARE IS BASED ON DECEPTION", 
                    @"", nil
                ],
                [NSArray arrayWithObjects:
                    @"TO A SURROUNDED ENEMY, YOU MUST LEAVE A WAY OF ESCAPE", 
                    @"", nil
                ],
                 nil
            ];
}

+ (int) getCurrentIndex
{
    return 2;
}
+ (NSString *) getCurrentQuote
{
    return [[quotes objectAtIndex:[AnswerData getCurrentIndex]] objectAtIndex:0];
}
+ (NSString *) getCurrentGrid
{
    return [[quotes objectAtIndex:[AnswerData getCurrentIndex]] objectAtIndex:1];
}

+ (NSArray *) getQuotePairAt:(int)index
{
    return [quotes objectAtIndex:index];
}

+ (int) getQuoteCount
{
    return quotes.count;
}

@end
