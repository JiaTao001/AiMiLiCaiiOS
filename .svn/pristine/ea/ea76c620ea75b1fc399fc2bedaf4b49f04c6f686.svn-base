//
//  AlertViewBlock.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/9.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "AlertViewManager.h"

#import <UIKit/UIKit.h>

@interface AlertViewManager()

@property (strong, nonatomic) AlertViewManager *alterDelegate;//仅当ios-8以下才需要
@end

@implementation AlertViewManager

+ (void)showInViewController:(UIViewController *)vc
                       title:(NSString *)title
                     message:(NSString *)message
        clickedButtonAtIndex:(clickBlock)clickBlock
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *otherTitles = [[NSMutableArray alloc] init];
    
    va_list argc;
    va_start(argc, otherButtonTitles);
    
    NSString *otherString = otherButtonTitles;
    
    while ( otherString ) {
        [otherTitles addObject:otherString];
        otherString = va_arg(argc, NSString *);
    }
    va_end(argc);
    
    [self showInViewController:vc title:title message:message preferredStyle:UIAlertControllerStyleAlert clickedButtonAtIndex:clickBlock cancelButtonTitle:cancelButtonTitle otherTitles:otherTitles];
}

+ (void)showInViewController:(UIViewController *)vc
                       title:(NSString *)title
                     message:(NSString *)message
              preferredStyle:(UIAlertControllerStyle)preferredStyle
        clickedButtonAtIndex:(clickBlock ) clickBlock
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *otherTitles = [[NSMutableArray alloc] init];
    
    va_list argc;
    va_start(argc, otherButtonTitles);
    
    NSString *otherString = otherButtonTitles;
    
    while ( otherString ) {
        [otherTitles addObject:otherString];
        otherString = va_arg(argc, NSString *);
    }
    va_end(argc);
    
    [self showInViewController:vc title:title message:message preferredStyle:preferredStyle clickedButtonAtIndex:clickBlock cancelButtonTitle:cancelButtonTitle otherTitles:otherTitles];
}

+ (void)showInViewController:(UIViewController *)vc
                       title:(NSString *)title
                     message:(NSString *)message
              preferredStyle:(UIAlertControllerStyle)preferredStyle
        clickedButtonAtIndex:(clickBlock ) clickBlock
           cancelButtonTitle:(NSString *)cancelButtonTitle
                 otherTitles:(NSArray *)otherTitles
{
    if (SYSTEM_VERSION_GREATER_THAN_8) {
        [self showInViewController:vc title:title message:message clickedButtonAtIndex:clickBlock cnacelButtonTitle:cancelButtonTitle otherButtonTitles:otherTitles preferredStyle:preferredStyle];
    } else {
        if (UIAlertControllerStyleAlert == preferredStyle) {
            [self showAlertViewWithTitle:title message:message clickedButtonAtIndex:clickBlock cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherTitles];
        } else {
            [self showAlertSheetInViewController:vc Title:title message:message clickedButtonAtIndex:clickBlock cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherTitles];
        }
    }
}

//iOS8 +
+ (void)showInViewController:(UIViewController *)vc
                       title:(NSString *)title
                     message:(NSString *)message
        clickedButtonAtIndex:(clickBlock)clickBlock
           cnacelButtonTitle:(NSString *) cancelButtonTitle
           otherButtonTitles:(NSArray *)otherTitles
              preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    //取消按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (clickBlock) clickBlock(alertControler, 0);
    }];
    [alertControler addAction:cancelAction];
    
    //其他按钮
    for (NSInteger i = 0; i < otherTitles.count; ++i) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:otherTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            !clickBlock ? : clickBlock(alertControler, i + 1); //cancel button is 0;
        }];
        [alertControler addAction:action];
    }
    
    [vc presentViewController:alertControler animated:YES completion:nil];
}

//iOS7
+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
          clickedButtonAtIndex:(clickBlock)clickBlock
             cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitles:(NSArray *)otherTitles
{
    AlertViewManager *alterManager = [[AlertViewManager alloc] init];
    alterManager->_clickBlock = [clickBlock copy];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:alterManager cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    
    for (NSInteger i = 0; i < otherTitles.count; ++i) {
        [alertView addButtonWithTitle:otherTitles[i]];
    }
    alertView.cancelButtonIndex = 0;
    [alertView show];
    
    alterManager.alterDelegate = alterManager;// circular reference
}

+ (void)showAlertSheetInViewController:(UIViewController *)vc
                                 Title:(NSString *)title
                               message:(NSString *)message
                  clickedButtonAtIndex:(clickBlock)clickBlock
                     cancelButtonTitle:(NSString *)cancelButtonTitle
                     otherButtonTitles:(NSArray *)otherTitles
{
    AlertViewManager *alterManager = [[AlertViewManager alloc] init];
    alterManager->_clickBlock = [clickBlock copy];

    UIActionSheet *alertSheet = [[UIActionSheet alloc] initWithTitle:title delegate:alterManager cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    alertSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    for (NSInteger i = 0; i < otherTitles.count; ++i) {
        [alertSheet addButtonWithTitle:otherTitles[i]];
    }
    alertSheet.cancelButtonIndex = [alertSheet addButtonWithTitle:cancelButtonTitle];
    alertSheet.tag = alertSheet.cancelButtonIndex;
    
    [alertSheet showInView:vc.view];
    alterManager.alterDelegate = alterManager;// circular reference
}

#pragma mark - delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    !self->_clickBlock ? : self->_clickBlock( alertView, buttonIndex);
    
    if (self.alterDelegate) {//一定要解除掉循环引用
        @weakify(self)
        self.alterDelegate = self_weak_;
    };
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger realIndex = buttonIndex == actionSheet.cancelButtonIndex ? 0 : buttonIndex + 1; //将cancel按钮buttonIndex设置为0
    
    !self->_clickBlock ? : self->_clickBlock( actionSheet, realIndex);
    
    if (self.alterDelegate) {//一定要解除掉循环引用
        @weakify(self)
        self.alterDelegate = self_weak_;
    }
}

@end
