//
//  AiMiAdverView.m
//  YuanXin_Project
//
//  Created by Yuanin on 17/1/17.
//  Copyright © 2017年 yuanxin. All rights reserved.
//

#import "AiMiAdverView.h"
#import "UIImageView+LoadImage.h"
#import "NetworkContectManager.h"
@interface AiMiAdverView()



@property (strong, nonatomic, readwrite) UIButton *btn;
@property (strong, nonatomic, readwrite) UIImageView *adImage;
@property (strong, nonatomic, readwrite) UIImageView *comImage;

@property (nonatomic, strong) NSTimer *timer;//计时器
@property (nonatomic, assign) NSInteger count;//监听当前倒数的数字

@end
//static NSInteger const showTime = 3;
@implementation AiMiAdverView


- (void)viewDidLoad{
    [super viewDidLoad ];
//    [NetworkContectManager sessionPOSTWithMothed:@"intro" params:nil success:^(NSURLSessionTask *task, id result) {
////        [self.adImage loadImageWithPath:result[@"data"][0][@"src"] ];
//        
//     } failure:nil];
    NSString *imageSrc = [[NSUserDefaults standardUserDefaults] objectForKey:@"adverImageSrc"];
    [self.adImage loadImageWithPath: imageSrc placeholderImage:nil complete:nil];
    self.comImage.backgroundColor = [UIColor clearColor];
    self.btn.backgroundColor = [UIColor clearColor];
    //3.定时器
    _count = 3;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];

}
+ (BOOL)canShow {
    BOOL adverShow = [[NSUserDefaults standardUserDefaults]boolForKey:@"adverShow"];
    if (!adverShow) {
        return NO;
    }
    
     NSInteger i = [[NSUserDefaults standardUserDefaults]integerForKey:@"adverNum"];
    if (i<3) {
        return YES;
    }else{
        return NO;
    }
    
 }
- (void)setData:(NSArray *)data{
    _data = data;
    NSInteger code  =  [_data[0][@"code"] integerValue];
  
    [self.adImage loadImageWithPath: _data[0][@"src"] placeholderImage:nil complete:nil];
    
    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"adverNum"]) {
        
    }else{
         [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"adverNum"];
         [[NSUserDefaults standardUserDefaults] synchronize];
    }
   
   
    NSInteger i = [[NSUserDefaults standardUserDefaults]integerForKey:@"adverNum"];
    

    if (code == [[[NSUserDefaults standardUserDefaults] objectForKey:@"adverImageCode"] integerValue]) {
        i ++ ;
        [[NSUserDefaults standardUserDefaults] setInteger:i forKey:@"adverNum"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else{
       
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"adverNum"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_data[0][@"src"]  forKey:@"adverImageSrc"];
    [[NSUserDefaults standardUserDefaults] setInteger:[_data[0][@"code"]  integerValue] forKey:@"adverImageCode"];
    [[NSUserDefaults standardUserDefaults] setObject:_data[0][@"href"]  forKey:@"adverImageHref"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"adverImageHref"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"adverImageHref"] length] !=0 ) {
        if (self.completionBlock) {
            self.completionBlock(YES);
            [self.timer invalidate];
            self.timer = nil;
        }
    }
    
}

#pragma mark - 计时器事件
- (void)timerAction:(NSTimer *)timer{
    
    _count--;
    [self.btn setTitle:[NSString stringWithFormat:@"%lds跳过", _count] forState:UIControlStateNormal];
    if(_count == 0){
        
        //计时器失效, 页面退下
        if (self.completionBlock) {
            self.completionBlock(NO);
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}
- (UIImageView *)adImage{
    if (!_adImage) {
        _adImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height*5/6.0)];
//        _adImage.contentMode = UIViewContentModeScaleAspectFit;
     
        [self.view addSubview:_adImage];
        
    }
    return _adImage;
}
- (UIImageView *)comImage{
    if (!_comImage) {
        _comImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, (self.view.bounds.size.height*5/6.0), self.view.bounds.size.width, self.view.bounds.size.height/6.0)];
        _comImage.image = [UIImage imageNamed:@"tiaoguo"];
        [self.view addSubview:_comImage];
        
    }
    return _comImage;
}
- (UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 70, self.view.bounds.size.height*5/6.0- 40, 60, 30)];
        [_btn setBackgroundImage:[UIImage imageNamed:@"tiaoguo01-1"] forState:UIControlStateNormal];
        [_btn setTitle:@"3s跳过" forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_btn addTarget:self action:@selector(btnclicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_btn];
    }
    return _btn;
}
- (void)btnclicked{

    if (self.completionBlock) {
        self.completionBlock(NO);
        [self.timer invalidate];
        self.timer = nil;
    }
}



@end
