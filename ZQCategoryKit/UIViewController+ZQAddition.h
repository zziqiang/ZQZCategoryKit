//
//  UIViewController+ZQAddition.h
//  Client
//
//  Created by apple on 2020/5/26.
//  Copyright © 2020 apple. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BtnActionBlock)(id objc);

typedef NS_ENUM(NSInteger, NavigateItemPosition) {
    NavigateItemPositionLeft = 1,
    NavigateItemPositionRight,
};

typedef NS_ENUM(NSInteger, NavigateItemType) {
    NavigateItemTypeImage = 1,
    NavigateItemTypeTitle,
};


@interface UIViewController (ZQAddition)

/// VC通用NSInteger属性
@property (nonatomic, assign) NSInteger ktype;
/// VC通用字符串属性
@property (nonatomic, strong) NSString *kname;

+ (UIViewController *)zq_getCurrentViewController;

/// nav导航 pop返回到某一个控制器
-(void)zq_backToController:(NSString *)controllerName animated:(BOOL)animaed;
/// 移除某个控制器
-(void)zq_removeController:(NSString *)controllerName;
/// 移除多个控制器
-(void)zq_removeControllers:(NSMutableArray <NSString *>*)controllers;

/// 左侧添加导航栏按钮 - 图片
/// @param imageName 图片名
/// @param targetViewController 控制器
/// @param btnActionBlock 按钮响应事件
-(UIButton *)addLeftNavigateItemWithImage:(NSString *)imageName target:(UIViewController *)targetViewController btnHandler:(BtnActionBlock)btnActionBlock;

/// 右侧添加导航栏按钮 - 图片
/// @param imageName 图片名
/// @param targetViewController 控制器
/// @param btnActionBlock 按钮响应事件
-(UIButton *)addRightNavigateItemWithImage:(NSString *)imageName target:(UIViewController *)targetViewController btnHandler:(BtnActionBlock)btnActionBlock;

/// @param imageName 文字名
/// @param targetViewController 控制器
/// @param btnActionBlock 按钮响应事件

/// 左侧添加导航栏按钮 - 文字
/// @param itemName 文字名
/// @param targetViewController 控制器
/// @param itemColor 文字颜色
/// @param btnActionBlock 按钮响应事件
-(UIButton *)addLeftNavigateItemWithTitle:(NSString *)itemName target:(UIViewController *)targetViewController itemColor:(UIColor *)itemColor btnHandler:(BtnActionBlock)btnActionBlock;

/// 右侧添加导航栏按钮 - 文字
/// @param itemName 文字名
/// @param targetViewController 控制器
/// @param itemColor 文字颜色
/// @param btnActionBlock 按钮响应事件
-(UIButton *)addRightNavigateItemWithTitle:(NSString *)itemName target:(UIViewController *)targetViewController itemColor:(UIColor *)itemColor btnHandler:(BtnActionBlock)btnActionBlock;

    
@end

NS_ASSUME_NONNULL_END
