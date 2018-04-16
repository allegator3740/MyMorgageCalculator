//
//  InputViewController.m
//  MyMorgageCalculator
//
//  Created by  Oleg on 10.06.17.
//  Copyright © 2017  Oleg. All rights reserved.
//

#import "InputViewController.h"
#import "MyData.h"
#import <FCAlertView/FCAlertView.h>

@interface InputViewController ()

@property(strong, nonatomic)UIAlertController* alert;

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLabelsText];
    
}


-(void)setLabelsText{
    self.firstSumLabel.lineBreakMode=NSLineBreakByWordWrapping;
    self.firstSumLabel.numberOfLines=0;
    self.firstSumLabel.text=[NSString stringWithFormat:@"%@ \n%@", @"Первонач.", @"взнос"];
    self.firstSumLabel.font=[UIFont fontWithName:@"Arial" size:16];
    self.sumLabel.text=@"Сумма";
    self.procentLabel.text=@"Процент";
    self.monthsLabel.lineBreakMode=NSLineBreakByWordWrapping;
    self.monthsLabel.numberOfLines=0;
    self.monthsLabel.text=[NSString stringWithFormat:@"%@ \n%@", @"Количество", @"месяцев"];
    self.monthsLabel.font=[UIFont fontWithName:@"Arial" size:16];
    
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isEqual:self.firstSumTextField]){
        [self.sumTextField becomeFirstResponder];
    }
    if([textField isEqual:self.sumTextField]){
        [self.procentTextField becomeFirstResponder];
    }
    if ([textField isEqual:self.procentTextField]) {
        [self.monthsTextField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString* resultString=[textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet* myCharacter=[[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    
    NSString* characterString=@"0123456789.";
    NSCharacterSet* characterForProcentTextfield=[[NSCharacterSet characterSetWithCharactersInString:characterString]invertedSet];
    NSArray* array=[string componentsSeparatedByCharactersInSet:myCharacter];
    NSArray* array2=[string componentsSeparatedByCharactersInSet:characterForProcentTextfield];
    
    
    if([array count]>1){
        if([textField isEqual:self.procentTextField]){
            if([array2 count]>1){
                return NO;
            }else{
                return [resultString length]<=4;
            }
        }
        return NO;
    }
    
    if([textField isEqual:self.firstSumTextField]){
        return [resultString length]<=10;
    }
    if([textField isEqual:self.sumTextField]){
        return [resultString length]<=10;
    }
    if([textField isEqual:self.procentTextField]){
        if([array2 count]>1){
            return NO;
        }else{
            return [resultString length]<=3;
        }
    }
    if([textField isEqual:self.monthsTextField]){
        return [resultString length]<=3;
    }
    
    
    return YES;
}

- (IBAction)buttonCalculateAction:(UIButton *)sender {
    if([self constraintsCheckUp]){
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"makeDollarInvisibleNotification" object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"flippingControllerNotification" object:nil];
    NSDictionary* myPassedDictionary=[NSDictionary dictionaryWithObjectsAndKeys:self.firstSumTextField.text, @"firstSumKey", self.sumTextField.text, @"sumKey", self.procentTextField.text, @"procentKey", self.monthsTextField.text, @"monthsKey",  nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"passedNumberNotification" object:nil userInfo:myPassedDictionary];
    }
}

-(BOOL)constraintsCheckUp{
    NSInteger firstSumNumber=[self.firstSumTextField.text integerValue];
    NSInteger sumNumber=[self.sumTextField.text integerValue];
    
    if([self.procentTextField.text length] == 0 || [self.firstSumTextField.text length] == 0 || [self.sumTextField.text length] == 0 || [self.monthsTextField.text length] == 0){
        [self notAllFieldsAreFilled];
        return NO;
    }
    if(firstSumNumber >= sumNumber){
        [self firstSumMoreThenSum];
        return NO;
    }
   
    return YES;
}

-(void)firstSumMoreThenSum{
    FCAlertView *alert = [[FCAlertView alloc] init];
    UIImage* bellImage=[UIImage imageNamed:@"bell-7.png"];
    [alert showAlertInView:self
                 withTitle:@"Ошибка ввода!"
              withSubtitle:@"Стоимость квартиры не может быть меньше или равна первоначальному взносу. Введите правильное число."
           withCustomImage:bellImage
       withDoneButtonTitle:nil
                andButtons:nil];
}

-(void)notAllFieldsAreFilled{
    FCAlertView *alert = [[FCAlertView alloc] init];
    UIImage* bellImage=[UIImage imageNamed:@"bell-7.png"];
    [alert showAlertInView:self
                 withTitle:@"Ошибка ввода!"
              withSubtitle:@"Не все поля ввода заполнены. Исправьте и попробуйте еще раз."
           withCustomImage:bellImage
       withDoneButtonTitle:nil
                andButtons:nil];
}



@end
