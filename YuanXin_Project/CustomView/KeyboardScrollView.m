//
//  KeyboardScrollView.m
//  wujin-tourist
//
//  Created by wujin  on 15/8/4.
//  Copyright (c) 2015年 wujin. All rights reserved.
//

#import "KeyboardScrollView.h"

@implementation KeyboardScrollView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupKeyboardScrollView];
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupKeyboardScrollView];        
    }
    return self;
}

- (void)setupKeyboardScrollView {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentInset:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentInset:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContentInset:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark KVO & notification

- (void)changeContentInset:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval animationDur = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCur = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    UIEdgeInsets edge = self.contentInset;
    
    //隐藏的时候bottom应该设为0
    edge.bottom = [UIKeyboardWillHideNotification isEqualToString: notification.name] ? 0 : keyboardSize.height;
    
    if (!UIEdgeInsetsEqualToEdgeInsets(edge, self.contentInset)) {
        
        [UIView beginAnimations:@"changeContentAnimation" context:nil];
        [UIView setAnimationDuration:animationDur];
        [UIView setAnimationCurve:animationCur];

        self.contentInset = edge;
        [UIView commitAnimations];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
