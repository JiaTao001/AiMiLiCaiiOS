//
//  WebVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "WebVC.h"
#import "UINavigationBar+BackgroundColor.h"

@interface WebVC ()

@property (strong, nonatomic, readwrite) UIWebView *webView;
@end

@implementation WebVC

#pragma mark - Life Cycle

- (instancetype)initWithWebPath:(NSString *)webPath
{
    if (self = [super init]) {
        
        _webPath = [webPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController.navigationBar setCustomBackgroundColor:Theme_Color];
        self.view.backgroundColor = Background_Color;
    }
    return self;
}
+ (instancetype)webVCWithWebPath:(NSString *)webPath
{
    return [[[self class] alloc] initWithWebPath:webPath];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.navigationController.navigationBar setCustomBackgroundColor:Theme_Color];
    [self configureNavifationLeftButton];
    [self.view addSubview:self.webView];
    [self.view setNeedsUpdateConstraints];

    [self loadWeb];
}
- (void)configureNavifationLeftButton
{
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(WebVC *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
//    self.navigationController.navigationBar.backgroundColor = Theme_Color;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.webView stopLoading];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    if (self.webView.translatesAutoresizingMaskIntoConstraints) {
        self.webView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSArray *hCon = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webView]-0-|" options:0 metrics:nil views:@{@"webView":self.webView}];
        NSArray *vCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[webView]-0-|" options:0 metrics:nil views:@{@"webView":self.webView, @"topLayoutGuide":self.topLayoutGuide}];
        
        [self.view addConstraints:hCon];
        [self.view addConstraints:vCon];
    }
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [BaseIndicatorView hideWithAnimation:self.didShow];
    
//    NSLog(@"%@", webView.request.URL);
//    NSString *body = @"document.getElementsByTagName('body')[0].style.background='#F5F5F9'";
//    [webView stringByEvaluatingJavaScriptFromString:body];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

//    解决UIWebView加载js时内存泄露的方法是在webViewDidFinishLoad方法中设置如下：原文地址是：http://blog.techno-barje.fr//post/2010/10/04/UIWebView-secrets-part1-memory-leaks-on-xmlhttprequest/
    [USERDEFAULTS setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [USERDEFAULTS setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [USERDEFAULTS setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [USERDEFAULTS synchronize];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [BaseIndicatorView hideWithAnimation:self.didShow];
}

#pragma mark - Action

- (void)loadWeb
{
    if (!self.webPath) return;
    
    [self.webView stopLoading];
    
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webPath]]];
    });
}

#pragma mark - Setter & Getter 

- (void)setWebPath:(NSString *)webPath
{
    _webPath = webPath;
    
    if (self.webView.superview) {
        
        [self loadWeb];
    }
}

- (UIWebView *)webView
{
    if (!_webView) {
        
        UIWebView *web = [[UIWebView alloc] init];
        web.delegate = self;
        web.backgroundColor = Background_Color;
        web.scrollView.showsVerticalScrollIndicator = NO;
        _webView = web;
    }
    return _webView;
}
@end
