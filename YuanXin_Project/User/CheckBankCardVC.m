//
//  CheckBankCardVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/7/12.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "CheckBankCardVC.h"

#import "SinaWebVC.h"

#import "CheckBankCardCell.h"
#import "HKWebVC.h"
#define No_BankCard_Identidier @"NoBankCardCell"

@interface CheckBankCardVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *bankCardList;
@property (strong, nonatomic) UIButton *rightButton;

@property (strong, nonatomic) NSURLSessionTask *task;
@end

@implementation CheckBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    //    self.rightButton = [self layoutNavigationRightButtonWithTitle:@"管理" color:nil block:^(__kindof UIViewController *viewController) {
    //        [viewController presentViewController:[SinaWebVC sinaWebWithServerPath:@"set_sina_bank" params:nil] animated:YES completion:nil];
    //    }];
    //    [self configWithTable];
    self.rightButton.hidden = YES;
}
- (void)configWithTable{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake( [UIScreen mainScreen].bounds.size.width - 140, 17, 16,16)];
    image.image = [UIImage imageNamed:@"wenhao-2"];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 120, 10, 100, 30)];
    [button setTitle:@"绑定银行卡说明" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [view addSubview:button];
    [view addSubview:image];
    
    self.tableView.tableHeaderView = view;
    
    
    
}
- (void)buttonClicked{
    WebVC *vc = [[WebVC alloc] initWithWebPath:[CommonTools completeWebPathWithSubpath:Introduct_Bind_Bank]];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchBankCardList];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}
- (void)fetchBankCardList {
    
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"get_haikou_bank" params:[[UserinfoManager sharedUserinfo] increaseUserParams:nil] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        self.bankCardList = result[RESULT_DATA];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showMessage:errorDescription];
    }];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.bankCardList.count) {
        
        CheckBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CheckBankCardCell class])];
        
        [cell configureCellWithDictionary:self.bankCardList[indexPath.section]];
        @weakify(self)
        cell.unbindBankCard = ^(NSInteger i){
            @strongify(self)
            if (i == 1) {
                [self unbindSafeBankcard];
            }
            if (i == 2) {
                [self changePhoneNum];
            }
            
        };
        return cell;
    } else {
        
        return [tableView dequeueReusableCellWithIdentifier:No_BankCard_Identidier];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return tableView.sectionHeaderHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.bankCardList.count) {
        
        //        [AlertViewManager showInViewController:self title:nil message:[NSString stringWithFormat:@"首次绑卡将会通过您的银行账户向您在爱米理财的新浪支付账户进行%@元充值，用于验证账户的真实性。", [UserinfoManager sharedUserinfo].userInfo.minRechargeMoney] clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
        //            if (1 == buttonIndex) {
        //                [self presentViewController:[SinaWebVC sinaWebWithServerPath:@"sina_recharge" params:@{@"amount": [UserinfoManager sharedUserinfo].userInfo.minRechargeMoney}] animated:YES completion:nil];
        //            }
        //        } cancelButtonTitle:@"取消" otherButtonTitles:@"去验证", nil];
        
        
        //
        [self performSegueWithIdentifier:@"To_BangDingCardVC" sender:nil];
    }
}

#pragma mark - Action
- (void)changePhoneNum{
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"changebankmobile" params:[[UserinfoManager sharedUserinfo] increaseUserParams:nil] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [self pushToNextItemWithUrl:[result[@"data"] firstObject][@"redirect_url"]];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showMessage:errorDescription];
    }];
}
- (IBAction)unbindSafeBankcard {
    
    //    [AlertViewManager showInViewController:self title:nil message:@"只有账户余额为0元时才能解绑银行卡，您是否确定解绑？" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
    //
    //        if (1 == buttonIndex) {
    
    [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
    @weakify(self)
    self.task = [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationUnwindBankCard params:nil success:^(id result) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showMessage:result[RESULT_REMARK]];
        [self pushToNextItemWithUrl:[result[@"data"] firstObject][@"redirect_url"]];
        //                [self fetchBankCardList];
    } failure:^(id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showMessage:errorDescription];
    }];
    //        }
    //    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}
- (void)pushToNextItemWithUrl:(NSString *)url{
    [self.navigationController pushViewController:[HKWebVC webVCWithWebPath:url] animated:YES];
}

#pragma mark - Setter
- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    
    tableView.sectionFooterHeight = 0;
}

- (void)setBankCardList:(NSArray *)bankCardList {
    _bankCardList = bankCardList;
    
    self.rightButton.hidden = !bankCardList.count;
    [self.tableView reloadData];
}

@end

