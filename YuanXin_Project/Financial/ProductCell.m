//
//  ProductCell.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/4/20.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "ProductCell.h"

@implementation ProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.separatorInset = UIEdgeInsetsZero;
    if ([self respondsToSelector:@selector(layoutMargins)]) {
        self.layoutMargins = UIEdgeInsetsZero;
    }
}

//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    [super setHighlighted:highlighted animated:animated];
//    
////    for (UIView *view in self.contentView.subviews) {
////        view.backgroundColor = highlighted ? Cell_Highlight : [UIColor whiteColor];
////    }
//}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    self.contentView.backgroundColor = highlighted ? Cell_Highlight : [UIColor clearColor];
}

- (void)loadInterfactInfoWithProductInfo:(ProductInfo *)aInfo {
    
    self.productName.text     = aInfo.productName;
    self.MiBaoJiaXiLB.layer.borderColor = [[UIColor redColor]CGColor];
    self.MiBaoJiaXiLB.layer.borderWidth = 0.5f;
    self.MiBaoJiaXiLB.layer.cornerRadius = 3;
    self.MiBaoJiaXiLB.layer.masksToBounds = YES;
     self.annualInterestLB.text  = [NSString stringWithFormat:@"%.1f",[aInfo.organnual floatValue]] ;
    
//    self.MiBaoJiaXiLB.backgroundColor = [UIColor redColor];
    if ([aInfo.extannual floatValue] != 0.00f) {
        self.MiBaoJiaXiLB.hidden = NO;
        self.AddRateLB.text = [NSString stringWithFormat:@"+%.1f%%",[aInfo.extannual floatValue]];
        self.AddRateLB.hidden = NO;
    }else{
        self.MiBaoJiaXiLB.hidden = YES;
        self.AddRateLB.hidden = YES;
    }
    
//    self.replyMethod.text     = aInfo.replyMethod;
//    self.guaranteeMethod.text = aInfo.guaranteeMethod;
   
    self.timeLB.text      = [aInfo theTermOfProduct];
    
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[aInfo theTermOfProduct]];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:aInfo.term].location, [[noteStr string] rangeOfString:aInfo.term].length);
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:redRange];
    
    
    [self.timeLB setAttributedText:noteStr];
    [self.timeLB sizeToFit];
    
//    self.moneyLB.text     = [aInfo theRestOfShare];
    self.restOfShareLB.text = [aInfo theRestOfShare];
    self.purchase.enabled     = aInfo.canBuy;
    if (aInfo.canBuy) {
        [self.purchase setBackgroundImage:[UIImage imageNamed:@"anniu_red"] forState:UIControlStateNormal];
    }else{
          [self.purchase setBackgroundImage:[UIImage imageNamed:@"anniu_hui"] forState:UIControlStateNormal];
    }
    [self.purchase setTitle:aInfo.productState forState:UIControlStateNormal];
}

//- (IBAction)buyProduct {
//    
//    if (self.purchaseProduct) {
//        self.purchaseProduct();
//    }
//}
- (IBAction)btnClicked:(UIButton *)sender {
        if (self.purchaseProduct) {
            self.purchaseProduct();
        }
}

@end
