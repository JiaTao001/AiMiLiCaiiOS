//
//  BonusVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/13.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "RewardVC.h"

#import "BonusCell.h"
#import "ExperienceCell.h"
#import "MJRefresh.h"
#import "HorizontalScrollView.h"
#import "StateTableView.h"

#import "ExclusiveButton.h"
#import "RewardViewModel.h"

@interface RewardVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSURLSessionTask *task;

@property (copy, nonatomic) void(^callBack)(NSDictionary *bonusInfo);
@property (strong, nonatomic) NSString *money;

@property (weak, nonatomic) IBOutlet UIView *subView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint   *lineX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint   *upViewHeight;
@property (weak, nonatomic) IBOutlet HorizontalScrollView *contentView;
@property (strong, nonatomic) IBOutlet ExclusiveButton *exclusiveButtons;

@property (strong, nonatomic) StateTableView *bonusTable;
@property (strong, nonatomic) RewardViewModel *bonusViewModel;
@property (strong, nonatomic) StateTableView *experienceTable;
@property (strong, nonatomic) RewardViewModel *experienceViewModel;

@property (assign,nonatomic)BOOL isValidBouns;
@end

@implementation RewardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(UIViewController *viewController) {
        
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    NSMutableArray *subViews = [NSMutableArray array];
    if (self.callBack) {
        [subViews addObject:self.bonusTable];
        self.bonusTable.separatorStyle =UITableViewCellSeparatorStyleNone;
    }else{
    UIScrollView *view = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.bonusTable.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 183);
        self.bonusTable.separatorStyle =UITableViewCellSeparatorStyleNone;
    [view addSubview:self.bonusTable];
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 183,  [UIScreen mainScreen].bounds.size.width, 70)];
//    view2.backgroundColor = [UIColor redColor];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, 20, 200, 30)];
        [btn setTitle:@"没有更多有效券｜查看无效券》" forState:UIControlStateNormal];
        [btn setTitle:@"没有更多无效券｜查看有效券》" forState:UIControlStateSelected];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [btn addTarget:self action:@selector(noUseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view2 addSubview:btn];

    [view addSubview:view2];
        [subViews addObject:view];
    }

    if (!self.callBack) {
        [subViews addObject:self.experienceTable];
    } else {
        self.upViewHeight.constant    = 0;
        self.subView.superview.hidden = YES;
    }
    

    self.isValidBouns = YES;

    self.contentView.contentSubviews = subViews;
    
     [self.bonusTable.header beginRefreshing];
  
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}

#pragma mark - public

- (void)setMoneyShare:(NSString *)money callBack:(void(^)(NSDictionary *bonusInfo) ) callBack {
    
    self.money = money;
    self.callBack = callBack;
}

#pragma mark - UITableView dataSource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return tableView == self.bonusTable ? self.bonusViewModel.rewardInfo.count  : self.experienceViewModel.rewardInfo.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSArray *allInfo = tableView == self.bonusTable ? self.bonusViewModel.rewardInfo : self.experienceViewModel.rewardInfo;
   
    
    RewardCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RewardCell class])];
    if (indexPath.section < allInfo.count) {
         [cell configureCellWithInfo:allInfo[indexPath.section]];
    }
    
   
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.contentView) {
        self.lineX.constant = self.contentView.contentOffset.x/self.contentView.contentSubviews.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, tableView.sectionHeaderHeight)];
    tmpView.backgroundColor = [UIColor clearColor];
    return tmpView;
}

- (void)noUseBtnClicked:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.isValidBouns = !self.isValidBouns;

    if (self.isValidBouns) {
        _bonusViewModel.needValid = 1;
    }
    if (!self.isValidBouns) {
        _bonusViewModel.needValid = 2;
    }

    [self.bonusTable.header beginRefreshing];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.bonusTable) {
        if (self.callBack) {
            
            NSDictionary *bonusInfo = self.bonusViewModel.rewardInfo[indexPath.section];
            
            if (self.money.doubleValue < [bonusInfo[@"min_invest_amount"] doubleValue]) {
                
                [AlertViewManager showInViewController:self title:nil message:@"多投点吧，您还不能使用这个红包！" clickedButtonAtIndex:nil cancelButtonTitle:NSLocalizedString(@"confirm", nil) otherButtonTitles:nil];
            } else {
            
                [self.navigationController popViewControllerAnimated:YES];
                self.callBack(bonusInfo);
            }
        }
    } else {
        
        if (0 == [self.experienceViewModel.rewardInfo[indexPath.section][@"status"] integerValue]) {
            [AlertViewManager showInViewController:self title:@"提示" message:@"您确定要使用体验金吗？" clickedButtonAtIndex:^(id alertView, NSInteger buttonIndex) {
                
                if (1 == buttonIndex) {
                    [self useExperience:self.experienceViewModel.rewardInfo[indexPath.section][@"id"]];
                }
            } cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"confirm", nil), nil];
        }
    }
}

#pragma mark - private method
- (void)useExperience:(NSString *)experienceID {
    
    NSMutableDictionary *params = [[UserinfoManager sharedUserinfo] increaseUserParams:nil];
    [params setValue:experienceID forKey:@"productid"];
    
    [BaseIndicatorView showInView:self.view];
    
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"useexperiencegold" params:params success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [self.experienceTable.header beginRefreshing];
        [BaseIndicatorView hideWithAnimation:self.didShow];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showMessage:errorDescription];
    }];
}

- (void)configureTableView:(UITableView *)tableView {
    
    tableView.backgroundColor = Background_Color;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 100;
    tableView.sectionHeaderHeight = 10;
    

    
    tableView.dataSource = self;
    tableView.delegate = self;
}
- (BOOL)needAutoRefreshing:(UITableView *)tableView {
    
    return tableView == self.bonusTable ? !(BOOL)self.bonusViewModel.rewardInfo : !(BOOL)self.experienceViewModel.rewardInfo;
}

#pragma mark -  setter & getter
- (void)setExclusiveButtons:(ExclusiveButton *)exclusiveButtons {
    _exclusiveButtons = exclusiveButtons;
    
    @weakify(self)
    exclusiveButtons.invalidButtonWillChangeBlock = ^(UIButton *newInvalidButton) {
        @strongify(self)
        
        self.contentView.contentOffset = CGPointMake((newInvalidButton.tag -1)*CGRectGetWidth(self.contentView.frame), 0);
        
        if ([self needAutoRefreshing:self.contentView.presentingSubview]) {
            [((UITableView *)self.contentView.presentingSubview).header beginRefreshing];
        }
    };
}

- (StateTableView *)bonusTable {
    
    if (!_bonusTable) {
        _bonusTable = [[StateTableView alloc] init];
        _bonusTable.backgroundColor = [UIColor redColor];
        
        [_bonusTable registerNib:[UINib nibWithNibName:NSStringFromClass([BonusCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RewardCell class])];

        [self performSelectorOnMainThread:@selector(configureTableView:) withObject:_bonusTable waitUntilDone:NO];

    
      
        
        
        @weakify(self)
        _bonusTable.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self.bonusViewModel beginFetchRewardWithSuccess:^(id result) {
                @strongify(self)
                
                self.bonusTable.type = 0 == self.bonusViewModel.rewardInfo.count ? kTableStateNoInfo : kTableStateNormal;

                [self.bonusTable.header endRefreshing];
                [self.bonusTable reloadData];

            } failure:^(NSString *errorDescription) {
                @strongify(self)
                
                self.bonusTable.type = (errorDescription && 0 == self.bonusViewModel.rewardInfo.count) ? kTableStateNetworkError : kTableStateNormal;
                [self.bonusTable.header endRefreshing];
                [SpringAlertView showMessage:errorDescription];
            }];
        }];
        _bonusTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self.bonusViewModel fetchNextPageRewardWithSuccess:^(id result) {
                @strongify(self)

                [self.bonusTable.footer endRefreshing];
                [self.bonusTable reloadData];
            } failure:^(NSString *errorDescription) {
                @strongify(self)
                
                [self.bonusTable.footer endRefreshing];
                [SpringAlertView showMessage:errorDescription];
            }];
        }];
        
        [_bonusTable setClickCallBack:^{
            @strongify(self)
            
            [self.bonusTable.header beginRefreshing];
        }];
    }
   
    return _bonusTable;
}
- (RewardViewModel *)bonusViewModel {
    
    if (!_bonusViewModel) {
        RewardViewModel *viewModel = [[RewardViewModel alloc] init];
        viewModel.needValid = self.callBack ? 1 : 1;
        viewModel.type = kRewardBonus;
        
        _bonusViewModel = viewModel;
    }
    return _bonusViewModel;
}
- (StateTableView *)experienceTable {
    
    if (!_experienceTable) {
        _experienceTable = [[StateTableView alloc] init];
        [_experienceTable registerNib:[UINib nibWithNibName:NSStringFromClass([ExperienceCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RewardCell class])];
        
        [self performSelectorOnMainThread:@selector(configureTableView:) withObject:_experienceTable waitUntilDone:NO];
        
        @weakify(self)
        _experienceTable.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self.experienceViewModel beginFetchRewardWithSuccess:^(id result) {
                @strongify(self)
                
                self.experienceTable.type = 0 == self.experienceViewModel.rewardInfo.count ? kTableStateNoInfo : kTableStateNormal;
                [self.experienceTable.header endRefreshing];
                [self.experienceTable reloadData];
            } failure:^(NSString *errorDescription) {
                @strongify(self)
                
                self.experienceTable.type = (errorDescription && 0 == self.experienceViewModel.rewardInfo.count) ? kTableStateNetworkError : kTableStateNormal;
                [self.experienceTable.header endRefreshing];
                [SpringAlertView showMessage:errorDescription];
            }];
        }];
        _experienceTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self)
            [self.experienceViewModel fetchNextPageRewardWithSuccess:^(id result) {
                @strongify(self)
                
                [self.experienceTable.footer endRefreshing];
                [self.experienceTable reloadData];
            } failure:^(NSString *errorDescription) {
                @strongify(self)
                
                [self.experienceTable.footer endRefreshing];
                [SpringAlertView showMessage:errorDescription];
            }];
        }];
        
        [_experienceTable setClickCallBack:^{
            @strongify(self)
            [self.experienceTable.header beginRefreshing];
        }];
    }
    return _experienceTable;
}
- (RewardViewModel *)experienceViewModel {
    if (!_experienceViewModel) {
        RewardViewModel *viewModel = [[RewardViewModel alloc] init];
        viewModel.needValid = 0;
        viewModel.type = kRewardExperience;
        
        _experienceViewModel = viewModel;
    }
    return _experienceViewModel;
}



@end
