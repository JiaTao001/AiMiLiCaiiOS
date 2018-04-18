//
//  UserinfoCollectionCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/25.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "UserinfoCollectionCell.h"

@implementation UserinfoCollectionCell

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    self.contentView.backgroundColor = highlighted ? Cell_Highlight : [UIColor clearColor];
}

- (void)loadUserinfoCollectionCellWithDictionary:(NSDictionary *)aDic {
    
    self.imageView.image = [UIImage imageNamed:aDic[UsreinfoFunctionIconName]];
    self.title.text      = aDic[UserinfoFunctionTitle];
}
@end
