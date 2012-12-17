//
//  SelectionViewController.h
//  WordGrid
//
//  Created by admin on 12-10-16.
//
//

#import <UIKit/UIKit.h>

@class GridView;

@interface SelectionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *txTitle;
@property (strong, nonatomic) IBOutlet GridView *gridView;

@end
