//
//  EntrustCell.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/5/3.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntrustCell : UITableViewCell
//方案名字
@property (weak, nonatomic) IBOutlet UILabel  *entrustName;
//投资期限
@property (weak, nonatomic) IBOutlet UILabel  *investTime;
//年化收益
@property (weak, nonatomic) IBOutlet UILabel  *annual;
//优惠券
@property (weak, nonatomic) IBOutlet UILabel  *amount;
//投资方式
@property (weak, nonatomic) IBOutlet UILabel  *startTime;
//投资金额
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *touzijineLB;

//@property (weak, nonatomic) IBOutlet UILabel  *entrustState;
@property (weak, nonatomic) IBOutlet UISwitch *entrustSwitch;
@property (copy, nonatomic) void(^changeStateBlock)(UISwitch *entrustSwitch);

- (void)loadInterfaceWithDictionary:(NSDictionary *)aDic;
@end
