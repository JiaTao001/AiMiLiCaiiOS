//
//  HightlightCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/11/23.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "HightlightCell.h"

@implementation HightlightCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self configureCell];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self configureCell];
}
- (void)configureCell {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    self.backgroundColor = highlighted ? Cell_Highlight : self.originColor;
}


- (UIColor *)originColor {
    
    if (!_originColor) {
        //只调用一次，保证是用户设定的值
        _originColor = self.backgroundColor;
    }
    return _originColor;
}
@end
