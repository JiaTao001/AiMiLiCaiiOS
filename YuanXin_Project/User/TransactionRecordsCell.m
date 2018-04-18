//
//  TransactionRecordsCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/13.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "TransactionRecordsCell.h"



@implementation TransactionRecordsCell

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

- (void)loadCellWithModel:(TransactionRecordsInfo *)info {
    
    if (![info isMemberOfClass:[TransactionRecordsInfo class]])
        return;
    
    self.typeName.text = info.type;
    self.money.text = info.money;
    self.operationTime.text = info.created;
    
    
    self.tradeState.text = info.status;
    self.tradeState.textColor = [info statusColor];//[info.status isEqualToString:Trade_Success] ? Normal_Green : [info.status isEqualToString:Trade_Failure] ? Theme_Color : RGB(0x666666);
    
}
@end
