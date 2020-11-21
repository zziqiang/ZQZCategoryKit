//
//  UIView+ZQAdd.h
//  Client
//
//  Created by apple on 2020/5/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ZQDirectionHorizontal = 1,//横向
    ZQDirectionVertical,  //纵向
} ZQDirection;

typedef struct {
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
} ZQCornerRadii;



@interface UIView (ZQAdd)

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGPoint origin;

+ (instancetype)zq_viewFromXib;

/**
* 给一个视图任意角的任意corner
*/
-(void)bezierPathByRoundingCornerRadii:(ZQCornerRadii)cornerRadii;

/**
 生成一个任意切角的结构体
 */
+(ZQCornerRadii) ZQCornerRadiiMakeWithTopLeft:(CGFloat)topLeft withTopRight:(CGFloat)topRight withBottomLeft:(CGFloat)bottomLeft withBottomRight:(CGFloat)bottomRight;

- (void)setRadius:(CGFloat)radius;

- (void)setBorderColor:(UIColor *)color borderWidth:(CGFloat)width radius:(CGFloat)radius;

- (void)setShadowColor:(UIColor *)shadowColor  radius:(CGFloat)radius shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity;

- (void)setSomeRadius:(CGFloat)radius isBottomLeft:(BOOL)isBottomLeft isBottomRight:(BOOL)isBottomRight isTopLeft:(BOOL)isTopLeft  isTopRight:(BOOL)isTopRight;

/**
 * 给一个视图切指定的角
 */
-(void)bezierPathByRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

///设置颜色渐变背景色
/// @param colors 颜色渐变数组
/// @param direction 方向
-(void)zq_addGradientLayerWithColor:(NSArray <UIColor *>*)colors withDirection:(ZQDirection)direction;

/// 设置局部透明
/// @param rect 局部透明区域
-(void)setAlphaComponent:(CGRect)rect;

/// 设置渐变透明
- (void)setGradientView;
/// 设置渐变透明
- (void)setHorizontalGradientView;

/// 获取自己所在的controller
- (UIViewController *)self_viewController;

@end

NS_ASSUME_NONNULL_END
