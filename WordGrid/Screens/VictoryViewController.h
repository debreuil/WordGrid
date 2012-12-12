//
//  VictoryViewController.h
//  WordGrid
//
//  Created by admin on 12-10-14.
//
//

#import <UIKit/UIKit.h>

@class AnswerView;

@interface VictoryViewController : UIViewController

@property (strong, nonatomic) IBOutlet AnswerView *answerView;
@property (strong, nonatomic) IBOutlet UIButton *btNextRound;
@property (strong, nonatomic) IBOutlet UIButton *btSelectGame;
@property (strong, nonatomic) IBOutlet UILabel *txQuoteSource;

@end
