//
//  NSString+AttributeStringFormat.h
//  Client
//
//  Created by apple on 2020/6/1.
//  Copyright © 2020 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (AttributeStringFormat)


/// 设置首行缩进多长
/// @param text 首行缩进字符串
/// @param headIndent 首行缩进长度
+(NSMutableAttributedString *)zq_setFirstLineHeadIndent:(NSString *)text WithFirstLineHeadIndent:(NSInteger)headIndent;

/// 给字符串中的其中一段改变颜色和字体
/// @param str 原字符串
/// @param range 改变范围
/// @param color 颜色
/// @param font 字体
+ (NSMutableAttributedString *)setMutableFontWithString:(NSString *)str paragraArray:(NSRange )range color:(UIColor *)color font:(UIFont *)font;


/// 给字符串中的其中2段改变颜色和字体
/// @param str 原字符串
/// @param range1 改变范围
/// @param range2 改变范围
/// @param color 颜色
/// @param font 字体
+ (NSMutableAttributedString *)setMutableAttributedStringWithString:(NSString *)str WithRange1:(NSRange)range1 WithRange2:(NSRange )range2 withRangeColor:(UIColor *)color font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
