//
//  ProductShowVC.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/3/28.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "SingleProductInfo.h"

@implementation SingleProductInfo {
    
    NSString *_productID;
}
@synthesize  productID = _productID;


- (instancetype)initWithProductID:(NSString* )productID productName:(NSString *)productName {
    
    self = [super init];
    if (self) {
        _productID = productID;
        _productName = productName;
    }
    return self;
}
+ (instancetype)singleProductInfoWithProductID:(NSString* )productID productName:(NSString *)productName {
    
    return [[[self class] alloc] initWithProductID:productID productName:productName];
}

- (BOOL)isRegular {
    
    return [self.productName hasPrefix:Regular_Title];
}
- (NSString *)productTitle {
    
    if (self.productName.length >= 4) {
        
        return [self.productName substringToIndex:4];
    } else {
        
        return self.productName;
    }
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.productID forKey:@"productId"];
    [aCoder encodeObject:self.productName forKey:@"productName"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        _productName = [aDecoder decodeObjectForKey:@"productName"];
        _productID = [aDecoder decodeObjectForKey:@"productId"];
    }
    return self;
}
@end
