//
//  MyData.h
//  MyMorgageCalculator
//
//  Created by  Oleg on 28.06.17.
//  Copyright © 2017  Oleg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyData : NSObject


@property(assign, nonatomic)NSInteger period;

@property(assign, nonatomic)long double mainDebt;

@property(assign, nonatomic)long double mainDebtPaymentForMonth;

@property(assign, nonatomic)long double percentagePaymentForMonth;

@property(assign, nonatomic)long double payment;

@end
