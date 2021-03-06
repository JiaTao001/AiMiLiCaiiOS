//
//  GifIndicatorView.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/30.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "BaseIndicatorView.h"

#import "AppDelegate.h"


#define GIF_NAME @"loading.gif"
#define IMAGE_NAME @"loading_%@"

#define CORNER_RADIUS 10
#define SHOW_WIDTH    100

static BaseIndicatorView *baseIndicator;

@interface BaseIndicatorView () <UIWebViewDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIActivityIndicatorView *loadingView;
@property (strong, nonatomic) UILabel     *loading;

@property (strong, nonatomic) UIView *showView;
@property (strong, nonatomic) UIView *backgroundView;

@end


@implementation BaseIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundView];
        [self addSubview:self.showView];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_backgroundView && !_backgroundView.hidden) {
        _backgroundView.frame = self.bounds;
    }

    CGPoint point = [((AppDelegate *)[UIApplication sharedApplication].delegate).window convertPoint:((AppDelegate *)[UIApplication sharedApplication].delegate).window.center toView:self];
    point.x = self.width/2;
    
    self.showView.center = point;
}


+ (void)show {
    [self showInView:[[UIApplication sharedApplication].windows lastObject] maskType:kIndicatorMaskContent];
}
+ (void)showWithMaskType:(IndicatorMaskType)type {
    [self showInView:[[UIApplication sharedApplication].windows lastObject] maskType:kIndicatorMaskContent];
}
+ (void)showInView:(UIView *)view {
    [self showInView:view maskType:kIndicatorMaskContent];
}
+ (void)showInView:(UIView *)view maskType:(IndicatorMaskType)maskType {
    
    if (!view || (view == baseIndicator.superview) ) return;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        baseIndicator = [[[self class] alloc] init];
    });
    if (baseIndicator.superview) {
        [baseIndicator removeFromSuperview];
    }
    
    [view addSubview:baseIndicator];
    [view bringSubviewToFront:baseIndicator];
    
    [baseIndicator.loadingView startAnimating];
    baseIndicator.backgroundView.hidden = kIndicatorNoMask == maskType;
    
    switch (maskType) {
        case kIndicatorNoMask:
            baseIndicator.frame = CGRectMake(0, 0,  baseIndicator.showView.width, baseIndicator.showView.height);
            baseIndicator.center = CGPointMake(view.width/2, view.height/2);
            break;
        case kIndicatorMaskContent:
            baseIndicator.frame = CGRectMake(0, [view isMemberOfClass:[UIWindow class]] ? NORMAL_STATUS_AND_NAV_BAR_HEIGHT : 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
            break;
        case kIndicatorMaskAll:
            baseIndicator.frame = view.bounds;
            break;
    }
}


+ (void)hide {
    
    [self hideWithAnimation:NO];
}
+ (void)hideWithAnimation:(BOOL)animation {
    
    if (baseIndicator.superview) {
        [baseIndicator.loadingView stopAnimating];
        
        if (animation) {
            [UIView animateWithDuration:NORMAL_ANIMATION_DURATION animations:^{
                baseIndicator.backgroundView.alpha = 0;
                baseIndicator.showView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                baseIndicator.backgroundView.alpha = DEFAULT_ALPHA/2;
                baseIndicator.showView.transform = CGAffineTransformMakeScale(1, 1);
                [baseIndicator removeFromSuperview];
            }];
        } else {
            [baseIndicator removeFromSuperview];
        }
    }
}

- (UILabel *)loading {
    
    if (!_loading) {
        _loading = [[UILabel alloc] init];
        _loading.font = [UIFont systemFontOfSize:NORMAL_FONT_SIZE];
        _loading.textColor = [UIColor whiteColor];
        _loading.text = NSLocalizedString(@"loading", nil);
        
        [_loading sizeToFit];
    }
    return _loading;
}
- (UIImageView *)imageView {
    
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        
        @autoreleasepool {
            
            NSMutableArray *mutArr = [NSMutableArray array];
            
            NSInteger i = 0;
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:IMAGE_NAME, @(i)]];

            while (image) {
                [mutArr addObject:image];
                
                i++;
                image = [UIImage imageNamed:[NSString stringWithFormat:IMAGE_NAME, @(i)]];
            }
            
            if (mutArr.count) {
                _imageView.image  = mutArr[0];
                _imageView.animationImages = mutArr;
                _imageView.animationDuration = mutArr.count * NORMAL_ANIMATION_DURATION;
                [_imageView sizeToFit];
            }
        }
    }
    
    return _imageView;
}
- (UIActivityIndicatorView *)loadingView {
    
    if (!_loadingView) {
        UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        view.hidesWhenStopped = YES;
        
        _loadingView = view;
    }
    return _loadingView;
}

- (UIView *)showView {
    
    if (!_showView) {
        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SHOW_WIDTH, SHOW_WIDTH)];
        _showView.backgroundColor = [UIColor clearColor];
        
        CAShapeLayer *showViewLayer = [[CAShapeLayer alloc] init];
        showViewLayer.fillColor = RGBA(0x000000, DEFAULT_ALPHA).CGColor;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRoundedRect(path, NULL, _showView.bounds, CORNER_RADIUS, CORNER_RADIUS);
        showViewLayer.path = path; CGPathRelease(path);
        
        [_showView.layer addSublayer:showViewLayer];
        [_showView addSubview:self.loadingView];
        [_showView addSubview:self.loading];
        
        self.loadingView.center = CGPointMake(SHOW_WIDTH/2, SHOW_WIDTH/2 - BIG_MARGIN_DISTANCE/2);
        self.loading.center = CGPointMake(SHOW_WIDTH/2, SHOW_WIDTH/2 + BIG_MARGIN_DISTANCE + MARGIN_DISTANCE);
    }
    return _showView;
}
- (UIView *)backgroundView {
    
    if (!_backgroundView) {
        
        _backgroundView = [[UIView alloc] init];
        _backgroundView.alpha = DEFAULT_ALPHA/2;
        _backgroundView.backgroundColor = [UIColor blackColor];
    }
    return _backgroundView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //    解决UIWebView加载js时内存泄露的方法是在webViewDidFinishLoad方法中设置如下：原文地址是：http://blog.techno-barje.fr//post/2010/10/04/UIWebView-secrets-part1-memory-leaks-on-xmlhttprequest/
    
    [USERDEFAULTS setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [USERDEFAULTS setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [USERDEFAULTS setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [USERDEFAULTS synchronize];
}

@end
