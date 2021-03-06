//
//  BannerWebVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/11/16.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "BannerWebVC.h"
#import "UIWebView+TS_JavaScriptContext.h"
#import "CreatePresetParamete.h"
#import "NSString+ExtendMethod.h"
#import "UserinfoManager.h"
#import "LoginNavigationController.h"
//NSString *completeRPCURLPath = @"/njkwebviewprogressproxy/complete";
NSString *completeURLPath = @"/webviewcomplete/complete";
const CGFloat InitialProgressValue = 0.1f;
const CGFloat InteractiveProgressValue = 0.5f;
const CGFloat FinalProgressValue = 0.9f;

@interface BannerWebVC () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView      *webView;
@property (strong, nonatomic) UIProgressView *progressView;

@property (strong, nonatomic) NSURLRequest   *webRequest;
@property (strong, nonatomic) NSURL          *currentURL;
@property (assign, nonatomic) BOOL           interactive;
@property (assign, nonatomic) CGFloat        progress;/**< 0...1*/
@property (assign, nonatomic) NSInteger      loadingCount;
@property (assign, nonatomic) NSInteger      maxLoadCount;
@property (strong, nonatomic) NSString      *webPath;
@property (assign, nonatomic) int      IsRed;
@end

@implementation BannerWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.view setNeedsUpdateConstraints];
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        self.interactive = YES;
    }];
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self prepareLoadWebPath:self.webPath Is_Red:self.IsRed];
}
- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (self.webView.translatesAutoresizingMaskIntoConstraints) {
        self.webView.translatesAutoresizingMaskIntoConstraints = self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSArray *hWebCon = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_webView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)];
        NSArray *vWebCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-0-[webView]-0-|" options:0 metrics:nil views:@{@"webView":self.webView, @"topLayoutGuide":self.topLayoutGuide}];
        
        NSArray *hProCon = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_progressView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressView)];
        NSArray *vProCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-0-[progressView]" options:0 metrics:nil views:@{@"progressView":self.progressView, @"topLayoutGuide":self.topLayoutGuide}];
        
        [self.view addConstraints:hWebCon];
        [self.view addConstraints:vWebCon];
        [self.view addConstraints:hProCon];
        [self.view addConstraints:vProCon];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_webView stopLoading];
    [_webView loadHTMLString:@"" baseURL: nil];
}

#pragma mark - public method
- (BOOL)prepareLoadWebPath:(NSString *)webPath Is_Red:(int)is_red {
    
    if (!webPath) return NO;
    if (![webPath hasPrefix:@"http"]) return NO; //非网络加载
    self.webPath = webPath;
    self.IsRed = is_red;
    [self reset];
    NSString *appId =nil ;
    NSString *uid = nil;
    NSString *token = nil;
    
  
     appId =[NSBundle mainBundle].infoDictionary[APP_ID] ;
    NSString *url= nil;
   
    
    if ([UserinfoManager sharedUserinfo].logined && is_red==1) {
        
        uid = [UserinfoManager sharedUserinfo].userInfo.userid;
        NSString *uidmobile = [NSString stringWithFormat:@"%@%@",uid,[UserinfoManager sharedUserinfo].userInfo.mobile];
        token = [uidmobile MD5Encryption];
         url = [NSString stringWithFormat:@"%@?appid=%@&uid=%@&token=%@",webPath,appId,uid,token];
        
    }else{
        url = [NSString stringWithFormat:@"%@?appid=%@",webPath,appId];
    }
   
    
    self.webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:self.webRequest];
    return YES;
}




#pragma mark - delegate

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([request.URL.path isEqualToString:completeURLPath]) {
        
        [self reset];
        return NO;
    }
    if ([request.URL.path isEqualToString:@"/ios.html"]) {
        
        [self reset];
       
        LoginNavigationController *loginController = [AiMiApplication obtainControllerForStoryboard:LOGIN_STORYBOARD_NAME controller:LOGIN_NAVIGARION_STORYBOARD_ID];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tabBarController presentViewController:loginController animated:YES completion:nil];
        });
        return NO;
    }
    
    BOOL ret = YES;
    
    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump           = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    
    BOOL isHTTPOrLocalFile = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"] || [request.URL.scheme isEqualToString:@"file"];
    if (ret && !isFragmentJump && isHTTPOrLocalFile && isTopLevelNavigation) {
        _currentURL = request.URL;
        [self reset];
    }
    return ret;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    _loadingCount++;
    _maxLoadCount = fmax(_maxLoadCount, _loadingCount);
    
    [self startProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self updateProgress];
    
    //    解决UIWebView加载js时内存泄露的方法是在webViewDidFinishLoad方法中设置如下：原文地址是：http://blog.techno-barje.fr//post/2010/10/04/UIWebView-secrets-part1-memory-leaks-on-xmlhttprequest/
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
//    NSString *body = @"document.getElementsByTagName('body')[0].style.background='#F5F5F9'";
//    [webView stringByEvaluatingJavaScriptFromString:body];
    
    [USERDEFAULTS setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [USERDEFAULTS setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [USERDEFAULTS setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [USERDEFAULTS synchronize];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self updateProgress];
}

- (void)reset {
    
    self.loadingCount = self.maxLoadCount = 0;
    self.interactive = NO;
    self.progressView.progress = self.progress = 0.0;
}

- (void)startProgress {
    
    if (_progress < InitialProgressValue) {
        [self setProgress:InitialProgressValue];
    }
}
- (void)updateProgress {
    
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [self.webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:
                                       @"window.addEventListener('load',function() { \
                                                                                var iframe = document.createElement('iframe'); \
                                                                                iframe.style.display = 'none'; \
                                                                                iframe.src = '%@://%@%@'; \
                                                                                document.body.appendChild(iframe); \
                                                                                }, false);", self.webView.request.mainDocumentURL.scheme, self.webView.request.mainDocumentURL.host, completeURLPath];
        [self.webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:self.webView.request.mainDocumentURL];
    BOOL complete      = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        
        [self setProgress:1.0f];
    }
}
- (void)incrementProgress {
    
    CGFloat progress      = self.progress;
    CGFloat maxProgress   = _interactive ? FinalProgressValue : InteractiveProgressValue;
    CGFloat remainPercent = (CGFloat)_loadingCount / (CGFloat)_maxLoadCount;
    CGFloat increment     = (maxProgress - progress) * remainPercent;
    progress              += increment;
    progress              = fmin(progress, maxProgress);
    
    [self setProgress:progress];
}

- (void)setProgress:(CGFloat)progress {
    
    if (progress > _progress || 0 == progress) {
        _progress = progress;
        
        [self.progressView setProgress:progress animated:YES];
    }
}


#pragma mark - setter & getter
- (UIWebView *)webView {
    
    if (!_webView) {
        
        _webView = [[UIWebView alloc] init];
        _webView.delegate        = self;
        _webView.backgroundColor = Background_Color;
    }
    return _webView;
}
- (UIProgressView *)progressView {
    
    if (!_progressView) {
        
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = Theme_Color;
        _progressView.trackTintColor    = Background_Color;
    }
    return _progressView;
}


@end
