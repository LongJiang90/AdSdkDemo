//
//  ViewController.m
//  AdSdkDemo
//
//  Created by 蒋龙 on 2020/3/31.
//  Copyright © 2020 com.youloft.cq. All rights reserved.
//

#import "ViewController.h"
#import <AdMopubSDK/iOSAdMoPubSDK.h>

#define BundleId [NSBundle mainBundle].bundleIdentifier
#define kTabBarHeight   50
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height

#define isIOS7    ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define isPad (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 是iPhone X 以上的机型
#define IS_IPHONE_X_UP ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? YES : NO)

#define jl_weakify(var)   __weak typeof(var) weakSelf = var
#define jl_strongify(var) __strong typeof(var) strongSelf = var

//iPhoneX系列
#define Height_StatusBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 44.0 : 20.0)
#define Height_NavBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 88.0 : 64.0)
#define Height_TabBar ((IS_IPHONE_X==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES) ? 83.0 : 49.0)

@interface ViewController ()<AdManagerDelegate, ApplePayDelegate, LoginManagerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //如没有对应的id或不需要相应类型的广告，请在对应的类型下传入@[]
    NSDictionary *dic = @{@"bannerIds":@[@"0ac59b0996d947309c33f59d6676399f"], @"interstIds":@[@"4f117153f5c24fa6a3a92b818a5eb630", @"b23d7be60ff047dab5f5d1d03245029f"], @"videoIds":@[@"181e76997891466ea8bdc164946237d1",@"9c00ae9d2a704fcab4454864a0c926eb"]};
    //convertNSDictionaryToJsonString 字典转为字符串方法，网上搜索下就有
    NSString *dicStr = [NSDictionary convertNSDictionaryToJsonString:dic];
    [[AdManager sharedManager] initAdWithAdUnitsJson:dicStr appAppleId:@"1450705290" umengId:@""];
    [[AdManager sharedManager] setDelegate:self];
    
    
    [[ApplePayAgent shareManager] setDelegate:self];
    
    [self addBtnsByArr:@[@"添加Banner广告", @"隐藏Banner广告", @"插屏广告", @"加载缓存视频", @"显示缓存视频", @"测试统计", @"发送本地消息1", @"发送本地消息（10s后出现）", @"取消本地消息", @"苹果登录"]];//, @"调起内购"
    
}

-(void)addBtnsByArr:(NSArray *)titleArr {
    float viewW = CGRectGetWidth(self.view.frame);
    float btnX = viewW/2-100;
    
    for (int i=0; i<titleArr.count; i++) {
        NSString *title = titleArr[i];
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        btn.frame = CGRectMake(btnX, 50 * (i+1), 200, 50);
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnAcWithSender:) forControlEvents:(UIControlEventTouchUpInside)];
        [btn setTitle:title forState:(UIControlStateNormal)];
//        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [self.view addSubview:btn];
    }
}

-(void)btnAcWithSender:(UIButton *)sender {
    switch (sender.tag-100) {
        case 0:
            [self loadAndShowBannerAdWithAdPostion:@"TopCenter"];//添加Banner广告
            break;
        case 1:
            [self hideBannerAd];//隐藏Banner广告
            break;
        case 2:
            [self showInterstitialAd];//插屏广告
            break;
        case 3:
            [self loadRewardedVideoAd];//加载缓存视频
            break;
        case 4:
            // 显示缓存视频
            if ([self hasRewardedVideo]) {
                [self showRewardedVideoAd];
            }
            //查询某个指定广告ID的状态，播放指定广告
//            if ([self hasRewardedVideoWithID:@"181e76997891466ea8bdc164946237d1"]) {
//                [self showRewardedVideoAdWithID:@"181e76997891466ea8bdc164946237d1"];
//            }
            break;
        case 5:
            [self customEventWithKey:@"AdLoadSucess" dicJsonStr:[NSDictionary convertNSDictionaryToJsonString:@{@"adID":@"1232141242131", @"adStates":@"0"}]];//测试统计
            break;
        case 6:
            [self setLocalNoticeWithID:1001 titleStr:@"测试推送标题" bodyStr:@"宝箱已经可以开启了，快来开启吧！" delayInSeconds:1];//发送本地消息1
            break;
        case 7:
            [self setLocalNoticeWithID:1002 titleStr:@"10s后触发的推送" bodyStr:@"10 9 8 7 6 5 4 3 2 1 僵尸来了！" delayInSeconds:10];//发送本地消息（10s后出现）
            break;
        case 8:
            [self cancleLocalNotificationWithID:1002];//取消本地消
            break;
        case 9:
            [LoginManager shareM].delegate = self;
            [[LoginManager shareM] loginUseAppleSign];
            break;
            
        default:
            break;
    }
}

#pragma mark - 广告相关函数
- (UIViewController *)getRootViewController{
    UIWindow* window = nil;
    if (@available(iOS 13.0, *))
    {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes)
        {
            if (windowScene.activationState == UISceneActivationStateForegroundActive)
            {
                window = windowScene.windows.firstObject;

                break;
            }
        }
    }else{
        window = [UIApplication sharedApplication].keyWindow;
    }
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

-(void)loadAndShowBannerAdWithAdPostion:(NSString *)adPostion {
//    TopLeft,TopCenter,TopRight,Centered,BottomLeft,BottomCenter,BottomRight
    if (adPostion != nil) {
        float adW = 320;
        float adH = 50;
        NSString *adPostionStr = adPostion.copy;
        CGRect frame = CGRectZero;
        if ([adPostionStr isEqualToString:@"TopLeft"]) {
            frame = CGRectMake(0, Height_StatusBar, adW, adH);
        }
        if ([adPostionStr isEqualToString:@"TopCenter"]) {
            frame = CGRectMake((kDeviceWidth-adW) / 2.0, Height_StatusBar, adW, adH);
        }
        if ([adPostionStr isEqualToString:@"TopRight"]) {
            frame = CGRectMake(kDeviceWidth-adW, Height_StatusBar, adW, adH);
        }
        if ([adPostionStr isEqualToString:@"Centered"]) {
            frame = CGRectMake((kDeviceWidth-adW) / 2.0, (KDeviceHeight/2.0 - adH/2.0), adW, adH);
        }
        if ([adPostionStr isEqualToString:@"BottomLeft"]) {
            frame = CGRectMake(0, KDeviceHeight - adH, adW, adH);
        }
        if ([adPostionStr isEqualToString:@"BottomCenter"]) {
            frame = CGRectMake((kDeviceWidth-adW) / 2.0, KDeviceHeight - adH, adW, adH);
        }
        if ([adPostionStr isEqualToString:@"BottomRight"]) {
            frame = CGRectMake(kDeviceWidth-adW, KDeviceHeight - adH, adW, adH);
        }
        
        UIViewController *rootVC = [self getRootViewController];
        [[AdManager sharedManager] loadAndShowBannerAdWithFrame:frame InView:self.view];
    }
}

-(void)hideBannerAd {
    [[AdManager sharedManager] hiddenBannerAd];
}

-(void)loadInterstitialAd {
    [[AdManager sharedManager] loadInterstitialAd];
}

-(void)showInterstitialAd {
    UIViewController *rootVC = [self getRootViewController];
    [[AdManager sharedManager] showInterstitialAdWithViewController:rootVC];
}

-(void)loadRewardedVideoAd {
    [[AdManager sharedManager] loadRewardedVideoAd];
}

-(bool)hasRewardedVideo {
    return [[AdManager sharedManager] hasRewardedVideo];
}

-(bool)hasRewardedVideoWithID:(NSString*)idStr {
    return [[AdManager sharedManager] hasRewardedVideoWithAdID:idStr];
}

-(NSString*)getAllRewardedVideoIdsStates {
    return [[AdManager sharedManager] mopub_idsStatesArr];
}

-(void)showRewardedVideoAd {
    UIViewController *rootVC = [self getRootViewController];
    [[AdManager sharedManager] showRewardedVideoAdWithViewController:rootVC];
}

-(void)showRewardedVideoAdWithID:(NSString*)idStr {
    UIViewController *rootVC = [self getRootViewController];
    [[AdManager sharedManager] showRewardedVideoAdWithViewController:rootVC videoID:idStr];
}

#pragma mark - 统计相关函数
- (void)customEventWithKey:(NSString*)keyStr dicJsonStr:(NSString*)dicJsonStr {
    [AnalyticsManager customEventWithKey:keyStr dicJsonStr:dicJsonStr];
}

#pragma mark - 内购
- (void)applePayWithProductId:(const char* )productId {
    NSString *productIdStr = [NSString stringWithCString:productId encoding:NSUTF8StringEncoding];
    
    [ApplePayAgent shareManager].delegate = self;
    
    [[ApplePayAgent shareManager] payParams:productIdStr];
}

-(void)restore {
    [ApplePayAgent shareManager].delegate = self;
    
    [[ApplePayAgent shareManager] restore];
}

#pragma mark - 本地推送
- (void)setLocalNoticeWithID:(int)identifier titleStr:(NSString*)title bodyStr:(NSString*)body delayInSeconds:(int)seconds{
    NSString *identifierStr = @(identifier).stringValue;
    [[PushManager shareManager] setLocalNotificationWithID:identifierStr titleStr:title bodyStr:body delayInSeconds:@(seconds)];
}

// 移除某一个指定的通知
- (void)cancleLocalNotificationWithID:(int)identifier{
    NSString *identifierStr =@(identifier).stringValue;
    [[PushManager shareManager] cancleLocalNotificationWithID:identifierStr];
}

// 移除所有通知
- (void)cancleAllLocalNotification{
    [[PushManager shareManager] cancleAllLocalNotification];
}

#pragma mark - 分享
-(void)shareTextWithMsg:(NSString*)msg {
    NSString *titleStr = msg.copy;
    //分享的标题
    NSString *text =titleStr;

    //分享的图片
//  UIImage *image= [UIImage imageNamed:@"分享的图片.png"];
    //分享的url
//    NSURL*url = [NSURL URLWithString:@"分享的url"];

    //把分项的文字, 图片, 链接放入数组
    NSArray*activityItems = @[text];

    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
//    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    //弹出分享的页面
    [self presentViewController:activityVC animated:YES completion:nil];

    // 分享后回调
    activityVC.completionWithItemsHandler= ^(UIActivityType _Nullable activityType,BOOL completed,NSArray*_Nullable returnedItems,NSError*_Nullable activityError) {
        if(completed) {
            NSLog(@"completed");
        //分享成功
        }else{
            NSLog(@"cancled");
            //分享取消
        }
    };
}

#pragma mark - 协议函数
/**
 UnitySendMessage(<#const char *#>, <#const char *#>, <#const char *#>);
 *  第一个参数：是unity那边创建的场景对象名
 *  第二个参数：这个对象绑定的C#脚本中的方法
 *  第三个参数：是iOS这边要传给unity那边的参数
 */

//banner加载成功
-(void)bannerDidLoadAd {
    
}

//banner加载失败
-(void)bannerDidFailToLoadWithMsg:(NSString *)errMsg {
    
}

//banner接收到点击事件
-(void)bannerDidReceiveTapEvent {
    
}


/**
 interstitial加载成功
 */
-(void)interstitialDidLoadAd {
    
}
/**
 interstitial加载失败， 仅在手动加载单条广告且加载失败时才会调用
 
 @param errMsg 错误msg
 */
-(void)interstitialDidFailToLoadWithMsg:(NSString *)errMsg {
    
}
/**
 interstitial接收到点击事件
 */
-(void)interstitialDidReceiveTapEvent {
    
}
/**
 interstitial已经显示
 */
-(void)interstitialDidAppear {
    
}
/**
 interstitial已经关闭
 */
-(void)interstitialDidDisappear {
    
}



/**
 rewardedVideo加载成功
 */
-(void)rewardedVideoDidLoadAd {
    
}
/**
 rewardedVideo加载失败， 仅在手动加载单条广告且加载失败时才会调用
 
 @param errMsg 错误msg
 */
-(void)rewardedVideoDidFailToLoadWithMsg:(NSString *)errMsg {
    
}
/**
 rewardedVideo接收到点击事件
 */
-(void)rewardedVideoDidReceiveTapEvent {
    
}
/**
 rewardedVideo已经显示
 */
-(void)rewardedVideoDidAppear {
    
}
/**
 rewardedVideo已经关闭
 */
-(void)rewardedVideoDidDisappear {
    
}
/**
 rewardedVideo播放完成，应该给予奖励
 */
-(void)rewardedVideoAdShouldReward {
    
}

-(void)rewardedVideoStatesWithJsonStr:(NSString *)jsonStr {
    
}


-(void)applePayHaveResultWithMsg:(NSDictionary *)msgDic{
    NSString *resStr = msgDic[@"payResult"];
    NSString *msg = msgDic[@"payReason"];
    NSLog(@"%@", msg);
    
    if (resStr.intValue == 1) { //支付成功
        NSLog(@"支付成功");
    }else{ //支付失败
        NSLog(@"支付失败");
    }
}

-(void)reStoreHaveResultWithMsg:(NSDictionary *)msgDic{
    NSString *resStr = msgDic[@"payResult"];
    NSString *msg = msgDic[@"payReason"];
    NSString *msgStr = msgDic[@"payDescription"];
    if (resStr.intValue == 1) { //支付成功
        NSLog(@"恢复购买成功");
    }else{ //支付失败
        NSLog(@"恢复购买失败，失败原因：%@", msg);
    }
    
}

-(void)loginDidCompleteWithDic:(NSDictionary *)msgDic {
    NSLog(@"%@", msgDic);
}

-(void)showAlertWithTitle:(const char*)title {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithCString:title encoding:NSUTF8StringEncoding] preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:okAction];
    UIViewController *rootVC = [self getRootViewController];
    [rootVC presentViewController:alertVC animated:YES completion:nil];
}

@end
