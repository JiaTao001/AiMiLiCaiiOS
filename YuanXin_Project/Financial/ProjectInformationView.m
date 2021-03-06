//
//  ProjectInformationView.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/9/23.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "ProjectInformationView.h"

@interface ProjectInformationView () <UIWebViewDelegate>

@property (strong, nonatomic, readwrite) UIWebView *projectInfoView;
@end

@implementation ProjectInformationView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.projectInfoView.frame = self.bounds;
}

#pragma mark - UIWebView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.tag = NO;
    [USERDEFAULTS setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
}

- (void)beginRefresh
{
    if (self.projectInfoView.tag) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@html/security_search.php?productid=%@", hostUrl, self.productID]];
        [self.projectInfoView loadRequest:[NSURLRequest requestWithURL:url]];
    }
}
- (void)stopRefreshing
{
    [self.projectInfoView stopLoading];
}

#pragma mark - Getter
- (UIWebView *)projectInfoView
{
    if (!_projectInfoView) {
        _projectInfoView = [[UIWebView alloc] init];
        
        _projectInfoView.scrollView.delegate = self;
        _projectInfoView.backgroundColor = [UIColor whiteColor];
        _projectInfoView.delegate = self;
        _projectInfoView.tag = YES; //YES 代表需要刷新
        _projectInfoView.scrollView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:_projectInfoView];
    }
    return _projectInfoView;
}

@end
