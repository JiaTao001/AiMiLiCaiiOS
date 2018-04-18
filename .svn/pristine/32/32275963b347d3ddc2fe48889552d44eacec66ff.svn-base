//
//  ExperienceCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/27.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "ExperienceCell.h"

@implementation ExperienceCell

- (void)configureCellWithInfo:(NSDictionary *)aDic {
    [super configureCellWithInfo:aDic];
    
    NSInteger status = [aDic[@"status"] integerValue];
    if (status == 0) {
        self.rewardBakcground.image = [UIImage imageNamed:@"exprise_backImage"];
    }
    if (status == 1) {
        self.rewardBakcground.image = [UIImage imageNamed:@"used_backImage"];
    }
    if (status == 2) {
        self.rewardBakcground.image = [UIImage imageNamed:@"overdate_backImage"];
    }
  self.money.textColor           = 0 == status ? Theme_Color : RGB(0xCCCCCC);
//    self.rewardBakcground.image = [UIImage imageNamed:0 == status ? @"exprise_backImage" : @"used_backImage"];
//    self.money.textColor         = self.rewardState.textColor;
//    self.name.textColor          = self.rewardState.textColor;
    self.symbol.textColor        = self.money.textColor;
//    self.time.textColor          = self.rewardState.textColor;
//    self.rewardExplain.textColor = self.rewardState.textColor;
}

- (NSString *)rewardStateDescriptionWithState:(NSInteger)state {
    
    switch (state) {
        case 0:
            return @"立即使用";
            break;
        case 1:
            return @"已使用";
            break;
        case 2:
            return @"已过期";
            break;
            
        default:
            return @"未定义";
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
