//
//  PropertyInformationCell.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "HightlightCell.h"
#import "PropertyInfo.h"

#define Property_Informatrion_Identifier @"PropertyInformationCell"

@interface PropertyInformationCell : HightlightCell

@property (weak, nonatomic) IBOutlet UILabel *timeTitle;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *sumIncome;
@property (weak, nonatomic) IBOutlet UILabel *buyTime;
@property (weak, nonatomic) IBOutlet UILabel *maturityTime;
@property (weak, nonatomic) IBOutlet UILabel *propertyState;
@property (weak, nonatomic) IBOutlet UILabel *restOfTheTime;
@property (weak, nonatomic) IBOutlet UILabel *restOfTheTimeTitle;
@property (weak, nonatomic) IBOutlet UIImageView *propertySign;

@property (assign, nonatomic) BOOL inThePayment;

- (void)loadCellWithModel:(PropertyInfo *)info;
@end
