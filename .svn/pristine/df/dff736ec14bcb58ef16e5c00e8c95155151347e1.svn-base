//
//  AnnouncementDetailVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/20.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "AnnouncementDetailVC.h"

#import "BaseViewModel.h"

@interface AnnouncementDetailVC () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSDictionary *webContent;
@end

@implementation AnnouncementDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"公告";
    [self.view addSubview:self.webView];
    [self.view setNeedsUpdateConstraints];
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.webView stopLoading];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (self.webView.translatesAutoresizingMaskIntoConstraints) {
        self.webView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSArray *webH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_webView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)];
        NSArray *webV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-0-[webView]-0-|" options:0 metrics:nil views:@{@"webView":self.webView, @"topLayoutGuide":self.topLayoutGuide}];
        
        [self.view addConstraints:webH];
        [self.view addConstraints:webV];
    }
}

- (void)loadWebViewContent {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.webView loadHTMLString:self.webContent[@"content"] baseURL:nil];
    });
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [BaseIndicatorView hideWithAnimation:self.didShow];
    [USERDEFAULTS setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [BaseIndicatorView hideWithAnimation:self.didShow];
}

- (void)setAnnoucementInfo:(AnnouncementInfo *)annoucementInfo {
    
    if (!annoucementInfo) return;
    _annoucementInfo = annoucementInfo;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@html/noticedetail.php?noticeid=%@", hostUrl,annoucementInfo.announcementId]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)setWebContent:(NSDictionary *)webContent {
    _webContent = webContent;
    
    [self loadWebViewContent];
}

- (UIWebView *)webView {
    
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
