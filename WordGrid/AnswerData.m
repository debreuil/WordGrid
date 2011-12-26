#import "AnswerData.h"

@implementation AnswerData

static int currentIndex;
static NSArray *quotes;

+ (void) initialize
{
    currentIndex = 0;
    quotes = [NSArray arrayWithObjects:
                [NSArray arrayWithObjects:
                    @"FIND ALL THE WORDS", 
                    @"                                       TW      ALHO   FINDLERDS", nil
                ],
                [NSArray arrayWithObjects:
                    @"PRESS ON THE ANSWER AREA TO UNDO SOME WORDS", 
                    @"                     SW    UNDOOO   PRESSMRDSANSAREETOTHEWERAON", nil
                ],
                [NSArray arrayWithObjects:
                    @"THE BIGGER THEY COME THE HARDER THEY FALL", 
                    @"                     H F     TTARA  BIGHHEDERTHEGERYLLCOMEETHEY", nil
                ],
                [NSArray arrayWithObjects:
                    @"ON A RAINY NIGHT IN SOHO THE WIND WAS WHISTLING ALL ITS CHARMS", 
                    @"R        A S  A  OIWITDIRMNNWANINTSAYHESLSNGSTHICHIOHOWNIGHTALL", nil
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
                    @"                E    TAE Z    TIPIA T MUYRLPOIINLTOPESESUHERSYD", nil
                ],
                [NSArray arrayWithObjects:
                    @"PRETEND INFERIORITY AND ENCOURAGE HIS ARROGANCE", 
                    @"  A        N   N   FRETDA   PRIENEN  EGIRRDIAIRORUONHSTYEAOCGCE", nil
                ],
                [NSArray arrayWithObjects:
                    @"BUILD YOUR OPPONENT A GOLDEN BRIDGE TO RETREAT ACROSS", 
                    @"               AT Y DA TBUIUODIENCOLORLNRERSDPPOERTOATGOGENBRES", nil
                ],
                [NSArray arrayWithObjects:
                    @"ALL WARFARE IS BASED ON DECEPTION", 
                    @"               E        TCI    ESIPS    ANAOD    FREBEALLDORAWN", nil
                ],
                [NSArray arrayWithObjects:
                    @"TO A SURROUNDED ENEMY YOU MUST LEAVE A WAY OF ESCAPE", 
                    @"              E     U LSUND TSUMODEEOAERRCAYFYMNSUEAVEYOETAWAPO", nil
                ],
                 nil
            ];
}

+ (int) getCurrentIndex
{
    return currentIndex;
}

+ (int) incrementIndex
{
    currentIndex++;
    if(currentIndex >= quotes.count)
    {
        currentIndex = 0;
    }
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
