//
//  HKWebVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 2017/5/11.
//  Copyright © 2017年 yuanxin. All rights reserved.
//

#import "HKWebVC.h"
#import "BaseIndicatorView.h"
#import "SpringAlertView.h"
#import "UserinfoManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NetworkContectManager.h"
#import "NSString+ExtendMethod.h"


@interface HKWebVC ()<UIWebViewDelegate>
@property(strong, nonatomic) NSURLSessionTask *task;
@end

@implementation HKWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

//    NSLog(@"%@",request);
    
    if ([request.URL.path isEqualToString:@"/html/ios.html"]) {
         [SpringAlertView showMessage:@"操作成功"];
        [self fetchAccountInfo];
        if (self.isbackRoot) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
        [self.navigationController popViewControllerAnimated:YES];
            if (self.FinishBlock) {
                self.FinishBlock();
            }
        }

    }
    if ([request.URL.path isEqualToString:@"/html/ios_error.html"]) {
         [SpringAlertView showMessage:@"操作失败"];
        [self fetchAccountInfo];
       
        if (self.isbackRoot) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
            if (self.FinishBlock) {
                self.FinishBlock();
            }
        }

        
    }
    return YES;
}
- (void)fetchAccountInfo {
    if (![UserinfoManager sharedUserinfo].logined) {
        return;
    }
    
  
//    @weakify(self)
    self.task = [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationAccountInfo params:nil success:^(id result) {
//        @strongify(self)
       
    } failure:^(id result, NSString *errorDescription) {
//        @strongify(self)
    }];
}



@end
