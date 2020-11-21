//
//  NSString+AttributeStringFormat.m
//  Client
//
//  Created by apple on 2020/6/1.
//  Copyright © 2020 apple. All rights reserved.
//

#import "NSString+AttributeStringFormat.h"


@implementation NSString (AttributeStringFormat)

+(NSMutableAttributedString *)zq_setFirstLineHeadIndent:(NSString *)text WithFirstLineHeadIndent:(NSInteger)headIndent{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    //设置首行缩进
    NSMutableParagraphStyle *paragraphStyle = [[ NSMutableParagraphStyle alloc ] init ];
    paragraphStyle. alignment = NSTextAlignmentLeft ;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.lineSpacing = 2;
    [paragraphStyle setFirstLineHeadIndent : headIndent];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0 ,text.length)];
    return attributedString;
}

//给字符串中的其中一段改变颜色和字体
+ (NSMutableAttributedString *)setMutableFontWithString:(NSString *)str paragraArray:(NSRange )range color:(UIColor *)color font:(UIFont *)font
{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:str];
    //获取要调整颜色的文字位置,调整颜色
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,color,NSForegroundColorAttributeName,nil];
    [hintString setAttributes:attributeDict range:range];
    return hintString;
}

/// 给字符串中的其中2段改变颜色和字体
+ (NSMutableAttributedString *)setMutableAttributedStringWithString:(NSString *)str WithRange1:(NSRange)range1 WithRange2:(NSRange )range2 withRangeColor:(UIColor *)color font:(UIFont *)font
{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:str];

    [hintString addAttribute:NSForegroundColorAttributeName value:color range:range1];
    [hintString addAttribute:NSForegroundColorAttributeName value:color range:range2];
    
    [hintString addAttribute:NSFontAttributeName value:font range:range1];
    [hintString addAttribute:NSFontAttributeName value:font range:range2];

    return hintString;
}

@end
