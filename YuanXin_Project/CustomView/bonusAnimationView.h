//
//  bonusAnimationView.h
//  YuanXin_Project
//
//  Created by Yuanin on 2017/4/25.
//  Copyright © 2017年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bonusAnimationView : UIImageView
@property (strong,nonatomic)UIButton *bonusBtn;
@property (strong,nonatomic)UIButton *cancleBtn;
@property (strong,nonatomic)UIButton *shareBtn;
@property (copy, nonatomic) void(^ShareBlock)();
- (void)showInView:(UIView *)view clickImage:(void(^)())click;
- (void)dissMiss;
@end
