//
//  PropertyDetailMidCell.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/7/14.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyDetailMidCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *investTime;
@property (weak, nonatomic) IBOutlet UILabel *bearingTime;
@property (weak, nonatomic) IBOutlet UILabel *expireTime;

- (void)configureCellWithDictionary:(NSDictionary *)aDic;
@end
