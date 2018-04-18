//
//  CustomNavigationController.m
//  wujin-seller
//
//  Created by wujin  on 15/3/11.
//  Copyright (c) 2015年 wujin. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UINavigationBar+BackgroundColor.h"
#import "NavigationBarAnimation.h"

@interface BaseNavigationController ()

@property (strong, nonatomic) NavigationBarAnimation *navigationBarAnimation;
@end

@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationBar configureNavigationBar];
    [self.navigationBar setCustomBackgroundColor:Theme_Color];
    [self.navigationBar setCustomShadowColor:[UIColor clearColor]];
    
    self.delegate = self.navigationBarAnimation;
}


- (NavigationBarAnimation *)navigationBarAnimation
{
    if (!_navigationBarAnimation) {
        _navigationBarAnimation = [[NavigationBarAnimation alloc] init];
    }
    return _navigationBarAnimation;
}
@end


