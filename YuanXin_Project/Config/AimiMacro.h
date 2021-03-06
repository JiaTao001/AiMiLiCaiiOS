//
//  AimiCommon.h
//  YuanXin_Project
//
//  Created by Sword on 15/9/14.
//  Copyright (c) 2015年 yuanxin. All rights reserved.
//

#ifndef YuanXin_Project_AimiCommon_h
#define YuanXin_Project_AimiCommon_h

#import <UIKit/UIKit.h>


#pragma mark - 忽略警告，日志输出
//////忽略警告---弱引用执行方法
#define SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(code)                    \
_Pragma("clang diagnostic push")                                        \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")     \
code;                                                                   \
_Pragma("clang diagnostic pop")


#define SUPPRESS_PERFORM_SELECTOR_UNUSED_WARNING(code)                  \
_Pragma("clang diagnostic push")                                        \
_Pragma("clang diagnostic ignored \"-Wunused-value\"")                  \
code;                                                                   \
_Pragma("clang diagnostic pop")

#define PerformEmptyParameterBlock(_blockName) \
!_blockName ? : _blockName()

#define USERDEFAULTS [NSUserDefaults standardUserDefaults]

#ifdef DEBUG
    #define NSLog(...) NSLog(__VA_ARGS__)
    #define debugMethod() NSLog(@"class--%@ %s", NSStringFromClass([self class]), __func__)
#else
    #define NSLog(...)
    #define debugMethod()
#endif

#pragma mark - 系统版本判断
// iOS系统版本
#define SYSTEM_VERSION                  [[[UIDevice currentDevice] systemVersion] doubleValue]
#define SYSTEM_VERSION_GREATER_THAN_10  SYSTEM_VERSION >= 10.0
#define SYSTEM_VERSION_GREATER_THAN_9   SYSTEM_VERSION >= 9.0
#define SYSTEM_VERSION_GREATER_THAN_8   SYSTEM_VERSION >= 8.0
#define SYSTEM_VERSION_GREATER_THAN_7   SYSTEM_VERSION >= 7.0
// 标准系统状态栏高度
#define SYS_STATUSBAR_HEIGHT 20
// 热点栏高度
#define HOTSPOT_STATUSBAR_HEIGHT 20
// 导航栏（UINavigationController.UINavigationBar）高度
#define NAVIGATIONBAR_HEIGHT 44
// 工具栏（UINavigationController.UIToolbar）高度
#define TOOLBAR_HEIGHT 44
// 标签栏（UITabBarController.UITabBar）高度
#define TABBAR_HEIGHT 49
// APP_STATUSBAR_HEIGHT=SYS_STATUSBAR_HEIGHT+[HOTSPOT_STATUSBAR_HEIGHT]
#define APP_STATUSBAR_HEIGHT (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
// 根据APP_STATUSBAR_HEIGHT判断是否存在热点栏
#define IS_HOTSPOT_CONNECTED (APP_STATUSBAR_HEIGHT==(SYS_STATUSBAR_HEIGHT+HOTSPOT_STATUSBAR_HEIGHT)?YES:NO)
// 无热点栏时，标准系统状态栏高度+导航栏高度
#define NORMAL_STATUS_AND_NAV_BAR_HEIGHT (SYS_STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT)
// 实时系统状态栏高度+导航栏高度，如有热点栏，其高度包含在APP_STATUSBAR_HEIGHT中。
#define STATUS_AND_NAV_BAR_HEIGHT (APP_STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT)

#pragma mark - 屏幕尺寸

#define UISCREEN_SCALE  (1.0f/[UIScreen mainScreen].scale)
#define UISCREEN_SIZE   [UIScreen mainScreen].bounds.size
#define UISCREEN_WIDTH  UISCREEN_SIZE.width
#define UISCREEN_HEIGHT UISCREEN_SIZE.height

#pragma mark - 常量

#define Each_Page_Num             20
#define MARGIN_DISTANCE           5
#define BIG_MARGIN_DISTANCE       20
#define ROW_HEIGHT                44
#define NORMAL_ANIMATION_DURATION 0.25f
#define CUSTOM_LINE_MRGIN         54
#define SUP_BIG_FONT_SIZER        20
#define Button_Font_Size          15
#define NORMAL_FONT_SIZE          14
#define MIN_FONT_SIZE             13
#define DEFAULT_ALPHA             0.5f

#pragma mark - 预设宏

#define SERVICE_PHONE      @"400-666-2082"

#define PreDefM_QQAPPID    @"1104941414"
#define PreDefM_WXAPPID    @"wxcded2f2491b60186"
#define PreDefM_UM         @"5609fa5767e58e140e0012a4"
#define UM_Alias_Type      @"AiMiLiCai"


#define Dislodge_Nil_String(object) (object) ? : @""


#pragma mark - color

#define RGBALL(r,g,b,a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define RGBA(color, a)    RGBALL( ((color)>>16) & 0xFF, ((color)>>8) & 0xFF, (color) & 0xFF, a )
#define RGB(color)        RGBA( color, 1.0f)
#define Theme_Color       RGB(0xFF4C4E)
#define Normal_Green      RGB(0x34C894)
#define Background_Color  RGB(0xF5F5F9)
#define cycle_Color  RGB(0xE2E2E2)
#define Font_Normal_Gray  RGB(0x333333)
#define Font_Shallow_Gray RGB(0x999999)
#define Font_Orange_Gray RGB(0xFF8903)
#define Single_Line_Gray  RGB(0xDDDDDD)
#define Cell_Highlight    RGB(0xEEEEEE)


#pragma mark - 系统版本号和NSUserDefault

#define APP_VERSION_KEY    @"CFBundleShortVersionString"
#define APP_NAME_KEY       @"CFBundleDisplayName"

#define APP_GUIDE_PAGE_KEY @"UpdateNeedShowGuidePage"
#define DID_OPEN_GESTURE   @"open_gesture"
#define DID_OPEN_TOUCHID   @"open_touch_id"
#define Need_Guide_Page    @"need_open_page"
#define FIRST_ENTER        @"fist_enter"
#define VERSION_KEY        @"app_version"
#define Smallest_Amount_Of_Topup @"2"

#define IS_LOG @"IsLog"
#pragma mark - 通知
//***********************notification
static NSString *kRecommendShouldChangeNotification = @"kRecommendShouldChangeNotification";

#define BUY_PRODUCTID_KEY @"productID"
#define BUY_MONEY_KEY     @"money"
static NSString *kProductDidBuyNotification = @"kProductDidBuyNotification"; //有productID money 参数

#endif

