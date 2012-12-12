//
//  VictoryViewController.m
//  WordGrid
//
//  Created by admin on 12-10-14.
//
//

#import "VictoryViewController.h"
#import "AnswerView.h"

@interface VictoryViewController ()
-(void) onNextRound:(id)sender;
-(void) onSelectGame:(id)sender;
@end

@implementation VictoryViewController

@synthesize answerView = _answerView;
@synthesize txQuoteSource = _txQuoteSource;
@synthesize btNextRound = _btNextRound;
@synthesize btSelectGame = _btSelectGame;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self.answerView subviewDidAppear];
    
    [self.btNextRound addTarget:self action:@selector(onNextRound:)
                      forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    [self.btSelectGame addTarget:self action:@selector(onSelectGame:)
                forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
//    [self.answerView createRound];
//    [self.answerView showAllLetters];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    [self.answerView subviewDidDisappear];
    
    [self.btNextRound removeTarget:self action:@selector(onNextRound:)
                  forControlEvents:(UIControlEvents)UIControlEventTouchDown];
    
    [self.btNextRound removeTarget:self action:@selector(onSelectGame:)
                  forControlEvents:(UIControlEvents)UIControlEventTouchDown];
}

-(void) onNextRound:(id)sender
{
//    [AnswerData incrementIndex];
//    [self.navigationController popViewControllerAnimated:YES];
}
-(void) onSelectGame:(id)sender
{
//   [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
}
@end
