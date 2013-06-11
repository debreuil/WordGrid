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

@property (strong, nonatomic) IBOutlet UITextView *txQuoteBody;
@property (strong, nonatomic) IBOutlet UITextView *txQuoteSource;
@property (strong, nonatomic) IBOutlet UIButton *btNextRound;
@property (strong, nonatomic) IBOutlet UIButton *btSelectGame;
@property (strong, nonatomic) IBOutlet UIImageView *charImage;

@end
