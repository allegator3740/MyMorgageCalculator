//
//  ViewController.m
//  MyMorgageCalculator
//
//  Created by  Oleg on 02.06.17.
//  Copyright © 2017  Oleg. All rights reserved.
//

#import "ViewController.h"

typedef enum {
    inputPageState,
    tablePageState,
    graphPageState
}PageStateType;

typedef enum {
    zeroEntryState,
    oneEntryState,
    twoEntryState
}EntryState;

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property(assign, nonatomic) PageStateType pageState;

@property(assign, nonatomic)EntryState entry;

@property(strong, nonatomic)ViewController* inputVC;

@property(strong, nonatomic)ViewController* tableVC;

@property(strong, nonatomic)ViewController* graphVC;

@property (strong, nonatomic) IBOutlet UIImageView *imageViewForMyDollar;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageState = inputPageState;
    [self flipDollar];
    self.imageViewForMyDollar.autoresizingMask=UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;

    
    
    self.graphView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.htmlTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.inputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _inputVC=[self.storyboard instantiateViewControllerWithIdentifier:@"inputVC"];
    _tableVC=[self.storyboard instantiateViewControllerWithIdentifier:@"tableVC"];
    _graphVC=[self.storyboard instantiateViewControllerWithIdentifier:@"graphVC"];

    [self presentChildViewController:_inputVC onView:self.inputView];
    [self presentChildViewController:_tableVC onView:self.htmlTableView];
    [self presentChildViewController:_graphVC onView:self.graphView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(flippingToTableMethod) name:@"flippingControllerNotification" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(makeDollarInvisible) name:@"makeDollarInvisibleNotification" object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"flippingControllerNotification" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"makeDollarInvisibleNotification" object:nil];
}

-(void)flippingToTableMethod{
    [self showControllerForState:tablePageState];
}

- (IBAction)flipMe1:(UIButton *)sender {
    [self showControllerForState: inputPageState];
    double delayInSeconds = 0.4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.imageViewForMyDollar.alpha=1.f;
    });

}

- (IBAction)flipMe3:(UIButton *)sender {
    [self makeDollarInvisible];
    
        [self showControllerForState: graphPageState];
    self.isLandscape=[self deviceOrientationVerification];
    NSNumber* isLandscapeNumber=[NSNumber numberWithBool:self.isLandscape];
    NSDictionary* deviceOrientation=[NSDictionary dictionaryWithObject:isLandscapeNumber forKey:@"isLandscape"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"triggerGraphViewController" object:nil userInfo:deviceOrientation];
}

- (IBAction)flipMe2:(UIButton *)sender {
    [self makeDollarInvisible];
    [self showControllerForState: tablePageState];
}


#pragma mark - Supporting Methods



-(void)makeDollarInvisible{
        self.imageViewForMyDollar.alpha=0.f;
}

-(void)showControllerForState:(PageStateType)state {
    if (state == self.pageState) {return;}
    UIView *oldView = [self viewForPageState:self.pageState];
    UIView *newView = [self viewForPageState:state];
    
    newView.frame = self.contentView.bounds;
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionFlipFromLeft;
    
    [UIView transitionWithView:self.contentView duration:0.5 options:options animations:^{
        [oldView removeFromSuperview];
        [self.contentView addSubview:newView];
    } completion:^(BOOL finished) {
        self.pageState = state;
    }];
    
}

-(UIView *)viewForPageState:(PageStateType)state {
    switch (state) {
        case inputPageState:
            return self.inputView;
        case tablePageState:
            return self.htmlTableView;
        case graphPageState:
            return self.graphView;
    }
}


-(void)flipDollar{
    UIImage* sourceImage = [UIImage imageNamed:@"dol5.png"];
    
    UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake(280, 530, 80, 80)];
    self.imageViewForMyDollar=imageView;
    [self.imageViewForMyDollar setImage:sourceImage];
    [self.view addSubview:self.imageViewForMyDollar];
    
    [UIImageView animateWithDuration:2 delay:0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse |     UIViewAnimationOptionCurveEaseInOut  animations:^{
        self.imageViewForMyDollar.transform = CGAffineTransformMakeScale(-1, 1);
        
    } completion:^(BOOL finished) {
      //
    }];
    
}


#pragma mark - Appearence

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotate{
   
    if([self deviceOrientationVerification]){
        self.imageViewForMyDollar.frame=CGRectMake(580, 290, 60, 60);
    }else{
        self.imageViewForMyDollar.frame=CGRectMake(280, 530, 80, 80);
    }
    self.isLandscape=[self deviceOrientationVerification];
    NSNumber* isLandscapeNumber=[NSNumber numberWithBool:self.isLandscape];
    NSDictionary* deviceOrientation=[NSDictionary dictionaryWithObject:isLandscapeNumber forKey:@"isLandscape"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"triggerGraphViewController" object:nil userInfo:deviceOrientation];

    
    return YES;
}

-(BOOL)deviceOrientationVerification{
    if ([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft){
        return YES;
    }else{
        return NO;
    }
}

-(void)presentChildViewController:(UIViewController*)viewController onView:(UIView*)view {
    [self addChildViewController:viewController];
    [view addSubview:viewController.view];
    viewController.view.frame = view.bounds;
    [viewController didMoveToParentViewController:self];
}
-(void)removeChildViewController:(UIViewController*)viewController {
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
}

@end
