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
              
              /*
               [NSArray arrayWithObjects:@"THE MORE YOU EXPLAIN IT, THE MORE I DON'T UNDERSTAND IT.", @"", @"MARK TWAIN", nil],
               [NSArray arrayWithObjects:@"WRINKLES SHOULD MERELY INDICATE WHERE SMILES HAVE BEEN.", @"", @"MARK TWAIN", nil],
               [NSArray arrayWithObjects:@"IT IS A MIRACLE THAT CURIOSITY SURVIVES FORMAL EDUCATION.", @"", @"ALBERT EINSTEIN", nil],
               // (no space)
               [NSArray arrayWithObjects:@"FICTION IS OBLIGED TO STICK TO POSSIBILITIES. TRUTH ISN'T.", @"", @"MARK TWAIN", nil],
               [NSArray arrayWithObjects:@"TIME IS WHAT PREVENTS EVERYTHING FROM HAPPENING AT ONCE.", @"", @"ALBERT EINSTEIN", nil],
               */
              
              [NSArray arrayWithObjects:
               @"FIND ALL THE WORDS",
               @"                                       WO R     THFIND   ALLEDS",
               @"WAS THE CORRECT ANSWER!",
               @"50,51,52,53,57,58,59,58,59,60,58,59,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"PRESS ON LOWER PANEL TO REVERT TILES",
               @"                           PRESS    ONOREVE  PTELTILRTANLOWERES",
               @"WAS THE CORRECT ANSWER!",
               @"27,28,29,30,31,36,37,56,57,58,59,60,45,54,55,56,57,55,56,57,49,50,51,52,53,58,59,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"LETTERS CAN JOIN DIAGONALLY TOO",
               @"            L J      DEO      ICT  O   AAITOY   GNNTES   ONALLR",
               @"WAS THE CORRECT ANSWER!",
               @"12,22,32,42,52,62,53,31,40,49,23,32,41,50,21,30,39,48,57,58,59,60,61,62,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"WORK IS THE CURSE OF THE DRINKING CLASSES",
               @"          C       SL   W   IRD  O   NAST RKISKINCTHEFOSEGURSEHE",
               @"Oscar Wilde",
               @"23,32,41,42,43,44,49,50,51,48,57,58,59,60,53,52,60,61,62,35,34,33,42,51,52,53,62,34,43,52,51,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"I CAN RESIST ANYTHING BUT TEMPTATION",
               @"                   MA  C    NE RUAN  YTSEITT  PAHISTO  TTBINGIN",
               @"Oscar Wilde",
               @"41,32,33,34,31,40,39,49,50,51,20,28,37,38,48,58,59,60,58,59,60,43,42,41,50,59,51,60,61,52,62", nil
               ], 
              [NSArray arrayWithObjects:
               @"ALL GREAT TRUTHS BEGIN AS BLASPHEMIES",
               @"            B        LG       AERB  LLASGEE  TTHPIMIATRUSHNASES",
               @"George Bernard Shaw",
               @"38,37,36,22,32,42,52,53,45,54,55,46,47,56,42,41,40,49,58,59,60,12,21,30,39,48,57,58,59,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"I AM NOT YOUNG ENOUGH TO KNOW EVERYTHING",
               @"                           VE U I TARENUYONKMYHGOOGOEOTITWNHNNG",
               @"Oscar Wilde",
               @"32,35,44,58,48,56,49,58,48,47,56,52,42,41,49,50,59,43,53,52,61,51,59,33,32,42,41,50,59,51,60,61,62", nil
               ],
              
              [NSArray arrayWithObjects:
               @"THE REPORTS OF MY DEATH HAVE BEEN GREATLY EXAGGERATED",
               @"              A E OFD TR EMHAVEHBSTYGAGEEETTHGRXERERALEATNEPODY",
               @"Mark Twain",
               @"22,31,40,49,58,59,60,51,42,33,20,21,26,35,22,32,24,34,44,29,30,31,41,42,51,50,59,41,51,60,52,43,53,62,44,52,42,41,50,59,51,60,61,53,62", nil
               ],              
                           
              [NSArray arrayWithObjects:
               @"THE TRUTH IS RARELY PURE AND NEVER SIMPLE",
               @"                S  NT    I  RP  EUM TUVTHIRP HEDRRSRL ANEAELYEE",
               @"Oscar Wilde",
               @"39,40,32,20,28,37,36,45,41,50,48,57,49,58,59,60,32,42,51,61,57,58,50,49,58,50,59,60,25,34,43,52,61,62", nil
               ],              
              [NSArray arrayWithObjects:
               @"A MAN CANNOT BE TOO CAREFUL IN THE CHOICE OF HIS ENEMIES",
               @"          E       NNAMANE AOOBCFNIHTTTEUFEOECNMOLCIRHHEIOESISAC",
               @"Oscar Wilde",
               @"26,21,22,23,30,20,19,18,27,36,29,38,37,47,56,62,61,51,41,31,39,48,50,41,44,43,52,53,61,51,59,49,57,41,51,62,52,60,43,51,60,52,61,53,62", nil
               ],              
              [NSArray arrayWithObjects:
               @"IT IS BETTER TO HAVE A PERMANENT INCOME THAN TO BE FASCINATING",
               @"          I TO AITTASTGHMVEOANANNERPBNHBIARNEFEIETTEOTASCTINCME",
               @"Oscar Wilde",
               @"16,17,10,20,39,48,49,50,51,42,18,27,32,33,25,26,28,35,44,34,42,50,41,51,43,53,49,59,60,52,61,62,43,42,32,41,43,35,40,50,49,58,59,60,51,42,52,61,62,53,44", nil
               ],     
              [NSArray arrayWithObjects:
               @"A THING IS NOT NECESSARILY TRUE BECAUSE A MAN DIES FOR IT",
               @"    B       FTEC  A  STAS  IRAOIHNISLRTSEUIOTYAUISAENNNDEMRECEG",
               @"Oscar Wilde",
               @"18,22,32,42,52,62,43,44,42,52,53,62,61,60,59,49,39,29,28,27,36,45,40,39,49,58,24,34,44,43,52,53,62,62,61,51,59,60,61,53,43,52,61,62,62,53", nil
               ],
              [NSArray arrayWithObjects:
               @"ALL BAD POETRY SPRINGS FROM GENUINE FEELING",
               @"                  A  I  E  LLFNOET  BGEPFSGRSAEEIRPRYGDNULOMNIN",
               @"Oscar Wilde",
               @"18,28,27,36,45,54,39,31,32,33,43,52,41,50,51,61,62,53,44,42,51,60,61,41,50,59,60,52,43,44,42,51,60,61,52,62,53", nil
               ],
              [NSArray arrayWithObjects:
               @"HE WHO CAN DOES HE WHO CANNOT TEACHES",
               @"          E        H       DO       HEEWW HHEAESNHOCOTCCANNAOTS",
               @"George Bernard Shaw",
               @"43,44,40,49,50,51,59,58,29,30,40,49,38,39,41,51,52,57,58,50,59,60,61,53,43,51,60,52,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"THERE IS NO LOVE SINCERER THAN THE LOVE OF FOOD",
               @"              S     F  N   HTFE CEREANTHTHIINLVODVOSROOOEOEELER",
               @"George Bernard Shaw",
               @"40,41,33,34,35,42,51,44,53,60,50,49,58,33,43,42,51,60,52,61,62,33,32,41,42,43,44,35,50,59,51,61,60,52,52,61,62,53", nil
               ],    
              [NSArray arrayWithObjects:
               @"THERE ARE LIES DAMNED LIES AND STATISTICS",
               @"          S        T        ATTSL L AEHAEDIESRIRTNIANDESEICDMSE",
               @"Mark Twain",
               @"29,38,37,47,56,37,46,55,32,42,43,44,41,51,60,52,62,53,53,52,42,33,41,51,61,23,32,41,42,50,59,51,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"ONE SHOULD ALWAYS PLAY FAIRLY WHEN ONE HAS THE WINNING CARDS",
               @" R        ONS  A  AWEASHNGCLHAWFOUNEEHYHAIYLDWPSAERLONINLTYNDIS",
               @"Oscar Wilde",
               @"10,11,20,22,23,32,33,43,44,18,27,19,29,38,47,46,56,48,58,40,49,41,50,51,42,39,48,58,59,52,53,44,49,50,41,59,49,39,49,58,59,51,61,52,43,53,52,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"WHENEVER PEOPLE AGREE WITH ME I ALWAYS FEEL I MUST BE WRONG",
               @"         WB WOP   HE APELR AFNVEEYAIGREWLRSTGMWEEIEEENUSEIMTHLO",
               @"Oscar Wilde",
               @"9,18,19,29,38,30,31,41,23,32,22,31,40,41,27,36,37,47,56,39,49,59,60,58,59,35,34,33,32,41,42,51,40,50,60,61,60,50,59,60,52,51,61,60,61,62,53,44", nil
               ],
              [NSArray arrayWithObjects:
               @"I'VE NEVER LET MY SCHOOLING INTERFERE WITH MY EDUCATION",
               @"I        V  Y     EE OTENM DINIVHOHGWATESELNNUIRRCOLIECTETFMYER",
               @"Mark Twain",
               @"0,9,18,24,23,31,39,47,51,41,31,59,60,40,49,50,59,51,60,52,44,35,30,40,49,58,50,60,61,62,53,41,51,61,53,53,43,42,41,50,59,51,60,61,52,62", nil
               ],
              [NSArray arrayWithObjects:
               @"ACTION SPEAKS LOUDER THAN WORDS BUT NOT NEARLY AS OFTEN",
               @"         ITA      OOC LAEHNNFS KATPAWODSOEBTSNTRUEOULYEANDRRTSN",
               @"MARK TWAIN",
               @"11,20,10,9,18,27,44,34,24,23,31,39,31,40,48,57,49,58,33,34,44,35,38,39,49,40,31,42,51,43,58,50,60,49,58,59,60,52,53,51,61,42,51,60,61,62", nil
               ],                      
              [NSArray arrayWithObjects:
               @"ALWAYS FORGIVE YOUR ENEMIES NOTHING ANNOYS THEM SO MUCH",
               @"          Y  AE MA O FNEAWL IGOMIYUSVNUROESEMENNRHSGSOTHOTYINCH",
               @"Oscar Wilde",
               @"17,26,25,24,33,42,21,30,39,29,28,36,45,19,28,38,48,14,22,23,31,32,41,50,47,56,57,49,59,60,51,42,41,50,51,60,52,59,60,52,44,44,53,43,52,61,62", nil
               ],              
              [NSArray arrayWithObjects:
               @"THE TRUE MYSTERY OF THE WORLD IS THE VISIBLE NOT THE INVISIBLE",
               @"          N  ESTITIVTONTHHRTWHFLMEEUIOOEBEYLETHRLISSERSIDVEITBY",
               @"",
               @"15,24,33,17,26,35,44,32,42,51,60,52,53,62,23,32,22,31,41,30,40,49,50,58,26,25,34,35,43,59,51,52,61,62,53,44,35,43,51,42,52,62,42,43,52,51,60,61,62,53,44", nil
               ],
              [NSArray arrayWithObjects:
               @"A LEADER LEADS BY EXAMPLE NOT BY FORCE",
               @"                   F        CN   LADOBO  EEASREYAALXMEYBEDERTPL",
               @"Sun Tsu",
               @"48,50,41,49,57,58,59,33,42,34,35,44,58,57,59,51,43,52,61,62,53,43,52,62,52,62,44,52,61,53,62", nil
               ],
              [NSArray arrayWithObjects:
               @"TO KNOW YOUR ENEMY YOU MUST BECOME YOUR ENEMY",
               @"            YUT      OCSEWB   ERUOOY   NEMMNE  YENUOKMTOOUREMYY",
               @"Sun Tsu",
               @"54,55,52,43,34,25,47,56,57,58,57,58,59,60,61,62,61,60,60,51,42,33,35,43,42,52,61,53,33,42,43,52,51,60,61,62,53", nil
               ],
              [NSArray arrayWithObjects:
               @"OPPORTUNITIES MULTIPLY AS THEY ARE SEIZED",
               @"                  OP   S A SPORTI Y AEINUE E TEITULIPYRHESMZTDL",
               @"Sun Tsu",
               @"18,19,28,29,30,31,40,39,38,48,47,56,57,58,49,50,60,51,52,62,53,35,34,50,60,52,44,50,59,60,59,60,52,61,53,62", nil
               ],
              [NSArray arrayWithObjects:
               @"ALL WARFARE IS BASED ON DECEPTION",
               @"              D        C        O E A BWAA N LPERFOENDLTIISARSE",
               @"Sun Tsu",
               @"36,45,54,39,40,48,49,59,60,51,58,59,41,51,61,62,53,61,62,43,53,52,51,50,59,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"TO A SURROUNDED ENEMY YOU MUST LEAVE A WAY OF ESCAPE",
               @"                 E EDOTYUSS DNNURELC EOEORAYA AVOMUUFPAWATYSEME",
               @"Sun Tsu",
               @"22,21,54,25,24,32,41,40,31,30,20,19,28,37,29,39,49,58,41,49,50,61,51,59,58,43,42,51,50,60,50,59,60,52,60,61,17,26,35,44,53,62", nil
               ],
              
              [NSArray arrayWithObjects:
               @"PRETEND INFERIORITY AND ENCOURAGE HIS ARROGANCE",
               @"      S  P     A  RE E DE  RRTANFI  OIDNENUTYHAECIRIREGNNOORCAG",
               @"Sun Tsu",
               @"9,18,19,29,21,31,23,33,41,32,40,50,49,58,59,51,43,44,32,41,40,49,58,50,59,51,52,61,62,53,51,43,35,44,43,42,51,60,52,61,62,53", nil
               ],
              [NSArray arrayWithObjects:
               @"BUILD YOUR OPPONENT A GOLDEN BRIDGE TO RETREAT ACROSS",
               @"            TAT   GENNCS O OYERRTAT BOUDERBAEUDLROSOIGLINOPPRED",
               @"Sun Tsu",
               @"36,45,55,47,39,37,46,47,39,51,59,58,57,56,46,38,30,42,36,45,54,55,56,48,51,60,52,62,53,44,25,35,59,51,43,52,62,53,44,34,43,52,61,53,62", nil
               ],
              [NSArray arrayWithObjects:
               @"BUY LAND THEY ARE NOT MAKING IT ANYMORE",
               @"            A TY     ENGE     MONH    NRATABU  YIKRLAY  MOTIEND",
               @"MARK TWAIN",
               @"43,44,53,51,52,61,62,43,44,35,26,53,52,62,25,34,35,33,43,52,62,53,44,52,62,35,43,52,61,62,53,44", nil
               ],
              [NSArray arrayWithObjects:
               @"SOMETIMES TOO MUCH TO DRINK IS BARELY ENOUGH",
               @"       A       BR       ON   L SHEGK TOMOSEINOMYEIEUHIOTUTMCDRS",
               @"MARK TWAIN",
               @"31,40,39,48,57,49,58,50,41,39,47,56,48,58,59,50,58,50,60,61,53,44,35,52,62,25,26,35,43,51,60,52,44,43,61,53,62", nil
               ],              
              [NSArray arrayWithObjects:
               @"ANY EMOTION IF IT IS SINCERE IS INVOLUNTARY",
               @"                   R IY  I AN FSY T TOISUNAE VIINEEOINNISCLMTRO",
               @"MARK TWAIN",
               @"42,41,32,50,59,51,60,52,62,53,24,33,35,44,41,42,59,50,51,60,52,62,53,52,44,61,60,51,52,62,53,43,42,33,34,44", nil
               ],
              [NSArray arrayWithObjects:
               @"CAULIFLOWER IS NOTHING BUT CABBAGE WITH A COLLEGE EDUCATION",
               @"   E    H  FDN   TOLCIOACSIWEOULUCIWNRGCIABEAOHNLTBUGETILAEBATG",
               @"MARK TWAIN",
               @"24,23,32,31,21,11,19,18,27,28,37,34,25,36,45,54,46,55,47,38,59,51,61,42,50,59,51,60,61,52,35,26,17,8,44,41,50,59,51,61,62,53,25,34,43,52,61,62,53,44,35", nil
               ],
              [NSArray arrayWithObjects:
               @"A CLASSIC IS A BOOK WHICH PEOPLE PRAISE AND DONT READ",
               @"             AEDI   DOELTSI  DNPHBAS  SRCPAOPASWANRAOEICHILCOKE",
               @"MARK TWAIN",
               @"45,59,58,48,38,46,54,55,16,25,34,33,43,52,61,48,57,58,50,42,44,53,61,51,42,33,50,60,52,44,53,62,43,51,59,59,51,61,53,60,61,62,53", nil
               ],
              [NSArray arrayWithObjects:
               @"IRON ORE CANNOT BE EDUCATED INTO GOLD",
               @"                               E IODIRODNOTTLERNNCTAEOCAOUBENDG",
               @"MARK TWAIN",
               @"36,37,38,47,56,46,45,55,56,48,40,41,50,58,59,50,49,58,59,51,42,52,61,51,60,61,53,62,61,53,44", nil
               ],
              [NSArray arrayWithObjects:
               @"FAMILIARITY BREEDS CONTEMPT AND CHILDREN",
               @"             A        H C  FAMOC D NAIIEE NPTRYLRIDLMEITBNTSEDR",
               @"MARK TWAIN",
               @"27,28,29,38,47,37,36,45,54,55,46,56,48,39,40,50,59,41,49,58,59,60,52,43,44,41,51,61,43,51,60,61,52,62,53,44", nil
               ],
              [NSArray arrayWithObjects:
               @"IF YOU TELL THE TRUTH YOU DONT HAVE TO REMEMBER ANYTHING",
               @"         I   Y    FRDEVOAT LOEOYURNYLEMOTATTGNETBEUHHNTMUHTRHIE",
               @"MARK TWAIN",
               @"9,18,13,23,32,47,37,36,27,42,52,62,34,42,50,58,57,40,48,56,38,37,45,54,60,50,40,39,49,48,37,46,55,47,56,57,58,59,51,43,44,52,60,61,62,53", nil
               ],
              [NSArray arrayWithObjects:
                  @"MAN IS THE ONLY ANIMAL THAT BLUSHES OR NEEDS TO",
                  @" NTE      THH      OSO     TDNNS   LEHLAI   AEBAYESI MLURTONAMS",
                  @"MARK TWAIN",
                  @"61,60,59,61,60,5,14,6,24,32,41,51,51,42,43,53,44,35,30,40,50,60,49,57,58,50,60,52,62,51,61,43,51,60,61,53,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"NAME THE GREATEST OF ALL INVENTORS ACCIDENT",
               @"                  G A   T  REOT  ENTAFEIEHAAEICCSDONLMNVTNTERSL",
               @"MARK TWAIN",
               @"51,43,53,44,33,41,42,18,27,28,20,30,40,48,56,38,37,51,52,62,45,54,55,47,57,58,50,60,61,55,56,57,58,59,60,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"PRINCIPLES HAVE NO REAL FORCE EXCEPT WHEN ONE IS WELL-FED",
               @"          PRL L W LII-EFTE PCNFVAHS NESEOEPNNOALREEWHEREXCCIODE",
               @"MARK TWAIN",
               @"10,11,20,29,28,19,27,18,37,38,33,32,31,22,36,45,54,55,46,47,30,40,48,58,49,49,57,58,50,42,33,51,52,53,44,60,52,62,61,53,44,53,43,51,60,52,61,62", nil
               ],
              [NSArray arrayWithObjects:
               @"WE HAVE THE BEST GOVERNMENT THAT MONEY CAN BUY",
               @"          TC       GE    TB OHH  AHU VNRAETEYWMEBVTMTNEOAESNENY",
               @"MARK TWAIN",
               @"45,54,30,40,49,41,25,34,43,48,57,58,50,20,29,38,48,58,59,51,60,61,52,41,42,52,61,51,60,52,43,44,52,61,53,44,53,62", nil
               ],              
              [NSArray arrayWithObjects:
               @"REALITY IS MERELY AN ILLUSION ALBEIT A VERY PERSISTENT ONE",
               @"          I    ELYYTIMERIPESAILLBENNNSEAAISORVTYILETSTEROLAURNE",
               @"ALBERT EINSTEIN",
               @"60,50,40,30,20,19,18,19,27,30,31,32,24,16,17,28,36,48,57,49,59,51,33,43,35,58,49,50,51,59,60,60,49,58,59,51,34,35,44,52,42,50,59,51,61,53,60,61,62", nil
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
