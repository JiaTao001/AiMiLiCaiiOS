//
//  RecommendProductCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/19.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "RecommendProductCell.h"


@implementation RecommendProductCell
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    self.contentView.backgroundColor = highlighted ? Cell_Highlight : [UIColor clearColor];
}

- (void)loadInterfactInfoWithProductInfo:(RecommendProductInfo *)aInfo {
    
//    self.replyMethodLB.text     = aInfo.replyMethod;
    self.productName.text     = aInfo.productName;


    self.MiBaoLB.layer.borderColor = [[UIColor redColor]CGColor];
    self.MiBaoLB.layer.borderWidth = 0.5f;
    self.MiBaoLB.layer.cornerRadius = 3;
    self.MiBaoLB.layer.masksToBounds = YES;
    self.rateLB.text  = [NSString stringWithFormat:@"%.1f",[aInfo.organnual floatValue]] ;
    
    //    self.MiBaoJiaXiLB.backgroundColor = [UIColor redColor];
    if ([aInfo.extannual floatValue] != 0.00f) {
        self.MiBaoLB.hidden = NO;
        self.AddRateLB.text = [NSString stringWithFormat:@"+%.1f%%",[aInfo.extannual floatValue]];
        self.AddRateLB.hidden = NO;
    }else{
        self.MiBaoLB.hidden = YES;
        self.AddRateLB.hidden = YES;
    }
    self.timeLB.text      = [aInfo theTermOfProduct];
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[aInfo theTermOfProduct]];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:aInfo.term].location, [[noteStr string] rangeOfString:aInfo.term].length);
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:redRange];
    
    self.purchase.enabled     = aInfo.canBuy;
    [self.purchase setTitle:aInfo.productState forState:UIControlStateNormal];

    if (aInfo.canBuy) {
        [self.purchase setBackgroundImage:[UIImage imageNamed:@"anniu_red"] forState:UIControlStateNormal];
    }else{
        [self.purchase setBackgroundImage:[UIImage imageNamed:@"anniu_hui"] forState:UIControlStateNormal];
    }
    [self.timeLB setAttributedText:noteStr];
    [self.timeLB sizeToFit];
    self.restOfShareLB.text     = [aInfo theRestOfShare];
}

- (IBAction)btnClicked:(UIButton *)sender {
    if (self.purchaseProduct) {
        self.purchaseProduct();
    }
    
}

@end
