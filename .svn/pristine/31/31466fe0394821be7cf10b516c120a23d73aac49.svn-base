//
//  TestSingleProductInfo.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/3/31.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SingleProductInfo.h"

@interface TestSingleProductInfo : XCTestCase

@end

@implementation TestSingleProductInfo

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testProductInfo {
    
    NSString* productID = @"1";
    
    SingleProductInfo* info = [SingleProductInfo singleProductInfoWithProductID:productID productName:@"爱米定期"];
    
    XCTAssertEqual(productID, info.productID);
    XCTAssertEqualObjects(@"爱米定期", info.productTitle);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
