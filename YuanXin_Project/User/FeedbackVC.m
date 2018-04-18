//
//  FeedbackVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/1/5.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "FeedbackVC.h"
#import "UIPlaceHolderTextView.h"

@interface FeedbackVC () <UITextViewDelegate>

@property (strong, nonatomic) NSURLSessionTask *task;

@property (assign, nonatomic) NSInteger restOfWord;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *feedback;
@property (weak, nonatomic) IBOutlet UILabel *restOfTheWord;
@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutNavigationLeftButtonWithImage:[UIImage imageNamed:Nav_Back_Image] block:^(__kindof UIViewController *viewController) {
        [viewController.navigationController popViewControllerAnimated:YES];
    }];
    self.restOfWord = 200;//限制200字符
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.task cancel];
}


#pragma mark - textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([@"\n" isEqualToString:text]) {
        
        [textView endEditing:YES];
        return NO;
    } else {
        
        return YES;
    }
}

- (IBAction)confirm:(UIButton *)sender {
    
    if ( 0 == self.feedback.text.length) {
        [SpringAlertView showMessage:@"请输入您的意见"];
        return;
    }
    [self.view endEditing:YES];
    
    [BaseIndicatorView showInView:self.view];
    @weakify(self)
    self.task = [NetworkContectManager sessionPOSTWithMothed:@"feedback" params:[[UserinfoManager sharedUserinfo] increaseUserParams:@{@"message":self.feedback.text}] success:^(NSURLSessionTask *task, id result) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showInWindow:self.view.window message:result[RESULT_REMARK]];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionTask *task, id result, NSString *errorDescription) {
        @strongify(self)
        
        [BaseIndicatorView hideWithAnimation:self.didShow];
        [SpringAlertView showInWindow:self.view.window message:errorDescription];
    }];
}




#pragma mark - notification
- (void)textDidChange {
    
    if (self.feedback.text.length > self.restOfWord) {//大于限制长度长度, 暂时没有限制表情，汉字高亮
        self.feedback.text = [self.feedback.text substringToIndex:self.restOfWord];
    }
    
    self.restOfTheWord.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.restOfWord - self.feedback.text.length];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

@end
