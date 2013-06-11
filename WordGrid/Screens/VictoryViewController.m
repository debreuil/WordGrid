//
//  VictoryViewController.m
//  WordGrid
//
//  Created by admin on 12-10-14.
//
//

#import "VictoryViewController.h"
#import "AnswerView.h"
#import "Game.h"
#import "Answer.h"

@interface VictoryViewController ()
{
    NSArray *charImages;
}
-(void) onNextRound:(id)sender;
-(void) onSelectGame:(id)sender;
-(void) setCharImage;

@end

@implementation VictoryViewController

@synthesize txQuoteBody = _txQuoteBody;
@synthesize txQuoteSource = _txQuoteSource;
@synthesize btNextRound = _btNextRound;
@synthesize btSelectGame = _btSelectGame;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        charImages = [[NSArray alloc] initWithObjects:
                      @"char_ee.png",
                      @"char_go.png",
                      @"char_hc.png",
                      @"char_margt.png",
                      @"char_mt.png",
                      @"char_mw.png",
                      @"char_ow.png",
                      @"char_suntzu.png",
                      @"char_yb.png", nil];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setCharImage];
    
    [super viewDidAppear:animated];
        
    [self.btNextRound addTarget:self action:@selector(onNextRound:)
                      forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    [self.btSelectGame addTarget:self action:@selector(onSelectGame:)
                forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    _txQuoteBody.text = [Game instance].currentAnswer.quote;
    
    float tw = _txQuoteBody.frame.size.width;
    CGSize constrainSize = CGSizeMake(tw, MAXFLOAT);
    CGSize size = [_txQuoteBody.text sizeWithFont:_txQuoteBody.font constrainedToSize:constrainSize lineBreakMode:NSLineBreakByWordWrapping];
    
    _txQuoteSource.text = [Game instance].currentAnswer.victoryBlurb;
    CGRect sf = _txQuoteSource.frame;
    _txQuoteSource.frame = CGRectMake(sf.origin.x,  _txQuoteBody.frame.origin.y + size.height + 40,
                                      sf.size.width, sf.size.height);
    
}
-(void) setCharImage
{
    NSString *src = [[Game instance].currentAnswer.victoryBlurb uppercaseString];
    NSString *path = @"char_default.png";
    if([src isEqualToString:@"OSCAR WILDE"])
    {
        path = @"char_ow.png";
    }
    else if([src isEqualToString:@"GEORGE BERNARD SHAW"])
    {
        path = @"char_default.png"; // need gbs
    }
    else if([src isEqualToString:@"MARK TWAIN"])
    {
        path = @"char_mt.png";
    }
    else if([src isEqualToString:@"SUN TSU"])
    {
        path = @"char_suntzu.png";
    }
    else if([src isEqualToString:@"ALBERT EINSTEIN"])
    {
        path = @"char_default.png"; // need ae
    }
    else if([src isEqualToString:@"AMELIA EARHART"])
    {
        path = @"char_ee.png";
    }
    else if([src isEqualToString:@"GEORGE ORWELL"])
    {
        path = @"char_go.png";
    }
    else if([src isEqualToString:@"HILLARY CLINTON"])
    {
        path = @"char_hc.png";
    }
    else if([src isEqualToString:@"MARGARET THATCHER"])
    {
        path = @"char_margt.png";
    }
    else if([src isEqualToString:@"MAE WEST"])
    {
        path = @"char_mw.png";
    }
    else if([src isEqualToString:@"YOGI BERRA"])
    {
        path = @"char_yb.png";
    }
    
    self.charImage.image = [UIImage imageNamed:path];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
        
    [self.btNextRound removeTarget:self action:@selector(onNextRound:)
                  forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    [self.btNextRound removeTarget:self action:@selector(onSelectGame:)
                  forControlEvents:(UIControlEvents)UIControlEventTouchDown];
}

-(void) onNextRound:(id)sender
{
    [[Game instance] incrementIndex];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) onSelectGame:(id)sender
{
   [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSString *s = @"";
//    s = [s stringByAppendingString:[AnswerData getCurrentSource]];
//    self.txQuoteSource.text = s;
//	
//    [self.answerView setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    BOOL result = NO;
	if (toInterfaceOrientation & UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight )
    {
        result = YES;
    }
	return result;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
@end
