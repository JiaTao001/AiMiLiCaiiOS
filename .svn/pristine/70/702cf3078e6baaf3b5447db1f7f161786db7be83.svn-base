//
//  CheckRealNameVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "CheckRealNameVC.h"


@interface CheckRealNameVC ()

@property (strong, nonatomic) NSURLSessionTask *task;

@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UILabel *realName;
@property (weak, nonatomic) IBOutlet UILabel *idCardNo;
@end

@implementation CheckRealNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(CheckRealNameVC *viewController) {
        
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    
    self.showView.hidden = YES;
    
    [self fetchRealNameInfo];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}


- (void)fetchRealNameInfo {
        
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"getcertified" params:[[UserinfoManager sharedUserinfo] increaseUserParams:nil] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        self.showView.hidden = NO;
        self.realName.text = [result[RESULT_DATA] firstObject][KEY_CERIFIER];
        self.idCardNo.text = [result[RESULT_DATA] firstObject][KEY_IDCARD];
        [BaseIndicatorView hideWithAnimation:self.didShow];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [SpringAlertView showMessage:errorDescription];
        [BaseIndicatorView hideWithAnimation:self.didShow];
    }];
}
@end
