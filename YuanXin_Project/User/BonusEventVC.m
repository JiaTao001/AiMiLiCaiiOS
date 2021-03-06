//
//  BonusEventVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/7/29.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "BonusEventVC.h"
#import "SharedView.h"

@interface BonusEventVC ()

@property (strong, nonatomic) NSURLSessionTask *task;
@property (strong, nonatomic) UIButton         *shareBonus;
@property (strong, nonatomic) SharedView       *sharedView;
@property (assign, nonatomic) NSInteger        bonusState;
@property (strong,nonatomic)NSDictionary *shareInfoDict;

@end

@implementation BonusEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shareBonus.hidden = YES;
    [self.view addSubview:self.shareBonus];
    
    if ([self.red_type integerValue] == 1) {
       [self fetchBonusState];
        
    }else{
       [self fetchShareBonusInfonew];
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}
- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (self.shareBonus.translatesAutoresizingMaskIntoConstraints) {
        self.shareBonus.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSArray *hButCon = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inviteFriend]-0-|" options:0 metrics:nil views:@{@"inviteFriend":self.shareBonus}];
        NSArray *vButCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[inviteFriend(==45)]-0-|" options:0 metrics:nil views:@{@"inviteFriend":self.shareBonus}];
        
        [self.view addConstraints:hButCon];
        [self.view addConstraints:vButCon];
    }
}
- (void)fetchBonusState {
    
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"getshareredstatus" params:[[UserinfoManager sharedUserinfo] increaseUserParams:nil] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        self.webPath = [result[RESULT_DATA] firstObject][@"red_html"];
        self.bonusState = [[result[RESULT_DATA] firstObject][@"status"] integerValue];
        
        self.shareBonus.hidden = NO;
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        [SpringAlertView showMessage:errorDescription];
    }];
}
- (void)fetchShareBonusInfo {
    
    [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
      
    
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"getshareredinfo" params:[[UserinfoManager sharedUserinfo] increaseUserParams:nil] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [BaseIndicatorView hide];
        [self didFetchInfoSuccess:[result[RESULT_DATA] firstObject]];
        
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:errorDescription];
    }];
}
- (void)fetchShareBonusInfonew {
    
    [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
    NSDictionary *dict  = [NSDictionary dictionaryWithObject:self.investID forKey:@"invest_id"];
   
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"getshareredinfo_new" params:[[UserinfoManager sharedUserinfo] increaseUserParams:dict] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [BaseIndicatorView hide];
        self.webPath = [result[RESULT_DATA] firstObject][@"red_html"];
        self.bonusState = [[result[RESULT_DATA] firstObject][@"status"] integerValue];
        
        self.shareBonus.hidden = NO;
        self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
//        [self didFetchInfoSuccess:[result[RESULT_DATA] firstObject]];
        self.shareInfoDict = [NSDictionary dictionaryWithDictionary:[result[RESULT_DATA] firstObject]];
        
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        
        [BaseIndicatorView hide];
        [SpringAlertView showMessage:errorDescription];
    }];
}

- (void)didFetchInfoSuccess:(NSDictionary *)aDic {
    
    self.sharedView = [SharedView sharedWithURL:aDic[@"shareurlurl"] title:aDic[@"sharetitle"] description:aDic[@"sharedescript"] thumbImagePath:aDic[@"sharelogo"] type:@[ kSharedWechat, kSharedWechatFriend]];
    self.bonusState = 2;
    
    if ([SharedView canShareWechatBonus]) {
        [self.sharedView showInWindow:self.view.window];
    } else {
        self.shareBonus.enabled = NO;
        [self.shareBonus setTitle:@"未安装可分享软件" forState:UIControlStateNormal];
    }
}


#pragma mark - Getter & Setter
- (void)setBonusState:(NSInteger)bonusState {
    _bonusState = bonusState;
//0不符合发红包条件1符合条件未获取红包2符合条件已获取过红包
    [self.shareBonus setTitle:0 == bonusState ? @"立即出借" : 1 == bonusState ? @"生成红包" : @"立即分享" forState:UIControlStateNormal];
}
- (UIButton *)shareBonus {
    
    if (!_shareBonus) {
        _shareBonus = [[UIButton alloc] init];
        
        _shareBonus.titleLabel.font = [UIFont systemFontOfSize:Button_Font_Size];
        
//        [_shareBonus setBackgroundImage:[UIImage imageNamed:@"theme_color_image"] forState:UIControlStateNormal];
        [_shareBonus setBackgroundColor:Theme_Color];
        [_shareBonus setBackgroundImage:[UIImage imageNamed:@"gray_color_image"] forState:UIControlStateDisabled];
        [_shareBonus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if ([self.red_type integerValue] == 1) {
            [_shareBonus addTarget:self action:@selector(fastInviteFriend) forControlEvents:UIControlEventTouchUpInside];

            
        }else{
            [_shareBonus addTarget:self action:@selector(fastInviteFriend2) forControlEvents:UIControlEventTouchUpInside];
        }
      
    }
    return _shareBonus;
}

- (void)fastInviteFriend {
    
    switch (self.bonusState) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1: {
            [AlertViewManager showInViewController:self title:nil message:@"您确定需要生成红包?" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
                if (1 == buttonIndex) {
                    [self fetchShareBonusInfo];
                }
            } cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"confirm", nil), nil];
        } break;
        case 2:
            [self fetchShareBonusInfo];
            break;
    }
}
- (void)fastInviteFriend2 {
    
     [self didFetchInfoSuccess:self.shareInfoDict];
}

@end
