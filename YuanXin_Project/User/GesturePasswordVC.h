//
//  GesturePasswordVC.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/22.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, GesturePasswordVCType) {
    kGesturePasswordSetting,
    kGesturePasswordAlter,
    kGesturePasswordAuth,
    kGesturePasswordAuth2
    
};

typedef NS_ENUM(NSInteger, GesturePasswordOperationType) {

    kGesturePasswordOperationSuccess,
    kGesturePasswordOperationFailure,
    kGesturePasseordOperationCancel
};

#define GESTURE_PASSWORD_STORYBOARD_ID @"GesturePasswordVC"


@interface GesturePasswordVC : BaseViewController
@property (copy, nonatomic) void(^touchID)();
@property (assign, nonatomic, readwrite) GesturePasswordVCType type;
@property (weak, nonatomic) IBOutlet UIView *markView;
@property (assign,nonatomic)BOOL isformTouchID;
@property (weak, nonatomic) IBOutlet UIView *fengeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quxiaoLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgetBtnRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *drawAgainBtnRight;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

- (void)setCompletionBlock:( void(^)(GesturePasswordVC *vc, GesturePasswordOperationType type))callBack;

- (void)authTouchId;
@end
