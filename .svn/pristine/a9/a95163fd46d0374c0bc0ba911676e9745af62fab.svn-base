//
//  SettingSwitchCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/7/11.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "SettingSwitchCell.h"

@implementation SettingSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if ([self respondsToSelector:@selector(layoutMargins)]) {
        self.layoutMargins = UIEdgeInsetsZero;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)changeTheOn:(UISwitch *)sender {
    if (self.switchChange) {
        self.switchChange(sender);
    }
    
//    !self.switchChange ? :self.switchChange(sender);
}

@end
