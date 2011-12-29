#import "AnswerData.h"

@implementation AnswerData

static int currentIndex;
static NSArray *quotes;

+ (void) initialize
{
    currentIndex = 0;
    quotes = [NSArray arrayWithObjects:
              [NSArray arrayWithObjects:
               @"THE TRUE MYSTERY OF THE WORLD IS THE VISIBLE NOT THE INVISIBLE", 
                    @"           TRIEHT VTEUNTSYMIHINVERYOSEEOIIBLFISWTSTHEEBLORLDEHT",
               @"Oscar Wilde", 
               @"62,61,60,59,58,49,40,31,22,61,60,59,57,48,39,56,55,54,45,36,27,18,60,61,62,46,47,59,58,57,56,47,37,28,19,44,35,34,33,32,23,24,25,26,20,21,12,11,14,15,16", nil
               ],
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

+ (void) incrementIndex
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
