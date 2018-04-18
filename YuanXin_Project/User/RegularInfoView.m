//
//  RegularInfoView.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/5/3.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "RegularInfoView.h"

@implementation RegularInfoView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initializeRegularInfoView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.view.frame = self.bounds;
}

- (void)initializeRegularInfoView {
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.view.translatesAutoresizingMaskIntoConstraints = YES;

    [self addSubview:self.view];
}

- (void)loadInterfaceWithDictionary:(NSDictionary *)aDic {
    
    self.lockPeriod.text     = [NSString stringWithFormat:@"%@个月", aDic[@"period"]] ;
    self.regularName.text    = aDic[@"projectname"];
    self.annualInterest.text = aDic[@"apr"];
}

@end
