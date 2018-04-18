//
//  AnnouncementsVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/20.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "AnnouncementsVC.h"

#import "AnnouncementDetailVC.h"

#import "MJRefresh.h"
#import "StateTableView.h"

#import "BaseViewModel.h"

@implementation AnnouncementCell

@end


@interface AnnouncementsVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet StateTableView *announcementsTableView;

@property (strong, nonatomic) NSMutableArray *announcements;
@property (strong, nonatomic) BaseViewModel  *viewModel;
@property (assign, nonatomic) NSInteger      page;

@end

@implementation AnnouncementsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.announcementsTableView.header beginRefreshing];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.viewModel cancelFetchOperation];
}

- (void)fetchAnnouncementsWithIndex:(NSInteger)page complete:( void(^)(id result, BOOL success)) complete {
    
    @weakify(self)
    [self.viewModel postMethod:@"noticelist" params:@{@"pageqty":@(Each_Page_Num), @"currentpage":@(page)} success:^(id result) {
        
        if (complete) {
            complete(result, YES);
        }
    } failure:^(id result, NSString *errorDescription) {
        @strongify(self)
        
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
        if (complete) {
            complete(result, NO);
        }
    }];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.announcements.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    id（公告id）、title（公告标题）、issucedate（发布时间）
    AnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnnouncementCell class])];
    
    cell.title.text = self.announcements[indexPath.section][@"title"];
    cell.time.text = self.announcements[indexPath.section][@"issucedate"];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return MARGIN_DISTANCE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AnnouncementDetailVC *vc = [[AnnouncementDetailVC alloc] init];
    
    AnnouncementInfo *info = [[AnnouncementInfo alloc] init];
    info.announcementId = self.announcements[indexPath.section][@"id"];
    vc.annoucementInfo = info;
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - setter
- (void)setAnnouncementsTableView:(StateTableView *)announcementsTableView {
    _announcementsTableView = announcementsTableView;
    
    announcementsTableView.sectionFooterHeight = 0;
    
    @weakify(self)
    announcementsTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        
        [self fetchAnnouncementsWithIndex:1 complete:^(id result, BOOL success) {
            [self.announcementsTableView.header endRefreshing];
            
            if (success) {
                [self.announcements removeAllObjects];
                self.page = 1;
                [self addFetchedAnnouncements:result[RESULT_DATA]];
            } else {
                [self didFailLoad];
            }
        }];
    }];
    announcementsTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        
        [self fetchAnnouncementsWithIndex:self.page + 1 complete:^(id result, BOOL success) {
            [self.announcementsTableView.footer endRefreshing];
            
            if (success) {
                self.page += 1;
                [self addFetchedAnnouncements:result[RESULT_DATA]];
            } else {
                [self didFailLoad];
            }
        }];
    }];
    
    [announcementsTableView setClickCallBack:^{
        @strongify(self)
        
        [self.announcementsTableView.header beginRefreshing];
    }];
}
- (void)didFailLoad {
    
    if (!self.announcements.count) { //没有数据时
        self.announcementsTableView.type = kTableStateNetworkError;
    }
}

- (void)addFetchedAnnouncements:(NSArray *)announcements {
    if (nil == announcements) return;
    
    [self.announcements addObjectsFromArray:announcements];
    self.announcementsTableView.type = 0 == self.announcements.count ? kTableStateNoInfo : kTableStateNormal;
    [self.announcementsTableView reloadData];
}

#pragma mark - getter
- (BaseViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[BaseViewModel alloc] init];
    }
    return _viewModel;
}
- (NSMutableArray *)announcements {
    
    if (!_announcements) {
        _announcements = [NSMutableArray array];
    }
    return _announcements;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
