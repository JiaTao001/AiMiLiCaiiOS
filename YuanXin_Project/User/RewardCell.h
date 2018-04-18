//
//  RewardCell.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/15.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RewardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *rewardBakcground;
@property (weak, nonatomic) IBOutlet UILabel     *rewardExplain;
//@property (weak, nonatomic) IBOutlet UILabel     *rewardState;
//@property (weak, nonatomic) IBOutlet UILabel     *name;
@property (weak, nonatomic) IBOutlet UILabel     *time;

@property (weak, nonatomic) IBOutlet UILabel     *symbol;
@property (weak, nonatomic) IBOutlet UILabel     *money;

@property (copy, nonatomic) void(^useExperienceBlock)();

- (void)configureCellWithInfo:(NSDictionary *)aDic;
@end
