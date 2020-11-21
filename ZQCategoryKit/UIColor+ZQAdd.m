//
//  UIColor+ZQAdd.m
//  Client
//
//  Created by apple on 2020/7/2.
//  Copyright © 2020 apple. All rights reserved.
//

#import "UIColor+ZQAdd.h"

@implementation UIColor (ZQAdd)

- (BOOL)isEqualToColor:(UIColor*)otherColor {
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
    UIColor*(^convertColorToRGBSpace)(UIColor*) = ^(UIColor*color) {
        if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
            const CGFloat* oldComponents =CGColorGetComponents(color.CGColor);
            CGFloat components[4] = { oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1] };
            
            CGColorRef colorRef = CGColorCreate( colorSpaceRGB, components );
            
            UIColor *color = [UIColor colorWithCGColor:colorRef];
            CGColorRelease(colorRef);
            return color;
        }else
            return color;
    };
    UIColor*selfColor = convertColorToRGBSpace(self);
    otherColor = convertColorToRGBSpace(otherColor);
    
    CGColorSpaceRelease(colorSpaceRGB);
    return [selfColor isEqual:otherColor];
}

@end
