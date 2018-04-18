//
//  AboutUsTVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/14.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "AboutUsTVC.h"

#import "WebVC.h"

#import "MessageForwarder.h"
#import "TransitionAnimation.h"
#import "InteractiveTransition.h"

@interface AboutUsTVC () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *appName;

@end

@implementation AboutUsTVC

#pragma mark - life cycle 
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarAlpha = 1.0f;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    if ([self.tableView respondsToSelector:@selector(layoutMargins)])
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(layoutMargins)]) cell.layoutMargins = UIEdgeInsetsZero;
    
    NSInteger numberOfRowsInSection = [tableView numberOfRowsInSection:indexPath.section];
    if (numberOfRowsInSection - 1 == indexPath.row) {
        cell.separatorInset = UIEdgeInsetsZero;
    } else {
        cell.separatorInset = UIEdgeInsetsMake(0, CUSTOM_LINE_MRGIN, 0, 0);
    }
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, tableView.sectionHeaderHeight)];
    tmpView.backgroundColor = [UIColor clearColor];
    return tmpView;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:[[WebVC alloc] initWithWebPath:[CommonTools completeWebPathWithSubpath:1 == indexPath.row ? Introduce_Help : Introduce_Safe]] animated:YES];
            });
        } break;
            
        case 1: {
            if (0 == indexPath.row) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", SERVICE_PHONE]]];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = [self copyStringWithRow:indexPath.row];
                    [AlertViewManager showInViewController:self title:@"提示" message:[NSString stringWithFormat:@"复制 %@ 成功", [self copyStringWithRow:indexPath.row]] clickedButtonAtIndex:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                });
            }
        } break;
            
        case 2: {
            if (1 == indexPath.row) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1055223837"]];
            }
        } break;
    }
}

- (NSString *)copyStringWithRow:(NSInteger)row {
    
    NSString *result = nil;
    
    switch (row) {
        case 1:
            result = @"www.aimilicai.com";
            break;
        case 2:
            result = @"爱米金服";
            break;
        case 3:
            result = @"kefu@aimilicai.com";
            break;
    }
    return result;
}


#pragma mark - setter & getter

- (void)setAppName:(UILabel *)appName {
    
//    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
//    NSString *app_name = [appInfo objectForKey:APP_NAME_KEY];
//    NSString *app_version = [appInfo objectForKey:APP_VERSION_KEY];
//    NSString *app_build = [appInfo objectForKey:@"CFBundleVersion"];
    
    _appName = appName;
    appName.text = [[NSString alloc] initWithFormat:@"V %@", [[NSBundle mainBundle] infoDictionary][APP_VERSION_KEY]];
}

@end
