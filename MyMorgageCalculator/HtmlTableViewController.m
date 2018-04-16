//
//  HtmlTableViewController.m
//  MyMorgageCalculator
//
//  Created by  Oleg on 28.06.17.
//  Copyright © 2017  Oleg. All rights reserved.
//

#import "HtmlTableViewController.h"
#import "InputViewController.h"

@interface HtmlTableViewController ()

@property(assign, nonatomic)NSInteger months;

@property(strong, nonatomic)NSMutableArray* myDataArray;

@end

@implementation HtmlTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myDataArray=[[NSMutableArray alloc]init];
    [self.myDataArray removeAllObjects];
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkMSG:) name:@"passedNumberNotification" object:nil];
    [self calculationsMethod];
    
    
    [self getHTMLcontent];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"passedNumberNotification" object:nil];
}



-(void)checkMSG:(NSNotification*)notification{
    self.firstSumNumberString=[[notification userInfo]valueForKey:@"firstSumKey"];
    self.sumNumberString=[[notification userInfo]valueForKey:@"sumKey"];
    self.procentNumberString=[[notification userInfo]valueForKey:@"procentKey"];
    self.monthsNumberString=[[notification userInfo]valueForKey:@"monthsKey"];

    [self viewDidLoad];
}

-(void)getHTMLcontent{
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"table" ofType:@"html"];
    NSString *formattedHTML = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    NSString *rows = @"";
    
    for (NSInteger i = 0; i < self.months; i++) {
        MyData* myData=[self.myDataArray objectAtIndex:i];
        NSInteger period=myData.period;
        double mainDebt=myData.mainDebt;
        double mainDebtPaymentForMonth=myData.mainDebtPaymentForMonth;
        double percentagePaymentForMonth=myData.percentagePaymentForMonth;
        double payment=myData.payment;
        
        NSString *newRow = [self rowStringWithName:mainDebt andMainDebtPayment:mainDebtPaymentForMonth andPercentagePayment:percentagePaymentForMonth andPeriod:period andPayment:payment];
        rows = [rows stringByAppendingString:newRow];
    }
    NSString *html = [NSString stringWithFormat:formattedHTML, rows];
    
    [self.myWebView loadHTMLString:html baseURL:nil];
}

- (NSString *)rowStringWithName: (double)mainDebt andMainDebtPayment: (double)mainDebtPayment andPercentagePayment:(double) percentagePayment andPeriod:(NSInteger)period andPayment:(double)payment{
    NSString *format = @"<tr><td>%d</td><td>%.2f</td><td>%.2f</td><td>%.2f</td><td>%.2f</td></tr>\n";
    NSString *string = [NSString stringWithFormat:format, period, mainDebt, mainDebtPayment, percentagePayment, payment];
    return string;
}


-(void)calculationsMethod{
    double firstSumNumber=[self.firstSumNumberString doubleValue];
    double sumNumber=[self.sumNumberString doubleValue];
    double percentageNumber=[self.procentNumberString doubleValue];
    NSInteger monthsNumber=[self.monthsNumberString integerValue];
    long double pureSum=sumNumber-firstSumNumber;
    float creditSum=pureSum;
    
    self.months=monthsNumber;
    
    long double fraction=pureSum/monthsNumber;
    long double percentageForOneMonth=percentageNumber/12;
    long double sumWithPercentage=0;
    
    float totalSum=0.f;
    
    for(NSInteger i=0; i<monthsNumber; i++){
        MyData* myData=[[MyData alloc]init];
        long double percentagePayment=(pureSum)*percentageForOneMonth/100;
        long double paymentForMonth=fraction+(pureSum)*percentageForOneMonth/100;
        sumWithPercentage=sumWithPercentage+fraction+(pureSum)*percentageForOneMonth/100;
        
        totalSum=totalSum+paymentForMonth;
        myData.period=i+1;
        myData.mainDebt=pureSum;
        myData.mainDebtPaymentForMonth=fraction;
        myData.percentagePaymentForMonth=percentagePayment;
        myData.payment=paymentForMonth;
        [self.myDataArray addObject:myData];
        
        pureSum=pureSum-fraction;
    }
    
    [self calculateAndSendOverpaymentNumber:creditSum andSum:totalSum];

}

-(void)calculateAndSendOverpaymentNumber:(float)sum andSum:(float)sumWithPercetage{
    float resultNumber;
    resultNumber=100*(sumWithPercetage - sum);
    resultNumber=(float)resultNumber/sum;
    
    NSNumber* resultNumberNSNum=[NSNumber numberWithFloat:resultNumber];
    NSDictionary* overpayment=[NSDictionary dictionaryWithObject:resultNumberNSNum forKey:@"overpaymentKey"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"passOverpayementNotification" object:nil userInfo:overpayment];

}


@end
