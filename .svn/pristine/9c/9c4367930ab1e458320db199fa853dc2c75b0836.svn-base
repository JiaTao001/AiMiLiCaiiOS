//
//  IncomeTableCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/12.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "IncomeTableCell.h"

@implementation IncomeTableCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    if ([self respondsToSelector:@selector(layoutMargins)]) {
        self.layoutMargins = UIEdgeInsetsZero;
    } else {
        self.separatorInset = UIEdgeInsetsZero;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadCellWithModel:(AccumulatedIncomeInfo *)info {
    
    if (![info isMemberOfClass:[AccumulatedIncomeInfo class]]) return;
    
    self.name.text               = info.name;
    self.periodsOfRepayment.text = info.periodqty;
    self.interest.text           = info.interest;
    self.operationTime.text      = info.repayTime;
    self.incomeState.text        = info.incomeState;
    self.incomeState.textColor   = info.incomeStateColor;
}
@end
