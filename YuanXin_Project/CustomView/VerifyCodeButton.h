//
//  AuthCodeButton.h
//  wujin-tourist
//
//  Created by wujin  on 15/7/15.
//  Copyright (c) 2015年 wujin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SMS_SEND @"send"
#define VERIFY_CODE_TYPE_KEY @"type"
#define AUTHCODE_REPEAT_INTERVAL 60

@interface VerifyCodeButton : UIButton

- (void)countDown:(NSInteger)count;
@end
