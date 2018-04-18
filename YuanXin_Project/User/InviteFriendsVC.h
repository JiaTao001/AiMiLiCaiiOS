//
//  InviteFriendsVC.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/20.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "BaseViewController.h"

#import "SharedView.h"

#define INVITE_FRIENDS_STORYBOARD_ID @"InviteFriendsVC"

@interface InviteFriendsVC : BaseViewController

@property (strong, nonatomic) SharedView *sharedView;

@property (strong, nonatomic) NSString *headerImagePath;
@end
