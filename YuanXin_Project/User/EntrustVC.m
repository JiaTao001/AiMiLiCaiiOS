//
//  EntrustVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/5/3.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "EntrustVC.h"

#import "RegularEntrustVC.h"
#import "OptimizationEntrustVC.h"

#import "MJRefresh.h"
#import "EntrustCell.h"
#import "StateTableView.h"
#import "WebVC.h"
#import "ExclusiveButton.h"
#import "EntrustViewModel.h"
#import "AiMiApplication.h"
#import "EntrustVCMenuView.h"
@interface EntrustVC () <UITableViewDataSource,UITableViewDelegate>

//@property (strong, nonatomic) EntrustViewModel *optimizationEntrust;
@property (strong, nonatomic) EntrustViewModel *regularEntrust;
@property (strong, nonatomic) EntrustVCMenuView *menuView;
@property (strong, nonatomic) BaseViewModel *baseViewModel;
//@property (assign, nonatomic) EntrustType showType;

@property (strong, nonatomic) IBOutlet ExclusiveButton    *exclusiveButtons;
//@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *lineX;
@property (weak, nonatomic  ) IBOutlet StateTableView     *entrustTableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (strong, nonatomic) UIButton *addedEntrust;

@property (strong,nonatomic)RegularEntrustVC *regularEntrustVC;
@end

@implementation EntrustVC
//@synthesize showType = _showType;


- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    
    self.addedEntrust = [self layoutNavigationRightButtonWithImage:[UIImage imageNamed:@"sandian2(2)"] block :^(EntrustVC *viewController) {
        
        self.menuView  = [[EntrustVCMenuView alloc]initWithFrame:self.view.bounds];
        @weakify(self)
       self.menuView.changeStateBlock = ^(NSInteger i) {
            @strongify(self)
              [self.menuView dissMiss];
           if (i == 0) {
                 [self.navigationController pushViewController:[WebVC webVCWithWebPath:[CommonTools completeWebPathWithSubpath: Introduct_Entrust ]] animated:YES];
           }else{
                [(EntrustVC *)self performSegueWithIdentifier:To_Optimization_Entrust_Segue_Identifier sender:nil ];
           }
           
        };

        [[UIApplication sharedApplication].keyWindow addSubview:self.menuView];
        
        

    }];
    
//    [self.entrustTableView.header beginRefreshing];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      [self.entrustTableView.header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.regularEntrust cancelFetchOperation];
}

- (IBAction)addButtonClicked:(id)sender {
    [(EntrustVC *)self performSegueWithIdentifier:To_Regular_Entrust_Segue_Identifier sender:nil ];
}


//#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.regularEntrust.entrustInfo.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EntrustCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntrustCell"];
    
    [cell loadInterfaceWithDictionary:self.regularEntrust.entrustInfo[indexPath.row]];
    @weakify(self)
    cell.changeStateBlock = ^(UISwitch *entrustSwitch) {
        @strongify(self)
        
        NSMutableDictionary *params = [[UserinfoManager sharedUserinfo] increaseUserParams:nil];
        NSDictionary *dict = [self.regularEntrust.entrustInfo objectAtIndex:indexPath.row];
        [params setObject:dict[@"id"] forKey:@"id"];
        if (entrustSwitch.on) {
            [params setObject:@"0" forKey:@"status"];
        }else{
            [params setObject:@"2" forKey:@"status"];
        }
        
      
   
        [self.baseViewModel postMethod:@"auto_delete" params:params success:^(id result) {
   
            
            [SpringAlertView showMessage:result[RESULT_REMARK]];
          
         
            
        } failure:^(id result, NSString *errorDescription) {
            
            [SpringAlertView showMessage:errorDescription];
        }];

        
//        [BaseIndicatorView showInView:self.view maskType:kIndicatorMaskContent];
//        [[self showEntrust] changeEntrustStateWithIndex:indexPath.row on:entrustSwitch.on success:^(id result) {
//            @strongify(self)
//            
//            [BaseIndicatorView hideWithAnimation:self.didShow];
//            [self.entrustTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        } failure:^(NSString *errorDescription) {
//            @strongify(self)
//            
//            [BaseIndicatorView hideWithAnimation:self.didShow];
//            entrustSwitch.on = !entrustSwitch.on;
//            [SpringAlertView showMessage:errorDescription];
//        }];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     RegularEntrustVC *reguleVC = [AiMiApplication obtainControllerForMainStoryboardWithID:@"RegularEntrustVC"];
    reguleVC.dataDic = self.regularEntrust.entrustInfo[indexPath.row];
    [self.navigationController pushViewController:reguleVC animated:YES];

}
//左划删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                             NSLog(@"删除");
                                                                             NSMutableDictionary *params = [[UserinfoManager sharedUserinfo] increaseUserParams:nil];
                                                                             NSDictionary *dict = [self.regularEntrust.entrustInfo objectAtIndex:indexPath.row];
                                                                             [params setObject:dict[@"id"] forKey:@"id"];
                                                                             
                                                                             [params setObject:@"1" forKey:@"status"];
                                                                             @weakify(self)
                                                                             [self.baseViewModel postMethod:@"auto_delete" params:params success:^(id result) {
                                                                                 @strongify(self)
                                                                                 
                                                                                 [SpringAlertView showMessage:result[RESULT_REMARK]];
                                                                                 // 从数据源中删除
                                                                                 
                                                                                 [self.regularEntrust.entrustInfo removeObjectAtIndex:indexPath.row];
                                                                                 //    // 从列表中删除
                                                                                 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]  withRowAnimation:UITableViewRowAnimationNone];
                                                                                 
                                                                                 
                                                                             } failure:^(id result, NSString *errorDescription) {
                                                                                 
                                                                                 [SpringAlertView showMessage:errorDescription];
                                                                             }];
                                                                             
                                                                         }];
    
//    UITableViewRowAction *rowActionSec = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
//                                                                            title:@"快速备忘"    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//                                                                                NSLog(@"快速备忘");
//                                                                                
//                                                                            }];
//    rowActionSec.backgroundColor = [UIColor grayColor];
    rowAction.backgroundColor = RGB(0xCCCCCC);
    
    NSArray *arr = @[rowAction];
    return arr;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//      NSMutableDictionary *params = [[UserinfoManager sharedUserinfo] increaseUserParams:nil];
//    NSDictionary *dict = [self.regularEntrust.entrustInfo objectAtIndex:indexPath.row];
//    [params setObject:dict[@"id"] forKey:@"id"];
//    
//     [params setObject:@"1" forKey:@"status"];
//    @weakify(self)
//    [self.baseViewModel postMethod:@"auto_delete" params:params success:^(id result) {
//        @strongify(self)
//        
//        [SpringAlertView showMessage:result[RESULT_REMARK]];
//        // 从数据源中删除
//        
//        [self.regularEntrust.entrustInfo removeObjectAtIndex:indexPath.row];
//        //    // 从列表中删除
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]  withRowAnimation:UITableViewRowAnimationNone];
//
//       
//    } failure:^(id result, NSString *errorDescription) {
//        
//        [SpringAlertView showMessage:errorDescription];
//    }];
// }
#pragma mark - setter

- (void)setEntrustTableView:(StateTableView *)entrustTableView {
    _entrustTableView = entrustTableView;
    
    @weakify(self)
    entrustTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        
        [self.regularEntrust beginFetchEntrustWithSuccess:^(id result) {
            @strongify(self)
            self.entrustTableView.type = 0 == self.regularEntrust.entrustInfo.count ? kTableStateNoInfo : kTableStateNormal;
            [self.entrustTableView.header endRefreshing];
            [self.entrustTableView reloadData];
        } failure:^(NSString *errorDescription) {
            @strongify(self)
            
//            self.entrustTableView.type = ( errorDescription && 0 == [self showEntrust].entrustInfo.count) ? kTableStateNetworkError : kTableStateNormal;
            [self.entrustTableView.header endRefreshing];
            [SpringAlertView showMessage:errorDescription];
        }];
    }];
//    entrustTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        @strongify(self)
//        
//        [self.regularEntrust fetchNextPageEntrustWithSuccess:^(id result) {
//            @strongify(self)
//            
//            [self.entrustTableView.footer endRefreshing];
//            [self.entrustTableView reloadData];
//        } failure:^(NSString *errorDescription) {
//            @strongify(self)
//            
//            [self.entrustTableView.footer endRefreshing];
//            [SpringAlertView showMessage:errorDescription];
//        }];
//    }];
//    
    [entrustTableView setClickCallBack:^{
        @strongify(self)
        
        [self.entrustTableView.header beginRefreshing];
    }];
}
////- (void)setShowType:(EntrustType)showType {
////    
////    _showType = showType;
////    
////    [self.entrustTableView reloadData];
////    if ([self needRefresh:showType]) {
////        [self.entrustTableView.header endRefreshing];
////        [self.entrustTableView.header beginRefreshing];
////    } else {
////        self.entrustTableView.type = kTableStateNormal;
////    }
////}
//- (BOOL)needRefresh:(EntrustType) type {
//    
//    return (kEntrustRegular == type && !self.regularEntrust.entrustInfo.count) || (kEntrustOptimization == type && !self.optimizationEntrust.entrustInfo.count);
//}
//- (EntrustViewModel *)showEntrust {
//    
//    return kEntrustRegular ==  self.regularEntrust ;
//}

//#pragma mark - getter
- (EntrustViewModel *)regularEntrust {
    
    if (!_regularEntrust) {
        _regularEntrust = [[EntrustViewModel alloc] init];
        _regularEntrust.type = kEntrustRegular;
    }
    return _regularEntrust;
}

- (BaseViewModel *)baseViewModel {
    if (!_baseViewModel) {
        _baseViewModel = [[BaseViewModel alloc] init];
    }
    return _baseViewModel;
}
//- (EntrustViewModel *)optimizationEntrust {
//    
//    if (!_optimizationEntrust) {
//        _optimizationEntrust = [[EntrustViewModel alloc] init];
//        _optimizationEntrust.type = kEntrustOptimization;
//    }
//    return _optimizationEntrust;
//}
//
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    [super prepareForSegue:segue sender:sender];
//    
//    if ([segue.destinationViewController respondsToSelector:@selector(setEntrustSuccess:)]) {
//        [segue.destinationViewController setEntrustSuccess:^{
//            
//            [self.entrustTableView.header beginRefreshing];
//        }];
//    }
//}
@end
