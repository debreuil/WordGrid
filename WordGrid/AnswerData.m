#import "AnswerData.h"

@implementation AnswerData

static int currentIndex;
static NSArray *quotes;
static BOOL hasPlayed;

+ (void) initialize
{
    currentIndex = 0;
    hasPlayed = NO;
    quotes = [NSArray arrayWithObjects:
              
              
              //[NSArray arrayWithObjects:@"I AM NOT YOUNG ENOUGH TO KNOW EVERYTHING.", @"", @"OSCAR WILDE", nil],
              //[NSArray arrayWithObjects:@"ALL GREAT TRUTHS BEGIN AS BLASPHEMIES.", @"", @"GEORGE BERNARD SHAW", nil],
              //[NSArray arrayWithObjects:@"ONE SHOULD ALWAYS PLAY FAIRLY WHEN ONE HAS THE WINNING CARDS.", @"", @"OSCAR WILDE", nil],
              //[NSArray arrayWithObjects:@"WHENEVER PEOPLE AGREE WITH ME I ALWAYS FEEL I MUST BE WRONG.", @"", @"OSCAR WILDE", nil],
              //[NSArray arrayWithObjects:@"WORK IS THE CURSE OF THE DRINKING CLASSES.", @"", @"OSCAR WILDE", nil],
              //[NSArray arrayWithObjects:@"I CAN RESIST ANYTHING BUT TEMPTATION.", @"", @"OSCAR WILDE", nil],
              //[NSArray arrayWithObjects:@"THE TRUTH IS RARELY PURE AND NEVER SIMPLE.", @"", @"OSCAR WILDE", nil],
              //[NSArray arrayWithObjects:@"A MAN CANNOT BE TOO CAREFUL IN THE CHOICE OF HIS ENEMIES.", @"", @"OSCAR WILDE", nil],
              //[NSArray arrayWithObjects:@"IT IS BETTER TO HAVE A PERMANENT INCOME THAN TO BE FASCINATING.", @"", @"OSCAR WILDE", nil],
              //[NSArray arrayWithObjects:@"A THING IS NOT NECESSARILY TRUE BECAUSE A MAN DIES FOR IT.", @"", @"OSCAR WILDE", nil],
              //[NSArray arrayWithObjects:@"ALL BAD POETRY SPRINGS FROM GENUINE FEELING.", @"", @"OSCAR WILDE", nil],
              //[NSArray arrayWithObjects:@"HE WHO CAN, DOES. HE WHO CANNOT, TEACHES.", @"", @"GEORGE BERNARD SHAW", nil],
              //[NSArray arrayWithObjects:@"THERE IS NO LOVE SINCERER THAN THE LOVE OF FOOD.", @"", @"GEORGE BERNARD SHAW", nil],
              //[NSArray arrayWithObjects:@"THE REPORTS OF MY DEATH HAVE BEEN GREATLY EXAGGERATED.", @"", @"MARK TWAIN", nil],
              //[NSArray arrayWithObjects:@"THERE ARE LIES, DAMNED LIES AND STATISTICS.", @"", @"MARK TWAIN", nil],
              //[NSArray arrayWithObjects:@"I'VE NEVER LET MY SCHOOLING INTERFERE WITH MY EDUCATION.", @"", @"MARK TWAIN", nil],
             //[NSArray arrayWithObjects:@"ACTION SPEAKS LOUDER THAN WORDS, BUT NOT NEARLY AS OFTEN.", @"", @"MARK TWAIN", nil],
              
  /*             [NSArray arrayWithObjects:@"ANY EMOTION, IF IT IS SINCERE, IS INVOLUNTARY.", @"", @"MARK TWAIN", nil],
              [NSArray arrayWithObjects:@"BUY LAND, THEY'RE NOT MAKING IT ANYMORE.", @"", @"MARK TWAIN", nil],
              [NSArray arrayWithObjects:@"CAULIFLOWER IS NOTHING BUT CABBAGE WITH A COLLEGE EDUCATION.", @"", @"MARK TWAIN", nil],
              [NSArray arrayWithObjects:@"A CLASSIC IS A BOOK WHICH PEOPLE PRAISE AND DON'T READ.", @"", @"MARK TWAIN", nil],
              [NSArray arrayWithObjects:@"IRON ORE CANNOT BE EDUCATED INTO GOLD.", @"", @"MARK TWAIN", nil],
              [NSArray arrayWithObjects:@"FAMILIARITY BREEDS CONTEMPT AND CHILDREN.", @"", @"MARK TWAIN", nil],
              [NSArray arrayWithObjects:@"FICTION IS OBLIGED TO STICK TO POSSIBILITIES. TRUTH ISN'T.", @"", @"MARK TWAIN", nil],
              [NSArray arrayWithObjects:@"IF YOU TELL THE TRUTH, YOU DON'T HAVE TO REMEMBER ANYTHING.", @"", @"MARK TWAIN", nil],
              [NSArray arrayWithObjects:@"MAN IS THE ONLY ANIMAL THAT BLUSHES OR NEEDS TO.", @"", @"MARK TWAIN", nil],
              [NSArray arrayWithObjects:@"NAME THE GREATEST OF ALL INVENTORS. ACCIDENT.", @"", @"MARK TWAIN", nil],
              [NSArray arrayWithObjects:@"PRINCIPLES HAVE NO REAL FORCE EXCEPT WHEN ONE IS WELL-FED.", @"", @"MARK TWAIN", nil],
              [NSArray arrayWithObjects:@"SOMETIMES TOO MUCH TO DRINK IS BARELY ENOUGH.", @"", @"MARK TWAIN", nil],
              [NSArray arrayWithObjects:@"THE MORE YOU EXPLAIN IT, THE MORE I DON'T UNDERSTAND IT.", @"", @"MARK TWAIN", nil],
              [NSArray arrayWithObjects:@"WE HAVE THE BEST GOVERNMENT THAT MONEY CAN BUY.", @"", @"MARK TWAIN", nil],
              [NSArray arrayWithObjects:@"WRINKLES SHOULD MERELY INDICATE WHERE SMILES HAVE BEEN.", @"", @"MARK TWAIN", nil],
              [NSArray arrayWithObjects:@"IT IS A MIRACLE THAT CURIOSITY SURVIVES FORMAL EDUCATION.", @"", @"ALBERT EINSTEIN", nil],
              [NSArray arrayWithObjects:@"REALITY IS MERELY AN ILLUSION, ALBEIT A VERY PERSISTENT ONE.", @"", @"ALBERT EINSTEIN", nil],
              [NSArray arrayWithObjects:@"TIME IS WHAT PREVENTS EVERYTHING FROM HAPPENING AT ONCE.", @"", @"ALBERT EINSTEIN", nil],
*/              
              [NSArray arrayWithObjects:
               @"PRESS ON THE ANSWER TO UNDO WORDS",
               @"                             UTHE     AWORERP NNNDOSTO OSWERSDS",
               @"WAS THE CORRECT ANSWER!",
               @"44,43,42,51,60,55,55,30,31,32,38,47,56,57,58,59,52,53,56,57,58,59,57,58,59,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"FIND ALL THE WORDS",
               @"                                      F    A   IW THLL  NDOREDS",
               @"WAS THE CORRECT ANSWER!",
               @"38,47,56,57,43,52,53,50,51,60,58,59,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"I AM NOT YOUNG ENOUGH TO KNOW EVERYTHING",
               @"         EYOU     VOTN     EKNG     RYOE     HTWNUGH IINGONOTAM",
               @"Oscar Wilde",
               @"53,61,62,60,61,62,12,13,14,23,32,41,50,59,60,61,62,26,25,34,35,44,53,15,24,33,42,43,52,51,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"ALL GREAT TRUTHS BEGIN AS BLASPHEMIES",
               @"             E      TBTH     RUGS     BLINALA EHPGRELS MIEASATS",
               @"George Bernard Shaw",
               @"42,43,52,49,50,51,60,61,22,31,32,33,34,43,32,33,42,51,52,60,61,42,43,44,53,52,51,50,59,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"ONE SHOULD ALWAYS PLAY FAIRLY WHEN ONE HAS THE WINNING CARDS",
               @"          TN PA  CWHEONEYAAIOAFAHSIRNESRLOUYDNHWLWALDSINHELYSNG",
               @"Oscar Wilde",
               @"21,22,23,33,32,41,42,51,52,31,40,49,50,59,60,49,58,59,60,33,34,43,42,51,52,50,59,60,61,33,34,43,51,52,61,34,43,52,24,33,42,51,60,61,62,26,35,44,53,62", nil
               ],
              [NSArray arrayWithObjects:
               @"WHENEVER PEOPLE AGREE WITH ME I ALWAYS FEEL I MUST BE WRONG",
               @"  T        RSU P    FAWWALMMWILPHEEGEITHEONEYBIEOAGEVSEWELNREER",
               @"Oscar Wilde",
               @"23,32,33,42,51,52,61,62,31,40,41,42,43,52,51,50,59,60,61,31,32,41,42,30,39,40,33,42,43,52,53,62,41,50,59,60,49,53,52,51,50,48,57,58,59,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"WORK IS THE CURSE OF THE DRINKING CLASSES",
               @"          C       SL   W   IRD  O   NAST RKISKINCTHEFOSEGURSEHE",
               @"Oscar Wilde",
               @"23,32,41,42,43,44,49,50,51,48,57,58,59,60,53,52,60,61,62,35,34,33,42,51,52,53,62,34,43,52,51,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"I CAN RESIST ANYTHING BUT TEMPTATION",
               @"                   T       MEBA    IPTUNR  CATATYESINNIONTHISTG",
               @"Oscar Wilde",
               @"35,43,44,53,40,49,50,51,60,61,31,40,49,58,59,60,61,62,35,44,53,25,34,33,42,43,52,51,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"THE TRUTH IS RARELY PURE AND NEVER SIMPLE",
               @"                  T  N     H PAIST  E UNERRUTERMERAPLHSIYLDVERE",
               @"Oscar Wilde",
               @"18,27,36,33,42,43,44,53,31,32,41,50,49,48,57,56,38,47,46,45,48,57,58,57,58,59,60,61,57,58,59,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"A MAN CANNOT BE TOO CAREFUL IN THE CHOICE OF HIS ENEMIES",
               @" I       ACA I    NAM H  E TNNCO TEOTONICAOCFHEBHIROMSENEESEFUL",
               @"Oscar Wilde",
               @"9,20,19,18,19,20,29,38,37,36,47,56,33,42,51,40,41,50,59,60,61,62,31,40,39,48,49,32,33,42,51,52,43,44,53,50,51,60,58,59,60,61,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"IT IS BETTER TO HAVE A PERMANENT INCOME THAN TO BE FASCINATING",
               @"   O      BTEI   FTEBITHTSATENNIAOCGARPESVTINTHARMENNIEMOCANEAT",
               @"Oscar Wilde",
               @"13,22,31,40,10,19,18,27,28,37,24,33,23,32,41,50,36,38,39,48,49,58,59,60,60,60,42,51,60,59,58,57,57,58,59,59,50,51,59,60,17,26,25,34,43,52,61,62,62,62,62", nil
               ],
              [NSArray arrayWithObjects:
               @"A THING IS NOT NECESSARILY TRUE BECAUSE A MAN DIES FOR IT",
               @"         NOTAN    BDMNT    EIEIHINAECFSEECGEYAUSTRSISLAORTUASRI",
               @"Oscar Wilde",
               @"34,22,31,32,33,42,51,60,10,11,12,32,41,42,43,52,51,60,61,62,62,62,51,52,61,62,23,32,41,50,51,52,53,59,34,35,44,33,42,43,52,51,60,61,53,62", nil
               ],
              [NSArray arrayWithObjects:
               @"ALL BAD POETRY SPRINGS FROM GENUINE FEELING",
               @"         G        EERA   F SNOL   LGPRILB  ENUFNDATYGSINMPOEREI",
               @"Oscar Wilde",
               @"21,30,39,40,49,48,57,58,59,59,60,60,31,40,41,42,51,52,53,34,42,51,60,32,41,42,50,59,60,61,60,60,61,61,62,62,62", nil
               ],
              [NSArray arrayWithObjects:
               @"HE WHO CAN DOES HE WHO CANNOT TEACHES",
               @"              T        E    W  HNHD OH  WOCOECA  CANTSHEHENAOES",
               @"George Bernard Shaw",
               @"56,57,30,31,41,49,50,51,34,43,44,53,56,57,49,48,47,56,57,58,50,60,52,41,50,59,60,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"THERE IS NO LOVE SINCERER THAN THE LOVE OF FOOD",
               @"              T     TOFHEIS  HLONORE  EOOLSEE TEVDIOVR HANFNCRE",
               @"George Bernard Shaw",
               @"14,23,24,34,44,34,35,32,33,41,51,52,62,51,50,59,60,52,61,53,62,50,59,60,61,33,42,51,43,52,61,60,61,62,35,44,53,62", nil
               ],
              [NSArray arrayWithObjects:
               @"THE REPORTS OF MY DEATH HAVE BEEN GREATLY EXAGGERATED",
               @"        M   E    Y  BXEDT HNEEAAHHESGGGEYTRPTEARDLAEORRTEATVOFE",
               @"Mark Twain",
               @"24,33,34,42,51,43,52,53,53,53,60,61,35,44,25,24,33,43,53,43,52,61,62,24,33,32,31,42,51,60,61,62,62,62,26,35,44,43,42,51,60,52,61,53,62", nil
               ],
              [NSArray arrayWithObjects:
               @"THERE ARE LIES DAMNED LIES AND STATISTICS",
               @"                  TS D  E  AIELI S  TTRCS EEDINASD HREASLIATMEN",
               @"Mark Twain",
               @"59,51,61,61,61,49,49,49,32,33,34,42,51,60,61,62,62,62,60,61,62,62,60,52,44,34,33,42,51,60,61,61,61,53,62", nil
               ],
              [NSArray arrayWithObjects:
               @"IVE NEVER LET MY SCHOOLING INTERFERE WITH MY EDUCATION",
               @"            I   N IE TNEEOMVWSCHLVIYEDIHOOTEECANMFLGERUYTERINTR",
               @"Mark Twain",
               @"18,27,36,22,23,33,43,53,32,33,42,35,44,29,30,31,40,41,50,59,60,60,40,49,58,59,60,60,52,62,62,33,34,43,52,61,60,43,52,60,60,61,62,62,62,62", nil
               ],
              [NSArray arrayWithObjects:
               @"ACTION SPEAKS LOUDER THAN WORDS BUT NOT NEARLY AS OFTEN",
               @"           B NTT    T UYASPLONOELNAENOURAHAKSAFDERDCTNOSEWTRSIO",
               @"MARK TWAIN",
               @"42,51,52,61,62,62,43,44,53,52,61,62,29,30,40,49,50,50,35,43,44,53,59,59,51,52,62,33,34,35,40,41,42,51,60,52,62,62,62,51,61,60,61,62,62,62", nil
               ],
              
              
              
              
              
              [NSArray arrayWithObjects:
               @"ALWAYS FORGIVE YOUR ENEMIES. NOTHING ANNOYS THEM SO MUCH.",
               @"   O     ALWA     NOSYT  F ATYHHGROGNSOINIENMNMUUEVMEHOYRSCEIES",
               @"Oscar Wilde",
               @"9,10,11,12,21,20,25,34,33,32,41,50,59,30,39,48,57,42,43,52,51,60,61,62,22,23,32,33,42,43,44,31,40,49,58,59,60,34,43,52,53,50,51,59,60,61,62", nil
               ],              
              [NSArray arrayWithObjects:
               @"THE TRUE MYSTERY OF THE WORLD IS THE VISIBLE NOT THE INVISIBLE",
               @"T        TIWTHTM  HNIOERY  EVNRIUSTEEHTLIEVYRHIODSSIOFESTBBLELE",
               @"",
               @"12,13,22,14,23,32,41,15,24,33,34,35,44,43,52,53,38,37,36,20,21,30,39,48,40,49,18,27,36,42,51,50,49,58,59,60,41,50,59,39,48,57,22,31,40,49,58,59,60,61,62", nil
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
    if(hasPlayed)
    {
        currentIndex++;
        if(currentIndex >= quotes.count)
        {
            currentIndex = 0;
        }
    }
    hasPlayed = YES;
}

+ (NSString *) getCurrentQuote
{
    return [[quotes objectAtIndex:[AnswerData getCurrentIndex]] objectAtIndex:0];
}

+ (NSString *) getCurrentSource
{
    NSString *result = @"WAS THE CORRECT ANSWER!";
    NSArray *ar = [quotes objectAtIndex:[AnswerData getCurrentIndex]];
    if(ar.count > 2)
    {
        result = [ar objectAtIndex:2];
    }
    return result;
}

+ (NSArray *) getCurrentIndexes
{
    NSArray *result;
    NSArray *ar = [quotes objectAtIndex:[AnswerData getCurrentIndex]];
    if(ar.count > 3)
    {
        NSString *s = [ar objectAtIndex:3];
        NSArray *sInts = [s componentsSeparatedByString:@","];
        int count = sInts.count;
        id nums[count];        
        
        for (int i = 0; i < count; i++) 
        {
            int num = [[sInts objectAtIndex:i] intValue];
            nums[i] = [NSNumber numberWithInt:num];
        }
        
        result = [NSArray arrayWithObjects:nums count:count];
    }
    return result;
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
