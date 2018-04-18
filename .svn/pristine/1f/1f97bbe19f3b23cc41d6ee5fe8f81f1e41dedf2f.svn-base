//
//  UIPlaceHolderTextView.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/5.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@implementation UIPlaceHolderTextView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configureTextView];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configureTextView];
    }
    return self;
}
- (void)configureTextView {
    
    showPlaceholder = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)prepareForInterfaceBuilder {
    
    self.placeholder = self.placeholder ? : @"";
    self.placeholderColor = self.placeholderColor ? : [UIColor lightGrayColor];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 ) {
        
        CGRect contentRect = CGRectMake(self.textContainerInset.left + 4/* 空出光标范围 */, self.textContainerInset.top, rect.size.width - self.textContainerInset.left - self.textContainerInset.right, rect.size.height - self.textContainerInset.top - self.textContainerInset.bottom);//CGRectMake(contentInsets.left, contentInsets.top, rect.size.width - contentInsets.left - contentInsets.right, rect.size.height - contentInsets.top - contentInsets.bottom);
        [self.placeholder drawInRect:contentRect
                  withAttributes:@{NSFontAttributeName: self.font, NSForegroundColorAttributeName: self.placeholderColor}];
    }
//    NSLog(@"%@", NSStringFromUIEdgeInsets(self.textContainerInset));
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    [self setNeedsDisplay];
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}


- (void)textDidChange {
    
    if ((BOOL)self.text.length == showPlaceholder) {
        showPlaceholder = !showPlaceholder;
        [self setNeedsDisplay];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
