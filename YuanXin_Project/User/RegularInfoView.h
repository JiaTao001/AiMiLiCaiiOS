//
//  RegularInfoView.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/5/3.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegularInfoView : UIView


@property (weak, nonatomic) IBOutlet UIView *view;

@property (weak, nonatomic) IBOutlet UILabel *regularName;
@property (weak, nonatomic) IBOutlet UILabel *lockPeriod;
@property (weak, nonatomic) IBOutlet UILabel *annualInterest;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;

- (void)loadInterfaceWithDictionary:(NSDictionary *)aDic;
@end
