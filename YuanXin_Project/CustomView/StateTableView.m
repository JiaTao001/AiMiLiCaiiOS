//
//  StateTableVIew.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/28.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "StateTableView.h"

@interface StateTableView()

@property (copy, nonatomic, readwrite) void(^callBack)();

@property (strong, nonatomic, readwrite) UILabel *noInfoLabel;
@property (strong, nonatomic, readwrite) UIButton *clickAgain;
@property (strong, nonatomic, readwrite) UIImageView *backgroundImage;
@end


@implementation StateTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
 
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        [self initializeStateTableView];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initializeStateTableView];
}

- (void)initializeStateTableView {
    
    self.noInfoImage       = [UIImage imageNamed:@"no_info"];
    self.errorNetworkImage = [UIImage imageNamed:@"err_network"];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ( !CGPointEqualToPoint(self.backgroundImage.center, CGPointMake(self.width/2, self.height/2 - 70))) {
        
        self.backgroundImage.center = CGPointMake(self.width/2, self.height/2 - 70);
        self.noInfoLabel.frame      = CGRectMake(0, CGRectGetMaxY(self.backgroundImage.frame) + MARGIN_DISTANCE, self.width, 20);// CGPointMake(self.width/2,  + self.noInfoLabel.height/2);
        self.clickAgain.bounds      = CGRectMake(0, 0, 80, 30);
        self.clickAgain.center      = CGPointMake(self.width/2, CGRectGetMaxY(self.noInfoLabel.frame) + MARGIN_DISTANCE + self.clickAgain.height/2);
    }
}

- (void)setClickCallBack:( void(^)())callBack {
 
    self.callBack = callBack;
}


- (void)clickButton:(UIButton *)sender {
    
    if (self.callBack) {
        self.callBack();
    }
}

#pragma mark - getter & setter
- (UIButton *)clickAgain {
    
    if (!_clickAgain) {
        UIButton *button = [[UIButton alloc] init];
        [self addSubview:_clickAgain = button];
        
        button.titleLabel.font = [UIFont systemFontOfSize:Button_Font_Size];
        [button setTitle:@"点击重试" forState:UIControlStateNormal];
        [button setTitleColor:Font_Shallow_Gray forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_border_gray"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.hidden = YES;
    }
    return _clickAgain;
}
- (UIImageView *)backgroundImage {
    
    if (!_backgroundImage) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview: _backgroundImage = imageView];
        
        _backgroundImage.image = self.noInfoImage;
        imageView.hidden = YES;
    }
    return _backgroundImage;
}
- (UILabel *)noInfoLabel {
    
    if (!_noInfoLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.noInfoDescription ? self.noInfoDescription : NSLocalizedString(@"err_empty", nil);
        [self addSubview:_noInfoLabel = label];
        
        label.font = [UIFont systemFontOfSize:NORMAL_FONT_SIZE];
        label.textColor = Font_Shallow_Gray;

        label.hidden = YES;
    }
    return _noInfoLabel;
}


- (void)setType:(TableStateType)type {
    
    _type = type;
    
    switch (type) {
            
        case kTableStateNormal:
            self.backgroundImage.hidden = YES;
            self.clickAgain.hidden = YES;
            self.noInfoLabel.hidden = YES;
            break;
            
        case kTableStateNoInfo:
            self.backgroundImage.hidden = NO;
            self.backgroundImage.image = self.noInfoImage;
            self.clickAgain.hidden = YES;
            self.noInfoLabel.hidden = NO;
            self.noInfoLabel.text = self.noInfoDescription ? self.noInfoDescription : NSLocalizedString(@"err_empty", nil);
            break;
            
        case kTableStateNetworkError:
            self.backgroundImage.hidden = NO;
            self.backgroundImage.image = self.errorNetworkImage;
            self.clickAgain.hidden = NO;
            self.noInfoLabel.hidden = NO;
            self.noInfoLabel.text = NSLocalizedString(@"err_network", nil);
            break;
    }
    
    [self.backgroundImage sizeToFit];
}
@end
