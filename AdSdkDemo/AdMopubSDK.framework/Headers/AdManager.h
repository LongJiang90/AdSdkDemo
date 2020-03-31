//
//  AdManager.h
//  AdMopubSDK
//
//  Created by 蒋龙 on 2019/7/16.
//  Copyright © 2019 com.YouLoft.CQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define JLWeakSelf __weak typeof(self) weakSelf = self;
#define JLStrongSelf __strong typeof(self) strongSelf = weakSelf;

typedef NS_ENUM(NSInteger, BannerPosition) {
    BannerPosition_TopLeft = 0,
    BannerPosition_TopCenter = 1,
    BannerPosition_TopRight,
    BannerPosition_Centered,
    BannerPosition_BottomLeft,
    BannerPosition_BottomCenter,
    BannerPosition_BottomRight
};

NS_ASSUME_NONNULL_BEGIN

@protocol AdManagerDelegate <NSObject>

@optional
/**
 banner加载成功
 */
-(void)bannerDidLoadAd;
/**
 banner加载失败

 @param errMsg 错误msg
 */
-(void)bannerDidFailToLoadWithMsg:(NSString *)errMsg;
/**
 banner接收到点击事件
 */
-(void)bannerDidReceiveTapEvent;


/**
 interstitial加载成功
 */
-(void)interstitialDidLoadAd;
/**
 interstitial加载失败， 仅在手动加载单条广告且加载失败时才会调用
 
 @param errMsg 错误msg
 */
-(void)interstitialDidFailToLoadWithMsg:(NSString *)errMsg;
/**
 interstitial接收到点击事件
 */
-(void)interstitialDidReceiveTapEvent;
/**
 interstitial已经显示
 */
-(void)interstitialDidAppear;
/**
 interstitial已经关闭
 */
-(void)interstitialDidDisappear;



/**
 rewardedVideo加载成功
 */
-(void)rewardedVideoDidLoadAd;
/**
 rewardedVideo加载失败， 仅在手动加载单条广告且加载失败时才会调用
 
 @param errMsg 错误msg
 */
-(void)rewardedVideoDidFailToLoadWithMsg:(NSString *)errMsg;
/**
 rewardedVideo接收到点击事件
 */
-(void)rewardedVideoDidReceiveTapEvent;
/**
 rewardedVideo已经显示
 */
-(void)rewardedVideoDidAppear;
/**
 rewardedVideo已经关闭
 */
-(void)rewardedVideoDidDisappear;
/**
 rewardedVideo播放完成，应该给予奖励
 */
-(void)rewardedVideoAdShouldReward;


/// 所有视频的状态json字符串，调用hasRewardedVideo方法后实时回调
/// @param jsonStr 视频是否加载成功的状态json字符串
-(void)rewardedVideoStatesWithJsonStr:(NSString *)jsonStr;


@end


@interface AdManager : UIViewController

/// 请求超时时间  默认30s
@property (nonatomic, assign) NSInteger timeOut;
/// 重复请求时间间隔 默认120s
@property (nonatomic, assign) NSInteger repeatTime;
/// 是否自动加载广告
@property (nonatomic, assign) BOOL offAutoRequest;
/// banner广告IDs
@property (nonatomic, strong) NSArray *bannerUnitIdsArr;
/// interstitial广告IDs
@property (nonatomic, strong) NSArray *interstitialUnitIdsArr;
/// rewardedVideo广告IDs
@property (nonatomic, strong) NSArray *rewardedVideoUnitIdsArr;

/// 回调协议
@property (nonatomic, weak) id<AdManagerDelegate> delegate;


/**
 单例

 @return 返回当前单例对象
 */
+ (instancetype)sharedManager;


/**
 初始化Manager

 @param adUnitsJson json格式的所有ID
 @param appAppleId 苹果应用ID
 @param umengId 友盟统计应用ID
 */
-(void)initAdWithAdUnitsJson:(NSString *)adUnitsJson appAppleId:(NSString *)appAppleId umengId:(NSString *)umengId;

//TODO:Banner相关函数
/**
 加载一个Banner类型的广告

 @param frame 广告位置、大小
 @param bannerSuperView 需要加载到那个视图上
 */
-(void)loadAndShowBannerAdWithFrame:(CGRect)frame InView:(UIView *)bannerSuperView;

/**
 隐藏当前显示的Banner
 */
-(void)hiddenBannerAd;


//TODO:interstitial相关函数
/**
 加载插屏广告
 */
-(void)loadInterstitialAd;

/**
 显示插屏广告到传入的VC上

 @param aVC 需要展示的VC
 */
-(void)showInterstitialAdWithViewController:(UIViewController *)aVC;

//TODO:rewardedVideo相关函数
/**
 加载奖励视频
 */
-(void)loadRewardedVideoAd;

/**
 判断是否有缓存就绪的广告
 
 @return 是否有就绪广告
 */
-(BOOL)hasRewardedVideo;

//判断传入的ID是否有缓存就绪的广告
-(BOOL)hasRewardedVideoWithAdID:(NSString *)adID;

//获取当前所有ID缓存状态
-(NSString *)mopub_idsStatesArr;

/**
 显示奖励视频到传入的VC上

 @param aVC 需要展示的VC
 */
-(void)showRewardedVideoAdWithViewController:(UIViewController *)aVC;

/// 显示指定奖励视频到传入的VC上
/// @param aVC 显示的VC
/// @param videoID 视频ID
-(void)showRewardedVideoAdWithViewController:(UIViewController *)aVC videoID:(NSString *)videoID;


- (void) jlApplication:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler;
// Reports app open from deep link from apps which do not support Universal Links (Twitter) and for iOS8 and below
- (void)jlApplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation;
// Reports app open from deep link for iOS 10
- (void)jlApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *) options;

#pragma mark - Unavailable Initializers
/// 设置单例调用这些方法无效
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
