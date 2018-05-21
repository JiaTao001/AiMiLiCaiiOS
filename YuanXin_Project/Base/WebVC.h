//
//  WebVC.h
//  YuanXin_Project
//
//  Created by Yuanin on 15/10/29.
//  Copyright © 2015年 yuanxin. All rights reserved.
//

#import "BaseViewController.h"

#define Introduce_Safe      @"html/security.php"
#define Introduce_Help      @"html/help.php"
#define Introduce_Protocol  @"html/userprotocol.php"
#define Introduce_Buy       @"html/buyprotocols.php"
#define Introduct_Bind_Bank @"html/bandbankcard.php"
#define Introduct_Entrust   @"html/wtrule.php"
#define Data_Report         @"html/datareport.php"
@interface WebVC : BaseViewController  <UIWebViewDelegate>

@property (strong, nonatomic, readonly) UIWebView *webView;

@property (strong, nonatomic) NSString *webPath;

- (instancetype)initWithWebPath:(NSString *)webPath;
+ (instancetype)webVCWithWebPath:(NSString *)webPath;

/**
 *       Subclass Custom Action
 */
- (void)configureNavifationLeftButton;

@end
