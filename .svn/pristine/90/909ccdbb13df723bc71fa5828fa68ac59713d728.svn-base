//
//  AutoEntrustCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 17/2/10.
//  Copyright © 2017年 yuanxin. All rights reserved.
//

#import "AutoEntrustCell.h"

@implementation AutoEntrustCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadInterfaceWithDictionary:(NSDictionary *)aDic {
    self.planNameLB.text = aDic[@"remark"];
      self.entrustNameLB.text = aDic[@"project_name"];
      self.moneyAmountLB.text = [NSString stringWithFormat:@"%@元",aDic[@"amount"]];
      self.timeLb.text = aDic[@"created"];
    
}

@end
