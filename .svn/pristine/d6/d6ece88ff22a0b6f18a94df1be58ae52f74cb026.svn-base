//
//  UserinfoHeadCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/12/25.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "UserinfoHeaderView.h"
#import "UICountingLabel.h"

#define Refresh_Prepare_Description @"松开立即刷新"
#define Refresh_Normal_Description  @"下拉即可刷新"


@interface UserinfoHeaderView ()

@property (weak, nonatomic) IBOutlet UICountingLabel    *sumProperty;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topStretchingViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView             *loginedView;
@property (weak, nonatomic) IBOutlet UIImageView             *unloginedView;
@property (weak, nonatomic) IBOutlet UILabel            *accumulatedEarnings;
@property (weak, nonatomic) IBOutlet UILabel            *availableBalance;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *secretBtn;

//充值按钮父视图距离headView底边距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewToSuperBottom;
@property (weak, nonatomic) IBOutlet UIButton *warmingBtn;

@end

@implementation UserinfoHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    NSUserDefaults*shared = [NSUserDefaults standardUserDefaults];
    //是否显示账户资金
    if ([shared boolForKey:@"is_Secret"]) {
        self.secretBtn.selected = YES;
        //        self.sumProperty.text = @"*****";
        
    }else{
        [shared setBool:NO forKey:@"is_Secret"];
        self.secretBtn.selected = NO;
        
    }
    [shared synchronize];
    
    self.loginedView.image = [UIImage imageNamed:@"userCenter_backImage"];
    //    self.loginedView.contentMode =UIViewContentModeBottom;
    self.unloginedView.image = [UIImage imageNamed:@"userCenter_backImage"];
    self.ViewToSuperBottom.constant = 5;
    self.warmingBtn.hidden = YES;
    //      self.unloginedView.contentMode =UIViewContentModeBottom;
    @weakify(self)
    [RACObserve([UserinfoManager sharedUserinfo], logined) subscribeNext:^(NSNumber *x) {
        @strongify(self)
        self.loginedView.hidden = !x.boolValue;
        self.unloginedView.hidden = x.boolValue;
        [self.warmingBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        //        if (x.boolValue && [[UserinfoManager sharedUserinfo].userInfo.user_account_status intValue] != 0) {
        //            self.ViewToSuperBottom.constant = 30;
        //            self.warmingBtn.hidden = NO;
        //        }else{
        self.ViewToSuperBottom.constant = 5;
        self.warmingBtn.hidden = YES;
        //        }
    }];
}
- (IBAction)secretBtnClicked:(UIButton *)sender {
    sender.selected  = !sender.selected;
    NSUserDefaults*shared = [NSUserDefaults standardUserDefaults];
    //是否显示账户资金
    if (sender.selected ) {
        [shared setBool:YES forKey:@"is_Secret"];
        [shared synchronize];
        self.sumProperty.text = @"*****";
         self.accumulatedEarnings.text = @"*****";
         self.availableBalance.text = @"*****";
    }else{
        [shared setBool:NO forKey:@"is_Secret"];
        [shared synchronize];
        self.sumProperty.text = [UserinfoManager sharedUserinfo].userInfo.amount;
         self.accumulatedEarnings.text = [UserinfoManager sharedUserinfo].userInfo.interest;
         self.availableBalance.text = [UserinfoManager sharedUserinfo].userInfo.balance;
        //        self.sumProperty.format = @"%.2f";
    }
    
     self.tapWarming(0);
    
}
- (void)reloadWarmingView{
    //    if ([UserinfoManager sharedUserinfo].logined && [[UserinfoManager sharedUserinfo].userInfo.user_account_status intValue] != 0) {
    //        self.ViewToSuperBottom.constant = 30;
    //        self.warmingBtn.hidden = NO;
    //    }else{
    self.ViewToSuperBottom.constant = 5;
    self.warmingBtn.hidden = YES;
    //    }
    
}
- (void)btnClicked{
    if (self.tapWarming != nil) {
        self.tapWarming([[UserinfoManager sharedUserinfo].userInfo.user_account_status intValue]);
    }
    
    
}


- (void)setStretchingHeight:(NSInteger)stretchingHeight {
    if (stretchingHeight < 0) return;
    
    _stretchingHeight = stretchingHeight;
    
    self.topStretchingViewHeight.constant = Refresh_Height + stretchingHeight;
}


- (void)setSumProperty:(UICountingLabel *)sumProperty {
    _sumProperty = sumProperty;
    //     sumProperty.format = @"%.2f";
    NSUserDefaults*shared = [NSUserDefaults standardUserDefaults];
    //是否显示账户资金
    
    if ([shared boolForKey:@"is_Secret"]) {
        
        self.sumProperty.text = @"*****";
    }else{
        
        //       sumProperty.format = @"%.2f";
    }
    
    @weakify(self)
    [RACObserve([UserinfoManager sharedUserinfo].userInfo, amount) subscribeNext:^(NSString *newAmout) {
        @strongify(self)
        
        NSUserDefaults*shared2 = [NSUserDefaults standardUserDefaults];
        if ([shared2 boolForKey:@"is_Secret"]) {
            
            self.sumProperty.text = @"*****";
            //            self.secretBtn.selected = YES;
        }else{
            self.sumProperty.text = newAmout;
            //            [self.sumProperty countFrom:self.sumProperty.text.doubleValue to:newAmout.doubleValue];
            //            sumProperty.format = @"%.2f";
            //            self.secretBtn.selected = NO;
        }
        
    }];
}

- (void)setAccumulatedEarnings:(UILabel *)accumulatedEarnings {
    _accumulatedEarnings = accumulatedEarnings;
    NSUserDefaults*shared = [NSUserDefaults standardUserDefaults];
    //是否显示账户资金
    
    if ([shared boolForKey:@"is_Secret"]) {
        
        self.accumulatedEarnings.text = @"*****";
    }else{
        
        //       sumProperty.format = @"%.2f";
    }
    
    @weakify(self)
    [RACObserve([UserinfoManager sharedUserinfo].userInfo, interest) subscribeNext:^(NSString *newInterest) {
        @strongify(self)
        NSUserDefaults*shared2 = [NSUserDefaults standardUserDefaults];
        if ([shared2 boolForKey:@"is_Secret"]) {
            
            self.accumulatedEarnings.text = @"*****";
          
        }else{
             self.accumulatedEarnings.text = newInterest;
           
        }
       
    }];
}
- (void)setAvailableBalance:(UILabel *)availableBalance {
    _availableBalance = availableBalance;
    NSUserDefaults*shared = [NSUserDefaults standardUserDefaults];
    //是否显示账户资金
    
    if ([shared boolForKey:@"is_Secret"]) {
        
        self.availableBalance.text = @"*****";
    }else{
        
        //       sumProperty.format = @"%.2f";
    }
    @weakify(self)
    [RACObserve([UserinfoManager sharedUserinfo].userInfo, balance) subscribeNext:^(NSString *newBalance) {
        @strongify(self)
        NSUserDefaults*shared2 = [NSUserDefaults standardUserDefaults];
        if ([shared2 boolForKey:@"is_Secret"]) {
            
            self.accumulatedEarnings.text = @"*****";
            
        }else{
            self.availableBalance.text = newBalance;
            
        }
        
       
    }];
}
@end

