//
//  Bar+BackgroundColor.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/12/24.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"
#import <objc/runtime.h>

@interface DownLineView : UIView

@property (strong, nonatomic) UIColor *lineColor;
@end

@implementation DownLineView

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextSetLineWidth(ctx, UISCREEN_SCALE);
    
    CGFloat lineY = rect.size.height - UISCREEN_SCALE;
    
    NSInteger realPx = (int)(lineY/UISCREEN_SCALE);
    lineY  = (0 == realPx%2) ? lineY : lineY + UISCREEN_SCALE/2;
    
    CGContextMoveToPoint(ctx, 0, lineY);
    CGContextAddLineToPoint(ctx, rect.size.width, lineY);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end

static void *CoverView  = @"coverView";

@implementation UINavigationBar (BackgroundColor) 

- (void)configureNavigationBar {
    
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]];
    
    DownLineView *view = [[DownLineView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    view.userInteractionEnabled = NO;
    view.clipsToBounds = NO;
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    [self.subviews[0] insertSubview:self.coverView = view atIndex:0];
}

- (void)setCoverView:(UIView *)coverView {
    
    objc_setAssociatedObject(self, CoverView, coverView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)coverView {
    
    return objc_getAssociatedObject(self, CoverView);
}

- (void)setCustomBackgroundColor:(UIColor *)color {
    
    self.coverView.backgroundColor = color;
}

- (void)setCustomShadowColor:(UIColor *)color {
    
    [(DownLineView *)self.coverView setLineColor:color];
}
@end
