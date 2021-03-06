//
//  TodayViewController.m
//  AiMiTodayExtensionVC
//
//  Created by Yuanin on 16/11/11.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
//#import "Userinfo.h"
//#import "UserinfoManager.h"
@interface TodayViewController () <NCWidgetProviding>
//收益
@property (weak, nonatomic) IBOutlet UILabel *EarnMoneyLB;
//可用余额
@property (weak, nonatomic) IBOutlet UILabel *BalanceLB;
//账户资产
@property (weak, nonatomic) IBOutlet UILabel *SumPropertyLB;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults*shared = [[NSUserDefaults alloc]initWithSuiteName:@"group.com.yuanin.widge"];
    
    
    
    if ( [shared boolForKey:@"IsLog"]) {
        
        NSString *amount = [shared objectForKey:@"amount"];
        self.SumPropertyLB.text = [NSString stringWithFormat:@"%.2f",[amount floatValue]];
        
        NSString *balance = [shared objectForKey:@"balance"];
        self.BalanceLB.text =  [NSString stringWithFormat:@"%.2f",[balance floatValue]];
        
        NSString *interest = [shared objectForKey:@"interest"];
        
        self.EarnMoneyLB.text = [NSString stringWithFormat:@"%.2f",[interest floatValue]];
        
        
        
    }else{
        self.EarnMoneyLB.text = @"--";
        self.BalanceLB.text = @"--";
        self.SumPropertyLB.text = @"--";
    }
    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
 
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSUserDefaults*shared = [[NSUserDefaults alloc]initWithSuiteName:@"group.com.yuanin.widge"];
    
    
    
    if ( [shared boolForKey:@"IsLog"]) {
        
        NSString *amount = [shared objectForKey:@"amount"];
        self.SumPropertyLB.text = [NSString stringWithFormat:@"%.2f",[amount floatValue]];
        
         NSString *balance = [shared objectForKey:@"balance"];
         self.BalanceLB.text =  [NSString stringWithFormat:@"%.2f",[balance floatValue]];
        
        NSString *interest = [shared objectForKey:@"interest"];
        
        self.EarnMoneyLB.text = [NSString stringWithFormat:@"%.2f",[interest floatValue]];
       
        
        
    }else{
        self.EarnMoneyLB.text = @"--";
        self.BalanceLB.text = @"--";
        self.SumPropertyLB.text = @"--";
    }
    
    
}
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //通过extensionContext借助host app调起app
    [self.extensionContext openURL:[NSURL URLWithString:@"aimilicai://"] completionHandler:^(BOOL success) {
        NSLog(@"open url result:%d",success);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
