//
//  UserinfoVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/12/25.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "UserinfoVC.h"
#import "BannerWebVC.h"
#import "WebVC.h"
#import "LoginNavigationController.h"
#import "SettingVC.h"
#import "TransactionRecordsVC.h"
#import "RewardVC.h"
#import "PropertyInformationVC.h"
#import "RechargeVC.h"
#import "WithdrawVC.h"
#import "RuleWebVC.h"
#import "AboutUsTVC.h"
#import "EntrustVC.h"
#import "AlertViewManager.h"
#import "UserinfoHeaderView.h"
#import "UserinfoCollectionCell.h"
#import "UINavigationBar+BackgroundColor.h"
#import "AiMiApplication.h"
#import "AuthenticationVC.h"
#import "WarmmingView.h"
#import "KaiHuViewController.h"
#import "HKWebVC.h"
#import "BingDingCardVC.h"

static NSString *UserinfoLeftLoginedImage   = @"left_person_center";
static NSString *UserinfoLeftUnloginedImage = @"left_person_more";

#define Big_Screen_Header_Height 315
#define Small_Screen_Header_Height 270

@interface UserinfoVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSURLSessionTask *task;
@property (strong, nonatomic) NSArray     *functionInfo;
@property (strong, nonatomic) UIButton    *leftItem;
@property (strong, nonatomic) UIButton    *rightItem;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;
@property (strong, nonatomic) UserinfoHeaderView *headerView;
@property (strong,nonatomic)WarmmingView *warmmingView;

@end

@implementation UserinfoVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavigationBarAlpha:0];
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //        self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
        //        self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
    }
    
    //默认为不登录状态
    self.leftItem = [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:UserinfoLeftLoginedImage] block:^(__kindof UIViewController *viewController) {
        [viewController performSegueWithIdentifier:SETTING_SEGUE_IDENTIFIER sender:nil];
    }];
    
    
    
    @weakify(self)
    [RACObserve([UserinfoManager sharedUserinfo], logined) subscribeNext:^(NSNumber *x) {
        @strongify(self)
        self.leftItem.hidden = !x.boolValue;
        [self.collectionView reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self changeNavigationBarAlpha:0];
    [self fetchAccountInfo];
//    //      [self.headerView reloadWarmingView];
//    NSUserDefaults*shared = [[NSUserDefaults alloc]initWithSuiteName:@"group.com.yuanin.widge"];
//    //是否显示widge
//    if ([[UserinfoManager sharedUserinfo] logined]) {
//        [shared setBool:YES forKey:IS_LOG];
//        NSString *amount = [UserinfoManager sharedUserinfo].userInfo.amount;
//        [shared setObject:amount forKey:@"amount"];
//        NSString *balance = [UserinfoManager sharedUserinfo].userInfo.balance;
//        [shared setObject:balance forKey:@"balance"];
//        NSString *interest = [UserinfoManager sharedUserinfo].userInfo.interest;
//        [shared setObject:interest forKey:@"interest"];
//    }else{
//        [shared setBool:NO forKey:IS_LOG];
//        [shared setObject:nil forKey:@"amount"];
//
//        [shared setObject:nil forKey:@"balance"];
//
//        [shared setObject:nil forKey:@"interest"];
//    }
//    [shared synchronize];
    
    [self.collectionView reloadData];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.functionInfo.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.headerView) {
        UserinfoHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([UserinfoHeaderView class]) forIndexPath:indexPath];
        headView.tapWarming = ^(int status){
           
            [self.collectionView reloadData];
        };
        self.headerView = headView;
    }
    
    return self.headerView;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UserinfoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UserinfoCollectionCell class]) forIndexPath:indexPath];
    cell.line_downIV.hidden = NO;
    cell.grayView.hidden = YES;
    if ([UserinfoManager sharedUserinfo].logined) {
        if (indexPath.row == 0) {
            cell.zichanLB.hidden = NO;
            cell.jiantouIV.hidden = YES;
            cell.redAmountBtn.hidden = YES;
            if ([[UserinfoManager sharedUserinfo].userInfo.deposit floatValue] < 0  ) {
                cell.zichanLB.text = @"立即出借";
            }else{
                NSUserDefaults*shared = [NSUserDefaults standardUserDefaults];
                //是否显示账户资金
                
                if ([shared boolForKey:@"is_Secret"]) {
                    
                    cell.zichanLB.text = @"*****";
                }else{
                    
                   cell.zichanLB.text =  [UserinfoManager sharedUserinfo].userInfo.deposit;
                }
                
            }
        }
        if (indexPath.row == 1) {
            cell.zichanLB.hidden = NO;
            cell.jiantouIV.hidden = YES;
            cell.redAmountBtn.hidden = YES;
            if ([[UserinfoManager sharedUserinfo].userInfo.enjoy floatValue] < 0  ) {
                cell.zichanLB.text = @"立即出借";
            }else{
                NSUserDefaults*shared = [NSUserDefaults standardUserDefaults];
                //是否显示账户资金
                
                if ([shared boolForKey:@"is_Secret"]) {
                    
                    cell.zichanLB.text = @"*****";
                }else{
                    
                    cell.zichanLB.text = [UserinfoManager sharedUserinfo].userInfo.enjoy;
                }
                
            }
            cell.line_downIV.hidden = YES;
            cell.grayView.hidden = NO;
        }
        if (indexPath.row == 2) {
            cell.zichanLB.hidden = YES;
            cell.jiantouIV.hidden = YES;
            cell.redAmountBtn.hidden = NO;
            if ([[UserinfoManager sharedUserinfo].userInfo.red_num floatValue] < 0  ) {
                //                [cell.redAmountBtn setTitle:@"立即投资" forState:UIControlStateNormal];
            }else{
                //                cell.redAmountBtn.text = [UserinfoManager sharedUserinfo].userInfo.red_num;
                [cell.redAmountBtn setTitle:[UserinfoManager sharedUserinfo].userInfo.red_num forState:UIControlStateNormal];
                
            }
        }
        
    }else{
        if (indexPath.row == 0 || indexPath.row == 1) {
            cell.zichanLB.hidden = NO;
            cell.jiantouIV.hidden = YES;
            cell.redAmountBtn.hidden = YES;
            cell.zichanLB.text = @"立即出借";
            
            
        }
        if (indexPath.row == 1) {
            cell.grayView.hidden = NO;
        }
        if (indexPath.row == 2) {
            cell.zichanLB.hidden = YES;
            cell.jiantouIV.hidden = NO;
            cell.redAmountBtn.hidden = YES;
            
            
            
        }
        
        
        
        
    }
    if (indexPath.row > 2) {
        cell.zichanLB.hidden = YES;
        cell.jiantouIV.hidden = NO;
        cell.redAmountBtn.hidden = YES;
        
    }
    
    [cell loadUserinfoCollectionCellWithDictionary:self.functionInfo[indexPath.row]];
    
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return CGSizeMake(collectionView.width, 54);
    }
    return CGSizeMake(collectionView.width, 49);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(collectionView.width, [AiMiApplication isBigScreen] ? Big_Screen_Header_Height : Small_Screen_Header_Height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.functionInfo[indexPath.row][UserinfoFunctionNeedUserLogin] boolValue] && ![UserinfoManager sharedUserinfo].logined) {
        
        [self login];
    } else {
        
        switch ([self.functionInfo[indexPath.row][UserinfoFunctionAction] integerValue]) {
            case 0:
            case 1: {
                if (([[UserinfoManager sharedUserinfo].userInfo.deposit integerValue]< 0 &&[self.functionInfo[indexPath.row][UserinfoFunctionAction] integerValue] == 0 ) || ([[UserinfoManager sharedUserinfo].userInfo.enjoy integerValue]< 0 && [self.functionInfo[indexPath.row][UserinfoFunctionAction] integerValue] == 1)) {
                    [self.tabBarController setSelectedIndex:1];
                }else{
                    PropertyInformationVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:Property_Regular_Storyboard_Id];
                    vc.propertyType  = [self.functionInfo[indexPath.row][UserinfoFunctionAction] integerValue];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } break;
                
            case 2:
                [self performSegueWithIdentifier:TO_TRANSACTION_RECORDS_DEGUE_IDENTIFIER sender:nil];
                break;
                
            case 3:
                [self performSegueWithIdentifier:TO_REWARDVC_SEGUE_IDENTIFIER sender:nil];
                break;
                
//            case 4:
//                if ([[UserinfoManager sharedUserinfo].userInfo.is_activate_hkaccount integerValue]  != 1 ){
//                    [self showWarmView];
//                    return;
//                }
//                [self performSegueWithIdentifier:To_Entrust_Segue_Identifier sender:nil];
//                break;
//
            case 4: {
                [self.navigationController pushViewController:[[RuleWebVC alloc] init] animated:YES];
            } break;
                
            case 5:
                [self performSegueWithIdentifier:To_About_Us_Segue_Identifier sender:nil];
                break;
            case 6:
                [self showTest];
                break;
            case 7:
                [self gotoJieKuan];
                break;
                
            default:
                NSAssert(NO, @"不应该到这里");
                break;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        self.headerView.stretchingHeight = -scrollView.contentOffset.y;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView == self.collectionView) {
        if (scrollView.contentOffset.y <= -Refresh_Height) {
            [self fetchAccountInfo];
        }
    }
}
- (void)showWarmView{
    // 1：已激活；0：普通用户待开户；2：导入用户待激活
    if ([[UserinfoManager sharedUserinfo].userInfo.is_activate_hkaccount integerValue]  == 0 ) {
        @weakify(self)
        [self.warmmingView showInView:[UIApplication sharedApplication].keyWindow WithImageName:@"kaihu" clickImage:^{
            @strongify(self)
            //            [self.bonusAnimationView removeFromSuperview];
            [self.warmmingView dissMiss];
            
        }];
        self.warmmingView.ShareBlock = ^(){
            @strongify(self)
            [self.warmmingView dissMiss];
            [self.navigationController pushViewController:[AiMiApplication obtainControllerForStoryboard:@"Auth" controller:NSStringFromClass([KaiHuViewController class])] animated:YES ];
            
            
        };
        
        
    }else if([[UserinfoManager sharedUserinfo].userInfo.is_activate_hkaccount integerValue]  == 2){
        @weakify(self)
        [self.warmmingView showInView:[UIApplication sharedApplication].keyWindow WithImageName:@"jihuo" clickImage:^{
            @strongify(self)
            
            [self.warmmingView dissMiss];
            
            
            
        }];
        self.warmmingView.ShareBlock = ^(){
            @strongify(self)
            [self.warmmingView dissMiss];
            
            
            
            //            [BaseIndicatorView showInView:self.view];
            //            @weakify(self)
            //            self.task = [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationJiHuo params:nil success:^(id result) {
            //                @strongify(self)
            //                [BaseIndicatorView hideWithAnimation:self.didShow];
            //
            //                [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
            //                [self pushToNextItemWithUrl:[result[@"data"] firstObject][@"redirect_url"]];
            //            } failure:^( id result, NSString *errorDescription) {
            //                @strongify(self)
            //
            //                [BaseIndicatorView hideWithAnimation:self.didShow];
            //                [SpringAlertView showInWindow:self.view.window message:errorDescription];
            //            }];
            [self goToJiHuo];
            //
            
            
            
        };
    }else if([[UserinfoManager sharedUserinfo].userInfo.surveyresult integerValue]  == 0 ){
        [self showTest];
    }
    
    
    
    
}

- (void)showTest{
    if ([[UserinfoManager sharedUserinfo].userInfo.surveyresult integerValue]  == 0 ) {
        @weakify(self)
        [self.warmmingView showInView:[UIApplication sharedApplication].keyWindow WithImageName:@"test_tanchuang" clickImage:^{
            @strongify(self)
            //            [self.bonusAnimationView removeFromSuperview];
            [self.warmmingView dissMiss];
            
        }];
        self.warmmingView.ShareBlock = ^(){
            @strongify(self)
            [self.warmmingView dissMiss];
           
            NSString *uid = [UserinfoManager sharedUserinfo].userInfo.userid;
            NSString *url = [NSString stringWithFormat:@"%@%@?&userid=%@",hostUrl,@"survey/showsurvey.php",uid];
            WebVC *web = [[WebVC alloc]initWithWebPath:url];
            web.hidesBottomBarWhenPushed = YES;
           
         [self.navigationController pushViewController:web animated:YES];
      
            
        };
        
        
    }else{
        NSString *uid = [UserinfoManager sharedUserinfo].userInfo.userid;
        NSString *url = [NSString stringWithFormat:@"%@%@?&userid=%@",hostUrl,@"survey/showsurvey.php",uid];
        WebVC *web = [[WebVC alloc]initWithWebPath:url];
        web.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:web animated:YES];
       
    }
}
- (void)goToJiHuo{
    [BaseIndicatorView showInView:self.view];
    @weakify(self)
    self.task = [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationJiHuo params:nil success:^(id result) {
        @strongify(self)
        [BaseIndicatorView hideWithAnimation:self.didShow];
        
        [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
        [self pushToNextItemWithUrl:[result[@"data"] firstObject][@"redirect_url"]];
    } failure:^( id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
    
    
}
-(void)gotoJieKuan{
  
    NSString *url = [NSString stringWithFormat:@"%@html/borrow_alldai.html",hostUrl];
    WebVC *web = [[WebVC alloc]initWithWebPath:url];
    web.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:web animated:YES];
}
- (void)pushToNextItemWithUrl:(NSString *)url{
    [self.navigationController pushViewController:[HKWebVC webVCWithWebPath:url] animated:YES];
}

#pragma mark - action
- (IBAction)login {
    
    LoginNavigationController *loginController = [AiMiApplication obtainControllerForStoryboard:LOGIN_STORYBOARD_NAME controller:LOGIN_NAVIGARION_STORYBOARD_ID];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tabBarController presentViewController:loginController animated:YES completion:nil];
    });
}
- (IBAction)registerAccount {
    
    LoginNavigationController *loginController = [AiMiApplication obtainControllerForStoryboard:LOGIN_STORYBOARD_NAME controller:LOGIN_NAVIGARION_STORYBOARD_ID];
    [loginController changeRootViewControllerForRegister];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tabBarController presentViewController:loginController animated:YES completion:nil];
    });
}
- (IBAction)showMoneyDetail:(UIButton *)sender {
}
- (void)fetchAccountInfo {
    if (![UserinfoManager sharedUserinfo].logined) {
        return;
    }
    
    [self.indicatorView startAnimating];
    @weakify(self)
    self.task = [[UserinfoManager sharedUserinfo] startRequest:kUserinfoOperationAccountInfo params:nil success:^(id result) {
        @strongify(self)
        [self.headerView reloadWarmingView];
        [self.indicatorView stopAnimating];
        [self showWarmView];
    } failure:^(id result, NSString *errorDescription) {
        @strongify(self)
        [self.indicatorView stopAnimating];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
}

#pragma mark - getter & setter
- (NSArray *)functionInfo {
    
    if (!_functionInfo) {
        _functionInfo  = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:UserinfoFunctionAssetName ofType:nil]];
    }
    return _functionInfo;
}
- (UIActivityIndicatorView *)indicatorView {
    
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.hidesWhenStopped = YES;
        UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:_indicatorView];
        self.navigationItem.rightBarButtonItem = rightItem;;
    }
    return _indicatorView;
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([UserinfoManager sharedUserinfo].logined || [SETTING_SEGUE_IDENTIFIER isEqualToString:identifier]) {
        
        if ( ([RECHARGE_SEGUE_IDENTIFIER isEqualToString:identifier] || [WITHDRAW_SEGUE_IDENTIFIER isEqualToString:identifier]) && ([[UserinfoManager sharedUserinfo].userInfo.is_activate_hkaccount integerValue] != 1  || [[UserinfoManager sharedUserinfo].userInfo.is_bind_bankcard integerValue] != 1)) {
            
            if ([[UserinfoManager sharedUserinfo].userInfo.is_activate_hkaccount integerValue] != 1 ) {
                [self showWarmView];
            }else if ([[UserinfoManager sharedUserinfo].userInfo.is_bind_bankcard integerValue] != 1 ) {
                [self.navigationController pushViewController:[AiMiApplication obtainControllerForStoryboard:@"Main" controller:NSStringFromClass([BingDingCardVC class])] animated:YES ];
            }
            //            else{
            
            //            }
            
            return NO;
        }
        
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    } else {
        
        [self login];
        return NO;
    }
}
- (WarmmingView *)warmmingView{
    if (!_warmmingView) {
        _warmmingView = [[WarmmingView alloc]init];
    }
    return _warmmingView;
}


@end

