//
//  InviteFriendsCell.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/20.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define INVITE_FRIENDS_IDENTIFIER @"InviteFriendsCell"

@interface InviteFriendsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end
