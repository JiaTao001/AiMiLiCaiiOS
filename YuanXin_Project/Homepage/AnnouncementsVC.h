//
//  AnnouncementsVC.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/20.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "BaseViewController.h"
#import "HightlightCell.h"

@interface AnnouncementCell : HightlightCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end


@interface AnnouncementsVC : BaseViewController

@end
