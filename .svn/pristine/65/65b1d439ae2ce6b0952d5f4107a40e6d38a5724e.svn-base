//
//  YuanXin_ProjectUITests.m
//  YuanXin_ProjectUITests
//
//  Created by Yuanin on 16/3/31.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface YuanXin_ProjectUITests : XCTestCase

@end

@implementation YuanXin_ProjectUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self customAction];
}

- (void)customAction {
    
    [[[XCUIApplication alloc] init] launch];
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.tabBars.buttons[@"\u7406\u8d22"] tap];
    [app.buttons[@"\u7231\u7c73\u4f18\u9009"] tap];
}

@end
