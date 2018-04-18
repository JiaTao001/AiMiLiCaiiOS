//
//  ProductDetailVC.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/12/4.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "BaseViewController.h"

#import "SingleProductInfo.h"

#define QUESTION_CELL_IDENTIFIER    @"QuestionDetailCell"

#define QUESTION_KEY                @"question"
#define ANSWER_KEY                  @"answer"
#define QUESTION_PLIST              @"question.plist"
#define SHOULD_CHANGE_SHOW_VIEW_DISTANCE 44

@interface QuestionDetailCell : UITableViewCell

@property (strong, nonatomic) UILabel *question;
@property (strong, nonatomic) UILabel *answer;

- (void)configCellWithDictionary:(NSDictionary *)aDic;
@end




#define PRODUCT_DETAIL_STORYBOARD_ID @"ProductDetailVC"

@interface ProductDetailVC :BaseViewController

@property (assign, nonatomic) BOOL needShowPastProject;

@property (strong, nonatomic) SingleProductInfo *productInfo;
@end
