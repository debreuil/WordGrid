

#import <UIKit/UIKit.h>
#import "AnswerView.h"
#import "DesignGridView.h"

@interface DesignViewController : UIViewController

@property (strong, nonatomic) IBOutlet DesignGridView *gridView;
@property (strong, nonatomic) IBOutlet AnswerView *answerView;

@end
