//
//  BankCardCell.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/7/12.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBankCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bankCardLogo;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
//@property (weak, nonatomic) IBOutlet UILabel *bankType;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNumber;
@property (weak, nonatomic) IBOutlet UIButton *unbindButton;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLB;
@property (weak, nonatomic) IBOutlet UIButton *phoneChangeBtn;

- (void)configureCellWithDictionary:(NSDictionary *)aDic;

@property (copy, nonatomic) void(^unbindBankCard)(NSInteger i);
@end
