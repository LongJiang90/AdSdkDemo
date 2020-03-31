//
//  PushManager.h
//  AdMopubSDK
//
//  Created by 蒋龙 on 2019/11/15.
//  Copyright © 2019 com.YouLoft.CQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PushManager : NSObject

+ (instancetype)shareManager;


#pragma mark - 本地推送方法

/// 添加一个延时的通知
/// @param identifier 通知ID
/// @param titleStr 通知标题
/// @param bodyStr 通知详情
/// @param seconds 多少秒后通知
- (void)setLocalNotificationWithID:(NSString *)identifier titleStr:(NSString *)titleStr bodyStr:(NSString *)bodyStr delayInSeconds:(NSNumber *)seconds;

/// 移除某一个指定的通知
/// @param noticeId 通知ID
- (void)cancleLocalNotificationWithID:(NSString *)noticeId;

/// 移除所有本地通知
- (void)cancleAllLocalNotification;


#pragma mark - 远端推送方法
/* ---------------------------------------------------注意：需要使用远端推送时，以下2个方法需要同时启用-------------------------------------- */

/// 程序完成启动
/// @param application 应用上下文
/// @param launchOptions 加载项字典
- (void)ylApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/// 程序接收到推送 - iOS10以下需要实现此方法，10以上不需要调用
/// @param application 应用上下文1
/// @param userInfo 推送传输信息字典
- (void)ylApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;




@end

NS_ASSUME_NONNULL_END
