//
//  SinaWebVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/7/6.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "SinaWebVC.h"
#import "AuthenticationVC.h"
#import "BindBankCardVC.h"
#import "UIWebView+TS_JavaScriptContext.h"

@interface SinaWebVC () <TSWebViewDelegate>

@property (strong, nonatomic) NSURLSessionTask *task;

@property (strong, nonatomic) JSContext *jsContext;
@property (strong, nonatomic) NSDictionary *params;
@property (assign,nonatomic)BOOL isFromStradPasswordVC;
@property (copy, nonatomic) NSString *serverPath;
@property (copy, nonatomic) void(^success)();
@end

@implementation SinaWebVC

+ (UINavigationController *)sinaWebWithServerPath:(NSString *)serverPath params:(NSDictionary *)params {
    
    return [[self class] sinaWebWithServerPath:serverPath params:params success:nil];
}

+ (UINavigationController *)sinaWebWithServerPath:(NSString *)serverPath params:(NSDictionary *)params  success:(void(^)())success{
    
    SinaWebVC *sinaVC = [[SinaWebVC alloc] init];
    sinaVC.serverPath = serverPath;
    sinaVC.params = params;
    sinaVC.success = success;
    sinaVC.isFromStradPasswordVC = NO;
    
    UINavigationController *result = [[UINavigationController alloc] initWithRootViewController:sinaVC];
    result.navigationBar.barTintColor = Theme_Color;
    result.navigationBar.translucent  = NO;
    
    return result;
}
+ (UIViewController *)sinaWebVCWithServerPath:(NSString *)serverPath params:(NSDictionary *)params  success:(void(^)())success{
    
    SinaWebVC *sinaVC = [[SinaWebVC alloc] init];
    sinaVC.serverPath = serverPath;
    sinaVC.params = params;
    sinaVC.success = success;
    if ([serverPath isEqualToString: @"set_sina_withhold_authority"]) {
        sinaVC.isFromStradPasswordVC = YES;

    }else{
    sinaVC.isFromStradPasswordVC = NO;
    }
//    UINavigationController *result = [[UINavigationController alloc] initWithRootViewController:sinaVC];
//    result.navigationBar.barTintColor = Theme_Color;
//    result.navigationBar.translucent  = NO;
//    
    return sinaVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchSinaWebPath];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}

- (void)fetchSinaWebPath {
    
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:self.serverPath params:[[UserinfoManager sharedUserinfo] increaseUserParams:self.params] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
//        NSLog(@"%@", [result[RESULT_DATA] firstObject][@"redirect_url"]);
        self.webPath = [result[RESULT_DATA] firstObject][@"redirect_url"];
//        self.webPath = @"http://api.yuanin.com/sina_return.php?name=ios";
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];

        if (2 == [result[RESULT_RESULT] integerValue]) {
            self.webPath = [result[RESULT_DATA] firstObject][@"redirect_url"];
            
            [AlertViewManager showInViewController:self title:@"提示" message:errorDescription clickedButtonAtIndex:nil cancelButtonTitle:NSLocalizedString(@"confirm", nil) otherButtonTitles:nil];
        } else {
            [SpringAlertView showMessage:errorDescription];
        }
    }];
}

- (void)webView:(UIWebView *)webView didCreateJavaScriptContext:(JSContext*) ctx {
    
    @weakify(self)
    ctx[@"ios_aimi_success"] = ^{
        @strongify(self)
        dispatch_async( dispatch_get_main_queue(), ^{
            if (self.isFromStradPasswordVC) {
                 [(AuthenticationVC *)self.parentViewController changeRootViewControllerToViewControoler:[AiMiApplication obtainControllerForStoryboard:@"Auth" controller:BIND_BANK_CARD_STORYBOARD_ID]];
            }else{
                
            [self dismissVC];
              
            PerformEmptyParameterBlock(self.success);
                
            [self.navigationController popViewControllerAnimated:YES];
            }
           
        });
    };
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
}

- (void)configureNavifationLeftButton {
    
    [self layoutNavigationButton:YES title:NSLocalizedString(@"cancel", nil) color:nil action:@selector(dismissVC)];
}
- (void)dismissVC {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
