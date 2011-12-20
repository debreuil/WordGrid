#import "Tile.h"
#import "AnswerGrid.h"

@implementation AnswerGrid

int answerLength;
int answerIndex;
NSMutableArray *wordBoundries;

- (void) setup
{    
    answer = @"THE BIGGER THEY COME THE HARDER THEY FALL";
    answerWords = [answer componentsSeparatedByString: @" "];
    gw = 15;
    gh = 3;
    margin = 2;
    answerIndex = 0;
    [self createGrid];
}

- (void) createLetters
{  
    wordBoundries = [[NSMutableArray alloc] init];
    int wordIndex = 0;       
    int charIndex = 0;  
    NSString *curWord = [answerWords objectAtIndex:wordIndex];
    NSString *curLetter;   
    BOOL complete = NO;
    answerLength = 0;
    
    for (Tile* t in tiles) 
    {        
        [t setIsSelectable:NO]; 
        
        if(complete)
        {
            [t setHidden:YES];            
        }
        else
        {
            [t setHidden:NO];
            
            answerLength++;
            curLetter = [curWord substringWithRange:[curWord rangeOfComposedCharacterSequenceAtIndex:charIndex]]; 
            //[t setLetter:curLetter];
            [t setCorrectLetter:curLetter];
            [t setLetter:@""];
            
            charIndex++;
            
            if(charIndex >= [curWord length])
            {
                [wordBoundries addObject:[NSNumber numberWithInt:answerLength]];
                wordIndex++;
                charIndex = 0;
                if(wordIndex < [answerWords count])
                {
                    curWord = [answerWords objectAtIndex:wordIndex];                
                }
                else
                {
                    complete = YES;
                }                
            }                
        }             
    }
}

- (void) layoutGrid:(Boolean)useAnimation
{    
    Tile *tile = [tiles objectAtIndex:0];
    
    float spcH = tile.bounds.size.width + margin;
    float spcV = tile.bounds.size.height + margin;
    
    float l = 0;
    float t = 0;
    
    CGRect fr = CGRectMake(l, t, tile.bounds.size.width, tile.bounds.size.height);   
    
    int wordIndex = 0;       
    int charIndex = 0;  
    NSString *curWord = [answerWords objectAtIndex:wordIndex];
    BOOL complete = NO;
    
    for (tile in tiles) 
    {        
        if(!complete)
        {    
            tile.frame = fr;        
            fr.origin.x += spcH;
            charIndex++;    
            
            if(charIndex >= [curWord length])
            {
                wordIndex++;
                charIndex = 0;
                fr.origin.x += spcH / 2;
                
                if(wordIndex < [answerWords count])
                {
                    curWord = [answerWords objectAtIndex:wordIndex]; 
                    if(fr.origin.x + [curWord length] * spcH > gw * spcH)
                    {
                        fr.origin.x = l;
                        fr.origin.y += spcV;
                    }
                }
                else
                {
                    complete = YES;
                }                
            }                
        }             
    }
}

- (Tile *) getNextTile
{
    Tile * result = nil;
    if(answerIndex < answerLength)
    {
        result = [tiles objectAtIndex:answerIndex];
    }
    return result;
}

- (void) setNextTileUsingTile:(Tile *)srcTile
{    
    if(answerIndex < answerLength)
    {
        Tile *newTile = [tiles objectAtIndex:answerIndex];
        [newTile setLetter:[srcTile letter]];
        [newTile setOriginalIndex:srcTile.gridIndex];
        //[newTile setIsSelectable:YES];
        [newTile setSelected:YES];
        
        answerIndex++;
    }
}

- (Tile *) removeCurrentTile
{
    Tile *result = nil;
    if(answerIndex > 0)
    {
        result = [tiles objectAtIndex:answerIndex];
        [result setLetter:@""];
        [result setIsSelectable:NO];
        answerIndex--;
        [[tiles objectAtIndex:answerIndex] setIsSelectable:YES];
    }
    return result;
}

- (BOOL) atWordBoundry
{
    BOOL result = false;
    
    for (NSNumber *n in wordBoundries) 
    {
        
        if ([n integerValue] == answerIndex) 
        {
            result = YES;
            break;
        }
    }
    return result;
}

@end
