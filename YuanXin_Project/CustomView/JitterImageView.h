//
//  JitterImageView.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/7/14.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Have_Red_Key @"is_red"

@interface JitterImageView : UIImageView

- (void)showInView:(UIView *)view withAnimation:(BOOL)isAni clickImage:(void(^)())click;
@end
