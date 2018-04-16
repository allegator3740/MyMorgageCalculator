//
//  InputViewController.h
//  MyMorgageCalculator
//
//  Created by  Oleg on 10.06.17.
//  Copyright © 2017  Oleg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HtmlTableViewController.h"

@interface InputViewController : UIViewController <UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UILabel *firstSumLabel;
@property (strong, nonatomic) IBOutlet UILabel *sumLabel;
@property (strong, nonatomic) IBOutlet UILabel *procentLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthsLabel;

@property (strong, nonatomic) IBOutlet UITextField *firstSumTextField;
@property (strong, nonatomic) IBOutlet UITextField *sumTextField;
@property (strong, nonatomic) IBOutlet UITextField *procentTextField;
@property (strong, nonatomic) IBOutlet UITextField *monthsTextField;


- (IBAction)buttonCalculateAction:(UIButton *)sender;

@end
