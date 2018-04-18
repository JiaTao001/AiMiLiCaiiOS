//
//  ProductSectionHeader.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/20.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "ProductSectionHeader.h"

@interface ProductSectionHeader ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation ProductSectionHeader
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)setType:(ProductType)type {
    _type = type;
    
    self.imageView.image = [self imageWithProductType];
    self.title.text = [self titleWithProductType];
}

- (UIImage *)imageWithProductType {
    
    return [UIImage imageNamed: kRegularProduct == self.type ? @"aimi_regular" : @"aimi_optizimation"];
}

- (NSString *)titleWithProductType {
    
    return kRegularProduct == self.type ? @"爱米定期" : @"爱米优选";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
