//
//  LoginManager.h
//  AdMopubSDK
//
//  Created by 蒋龙 on 2020/4/10.
//  Copyright © 2020 com.YouLoft.CQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 状态Code，200-成功，其他失败
static NSString *Des_Code_Key = @"Code";
/// 成功或失败消息
static NSString *Des_Msg_Key = @"Msg";
/// 用户ID
static NSString *Des_UserID_Key = @"UserID";
/// 用户名称
static NSString *Des_UserName_Key = @"UserName";
/// 用户密码-存放于apple的keychain中的密码
static NSString *Des_UserPassword_Key = @"UserPassword";
/// 刷新Token
static NSString *Des_UserRefreshToken_Key = @"UserRefreshToken";
/// 访问Token
static NSString *Des_UserAccessToken_Key = @"UserAccessToken";
/// 用户Email
static NSString *Des_UserEmail_Key = @"UserEmail";
/// 用户状态 0-不支持，1、2-支持登录
static NSString *Des_RealUserStatus_Key = @"RealUserStatus";
///// 数据来源  iCloud Keychain-存放在keychain中的， Authorization Apple ID-苹果返回的
static NSString *Des_AuthFrom_Key = @"AuthFrom";

@protocol LoginManagerDelegate <NSObject>

@optional

/// 登录回调，code参数来判定状态，为200表示登录成功，非200 登录失败
/// @param msgDic 回调字典
-(void)loginDidCompleteWithDic:(NSDictionary *)msgDic;

@end

@interface LoginManager : NSObject

/// 回调协议
@property (nonatomic, weak) id<LoginManagerDelegate> delegate;

+ (instancetype)shareM;

/// 使用苹果登陆  仅支持iOS13及以上系统版本
-(void)loginUseAppleSign API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
