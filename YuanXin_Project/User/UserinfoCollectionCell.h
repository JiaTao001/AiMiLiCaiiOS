//
//  UserinfoCollectionCell.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/25.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *UserinfoFunctionAssetName     = @"UserinfoFunction.plist";
static NSString *UserinfoFunctionAction        = @"action";
static NSString *UserinfoFunctionTitle         = @"title";
static NSString *UsreinfoFunctionIconName      = @"image_path";
static NSString *UserinfoFunctionNeedUserLogin = @"need_user_login";

@interface UserinfoCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *zichanLB;
@property (weak, nonatomic) IBOutlet UIImageView *jiantouIV;
@property (weak, nonatomic) IBOutlet UIButton *redAmountBtn;
@property (weak, nonatomic) IBOutlet UIImageView *line_downIV;
@property (weak, nonatomic) IBOutlet UIView *grayView;

- (void)loadUserinfoCollectionCellWithDictionary:(NSDictionary *)aDic;
@end
