//
//  RuleWebVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/27.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "RuleWebVC.h"
#import "InviteFriendsVC.h"

#import "SharedView.h"

#define Invite_Friend_Title   @"邀请好友"
#define Introduce_Rule      @"html/inviterule.php"

@interface RuleWebVC ()

@property (strong, nonatomic) NSURLSessionTask *task;

@property (strong, nonatomic) UIButton *inviteFriend;
@property (strong, nonatomic) UIButton *navRightButton;

@property (strong, nonatomic) SharedView *sharedView;
@property (strong, nonatomic) NSString *bonusHeaderImagePath;
@end

@implementation RuleWebVC
- (instancetype)init {
    if (self = [super initWithWebPath:[CommonTools completeWebPathWithSubpath:Introduce_Rule]]) {
        self.title = Invite_Friend_Title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navRightButton = [self layoutNavigationRightButtonWithTitle:@"邀请列表" color:nil block:^(RuleWebVC *viewController) {
        
        InviteFriendsVC *vc = [AiMiApplication obtainControllerForMainStoryboardWithID:INVITE_FRIENDS_STORYBOARD_ID];
        
        vc.sharedView = viewController.sharedView;
        vc.headerImagePath = viewController.bonusHeaderImagePath;
        
        [viewController.navigationController pushViewController:vc animated:YES];
    }];
    
    self.navRightButton.hidden = YES;
    self.inviteFriend.hidden = YES;
    [self.view addSubview:self.inviteFriend];
    
    [self fetchShareInfo];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}
- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (self.inviteFriend.translatesAutoresizingMaskIntoConstraints) {
        self.inviteFriend.translatesAutoresizingMaskIntoConstraints = NO;

        NSArray *hButCon = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inviteFriend]-0-|" options:0 metrics:nil views:@{@"inviteFriend":self.inviteFriend}];
        NSArray *vButCon = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[inviteFriend(==45)]-0-|" options:0 metrics:nil views:@{@"inviteFriend":self.inviteFriend}];
        
        [self.view addConstraints:hButCon];
        [self.view addConstraints:vButCon];
    }
}

- (void)fetchShareInfo {
        
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"getshareinvitefriends" params:[[UserinfoManager sharedUserinfo] increaseUserParams:nil] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [self didFetchInfoSuccess:[result[RESULT_DATA] firstObject]];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        
        [SpringAlertView showMessage:errorDescription];
    }];
}

- (void)didFetchInfoSuccess:(NSDictionary *)aDic {
    
    self.bonusHeaderImagePath = aDic[@"img"];
    self.sharedView = [SharedView sharedWithURL:aDic[@"shareurlurl"] title:aDic[@"sharetitle"] description:aDic[@"sharedescript"] thumbImagePath:aDic[@"sharelogo"] type:@[kSharedWechat, kSharedWechatFriend,kSharedQQ, kSharedQzone]];
    
    self.navRightButton.hidden = NO;
    self.inviteFriend.hidden = NO;
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
}


- (UIButton *)inviteFriend {
    
    if (!_inviteFriend) {
        _inviteFriend = [[UIButton alloc] init];
        
        _inviteFriend.titleLabel.font = [UIFont systemFontOfSize:Button_Font_Size];

//        [_inviteFriend setBackgroundImage:[UIImage imageNamed:@"theme_color_image"] forState:UIControlStateNormal];
        [_inviteFriend setBackgroundColor:Theme_Color];
        [_inviteFriend setBackgroundImage:[UIImage imageNamed:@"gray_color_image"] forState:UIControlStateDisabled];
        [_inviteFriend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_inviteFriend setTitle:@"邀请好友" forState:UIControlStateNormal];
        [_inviteFriend addTarget:self action:@selector(fastInviteFriend) forControlEvents:UIControlEventTouchUpInside];
        
        if (![SharedView canShared]) {
            [_inviteFriend setTitle:@"您未安装可分享软件" forState:UIControlStateNormal];
            _inviteFriend.enabled = NO;
        }
    }
    return _inviteFriend;
}

- (void)fastInviteFriend {
    
    [self.sharedView showInWindow:self.view.window];
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
