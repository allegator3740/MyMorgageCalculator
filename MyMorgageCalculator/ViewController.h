//
//  ViewController.h
//  MyMorgageCalculator
//
//  Created by  Oleg on 02.06.17.
//  Copyright © 2017  Oleg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)flipMe1:(UIButton *)sender;
- (IBAction)flipMe3:(UIButton *)sender;
- (IBAction)flipMe2:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIView *inputView;
@property (strong, nonatomic) IBOutlet UIView *htmlTableView;
@property (strong, nonatomic) IBOutlet UIView *graphView;
@property (strong, nonatomic) IBOutlet UIView *dollarView;

@property(assign, nonatomic) BOOL isLandscape;



@end

