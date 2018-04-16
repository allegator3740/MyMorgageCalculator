//
//  GraphViewController.m
//  MyMorgageCalculator
//
//  Created by  Oleg on 10.06.17.
//  Copyright © 2017  Oleg. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController ()
@property (strong, nonatomic) IBOutlet UIView *viewForProgressBar;
@property (strong, nonatomic) IBOutlet UIView *viewForProgressBarLandscape;
@property (assign, nonatomic)float overpayment;

@end

@implementation GraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.overpayment=0.f;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateGraphViewController:) name:@"triggerGraphViewController" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setOverpaymentMethod:) name:@"passOverpayementNotification" object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"triggerGraphViewController" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"passOverpayementNotification" object:nil];
}

-(void)updateGraphViewController:(NSNotification*)notification{
    NSNumber* isLandscapeNumber=[[notification userInfo]objectForKey:@"isLandscape"];
    BOOL isLandsape=[isLandscapeNumber boolValue];
    NSLog(@"orientation = %@", isLandsape? @"landscape" : @"portrait");
    if(isLandsape == NO){
        [self.viewForProgressBar addSubview:[self createProgress]];
        [self clearingFromSubviews:self.viewForProgressBarLandscape];
    }else{

        [self.viewForProgressBarLandscape addSubview:[self createProgress]];
        [self clearingFromSubviews:self.viewForProgressBar];
    }

}

-(CircleProgressBar*)createProgress{
    float overpayment;
    if(self.overpayment != 0){
        overpayment=(float)self.overpayment/100;
    }else
        overpayment=self.overpayment;
    
    CircleProgressBar* progressBar=[[CircleProgressBar alloc]initWithFrame:CGRectMake(0, 0, 190, 190)];
    [progressBar setProgress:overpayment animated:YES duration:1.5];
    progressBar.progressBarProgressColor=[UIColor redColor];
    progressBar.progressBarWidth=10;
    progressBar.progressBarTrackColor=[UIColor blueColor];
    progressBar.hintTextColor=[UIColor blackColor];
    progressBar.hintViewBackgroundColor=[UIColor whiteColor];
    progressBar.hintViewSpacing=6;
    progressBar.backgroundColor=[UIColor clearColor];
    return progressBar;
}




-(void)clearingFromSubviews:(UIView*)viewForRemove{
    for(UIView* view in viewForRemove.subviews){
        [view removeFromSuperview];
    }
}

-(void)setOverpaymentMethod:(NSNotification*)notification{
    NSNumber* overpaymentNSNum=[[notification userInfo]objectForKey:@"overpaymentKey"];
    float overpayment=[overpaymentNSNum floatValue];
    self.overpayment=overpayment;
}


@end
