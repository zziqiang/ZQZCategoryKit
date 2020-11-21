//
//  UIImage+HXExtension.h
//  HX
//
//  Created by hxrc on 16/12/10.
//  Copyright © 2016年 xgt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到下
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};

@interface UIImage (HXExtension)

/**
 图片不渲染分类
 
 @param name 图片名称
 @return 没渲染的图片
*/
+(UIImage *)originalImageWithImageName:(NSString *)name;
/**
 *  生成一张高斯模糊的图片
 *
 *  @param image 原图
 *  @param blur  模糊程度 (0~1)
 *
 *  @return 高斯模糊图片
 */
+ (UIImage *)blurImage:(UIImage *)image blur:(CGFloat)blur;

/**
 *  根据颜色生成一张图片
 *
 *  @param color 颜色
 *  @param size  图片大小
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  生成圆角的图片
 *
 *  @param originImage 原始图片
 *  @param borderColor 边框原色
 *  @param borderWidth 边框宽度
 *
 *  @return 圆形图片
 */
+ (UIImage *)circleImage:(UIImage *)originImage borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**
 绘制带有圆弧的图片 四个角
 */
- (UIImage *)drawCircularIconWithSize:(CGSize )imgSize withRadius:(CGFloat)radius;


/// 绘制不同的地方切角的图片
/// @param imgSize 图片尺寸
/// @param corners 切角的位置 按位与
/// @param cornerRadii 切角角度
- (UIImage *)drawPointCircleWithSize:(CGSize )imgSize byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage ;


/// 生成渐变图片
/// @param colors 颜色数组
/// @param gradientType 渐变方向
/// @param imgSize 图片大小
+(UIImage *)gradientColorImageFromColors:(NSArray *)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;
/**
 解决旋转90度问题

 @param aImage 原始图片
 @return 修改后图片
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

@end
