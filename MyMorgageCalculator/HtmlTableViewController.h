//
//  HtmlTableViewController.h
//  MyMorgageCalculator
//
//  Created by  Oleg on 28.06.17.
//  Copyright © 2017  Oleg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyData.h"

@interface HtmlTableViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *myWebView;

@property(strong, nonatomic)NSString* firstSumNumberString;

@property(strong, nonatomic)NSString* sumNumberString;

@property(strong, nonatomic)NSString* procentNumberString;

@property(strong, nonatomic)NSString* monthsNumberString;


@end
