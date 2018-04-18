//
//  AccountBalanceVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/13.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "AccountPropertyVC.h"
#import "PropertyInformationVC.h"

@interface AccountPropertyVC ()

@property (strong, nonatomic) NSURLSessionTask *task;

@property (weak, nonatomic) IBOutlet UIScrollView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *regularMoney;
@property (weak, nonatomic) IBOutlet UILabel *regularInterest;
@property (weak, nonatomic) IBOutlet UILabel *regularWaitInterest;
@property (weak, nonatomic) IBOutlet UILabel *disperseMoney;
@property (weak, nonatomic) IBOutlet UILabel *disperseInterest;
@property (weak, nonatomic) IBOutlet UILabel *disperseWaitInterest;
@property (weak, nonatomic) IBOutlet UILabel *rewardsMoney;
@property (weak, nonatomic) IBOutlet UILabel *rewardsDidAccept;
@property (weak, nonatomic) IBOutlet UILabel *rewardsWaitAccept;
@property (weak, nonatomic) IBOutlet UILabel *balanceMoney;
@property (weak, nonatomic) IBOutlet UILabel *balanceInvalid;
@property (weak, nonatomic) IBOutlet UILabel *balanceInProgress;

@end

@implementation AccountPropertyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(UIViewController *viewController) {
        
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    
    self.contentView.hidden = YES;
    
    [self fetchAccountProperty];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}

#pragma mark - action
- (IBAction)intoPropertyInfomationVC:(UIButton *)sender {
    
    PropertyInformationVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:Property_Regular_Storyboard_Id];
    vc.propertyType = sender.tag - 200;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)fetchAccountProperty {
    
    [BaseIndicatorView showInView:self.view maskType:kIndicatorNoMask];
    
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"totalaccountamount" params:[[UserinfoManager sharedUserinfo] increaseUserParams:nil] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [self configureInterface:[result[RESULT_DATA] firstObject]];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showMessage:errorDescription];
    }];
    
}

- (void)configureInterface:(NSDictionary *)aDic {
    
//    返回值  deposit（投资定期金额）、deposit_interest（投资定期已收利息）、wait_deposit_interest（投资定期代收利息）、enjoy（投资爱米优选金额）、enjoy_interest（投资爱米优选已收利息）、wait_enjoy_interest（投资爱米优选代收利息）、all_reward_amount（奖励金额）、reward_amount（已收奖励）、wait_reward_amount（待收奖励）、balance（可用余额）、appoint（冻结中金额）、withdraw_amount（提现中金额）
    NSParameterAssert(aDic);
    
    self.regularMoney.text         = [CommonTools convertToStringWithObject:aDic[@"deposit"]];
    self.regularInterest.text      = [CommonTools convertToStringWithObject:aDic[@"deposit_interest"]];
    self.regularWaitInterest.text  = [CommonTools convertToStringWithObject:aDic[@"wait_deposit_interest"]];
    self.disperseMoney.text        = [CommonTools convertToStringWithObject:aDic[@"enjoy"]];
    self.disperseInterest.text     = [CommonTools convertToStringWithObject:aDic[@"enjoy_interest"]];
    self.disperseWaitInterest.text = [CommonTools convertToStringWithObject:aDic[@"wait_enjoy_interest"]];
    self.rewardsMoney.text         = [CommonTools convertToStringWithObject:aDic[@"all_reward_amount"]];
    self.rewardsDidAccept.text     = [CommonTools convertToStringWithObject:aDic[@"reward_amount"]];
    self.rewardsWaitAccept.text    = [CommonTools convertToStringWithObject:aDic[@"wait_reward_amount"]];
    self.balanceMoney.text         = [CommonTools convertToStringWithObject:aDic[@"balance"]];
    self.balanceInvalid.text       = [CommonTools convertToStringWithObject:aDic[@"appoint"]];
    self.balanceInProgress.text    = [CommonTools convertToStringWithObject:aDic[@"withdraw_amount"]];
    
    self.contentView.hidden = NO;
}
                      



// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    [super prepareForSegue:segue sender:sender];
//    
//    if ([Property_PlanOfGod_Segue_Identifier isEqualToString:segue.identifier]) {
//        PropertyInformationVC *vc = (PropertyInformationVC *)segue.destinationViewController;
//        vc.type = kPropertyPlanOfGod;
//    } else if ([Property_Regular_Segue_Identifier isEqualToString:segue.identifier]) {
//        PropertyInformationVC *vc = (PropertyInformationVC *)segue.destinationViewController;
//        vc.type = kPropertyRegular;
//    }
//}

@end
