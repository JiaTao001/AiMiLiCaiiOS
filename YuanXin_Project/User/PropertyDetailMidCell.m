//
//  PropertyDetailMidCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/7/14.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "PropertyDetailMidCell.h"

@implementation PropertyDetailMidCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithDictionary:(NSDictionary *)aDic {
    
    self.investTime.text = aDic[@"investdate"];
    self.bearingTime.text = aDic[@"interestdate"];
    self.expireTime.text = aDic[@"expire_time"];
}

@end
