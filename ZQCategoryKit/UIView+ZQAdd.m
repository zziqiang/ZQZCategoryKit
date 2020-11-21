//
//  UIView+ZQAdd.m
//  Client
//
//  Created by apple on 2020/5/28.
//  Copyright © 2020 apple. All rights reserved.
//

#import "UIView+ZQAdd.h"

@implementation UIView (ZQAdd)

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


-(ZQCornerRadii) CornerRadiiNull{
    return (ZQCornerRadii){-1, -1, -1, -1};
}

-(BOOL)CornerRadiiEqualTo:(ZQCornerRadii)lhs andRhs:(ZQCornerRadii)rhs {
    return lhs.topLeft == rhs.topRight
    && lhs.topRight == rhs.topRight
    && lhs.bottomLeft == rhs.bottomLeft
    && lhs.bottomRight == lhs.bottomRight;
}

+(ZQCornerRadii) ZQCornerRadiiMakeWithTopLeft:(CGFloat)topLeft withTopRight:(CGFloat)topRight withBottomLeft:(CGFloat)bottomLeft withBottomRight:(CGFloat)bottomRight{
    return (ZQCornerRadii){
        topLeft,
        topRight,
        bottomLeft,
        bottomRight,
    };
}

// 切圆角函数
-(CGPathRef _Nullable)LEECGPathCreateWithRoundedRect:(CGRect)bounds andCornerRadii:(ZQCornerRadii)cornerRadii{
    const CGFloat minX = CGRectGetMinX(bounds);
    const CGFloat minY = CGRectGetMinY(bounds);
    const CGFloat maxX = CGRectGetMaxX(bounds);
    const CGFloat maxY = CGRectGetMaxY(bounds);
    
    const CGFloat topLeftCenterX = minX + cornerRadii.topLeft;
    const CGFloat topLeftCenterY = minY + cornerRadii.topLeft;
    
    const CGFloat topRightCenterX = maxX - cornerRadii.topRight;
    const CGFloat topRightCenterY = minY + cornerRadii.topRight;
    
    const CGFloat bottomLeftCenterX = minX + cornerRadii.bottomLeft;
    const CGFloat bottomLeftCenterY = maxY - cornerRadii.bottomLeft;
    
    const CGFloat bottomRightCenterX = maxX - cornerRadii.bottomRight;
    const CGFloat bottomRightCenterY = maxY - cornerRadii.bottomRight;
    // 虽然顺时针参数是YES，在iOS中的UIView中，这里实际是逆时针
    
    CGMutablePathRef path = CGPathCreateMutable();
    // 顶 左
    CGPathAddArc(path, NULL, topLeftCenterX, topLeftCenterY, cornerRadii.topLeft, M_PI, 3 * M_PI_2, NO);
    // 顶 右
    CGPathAddArc(path, NULL, topRightCenterX , topRightCenterY, cornerRadii.topRight, 3 * M_PI_2, 0, NO);
    // 底 右
    CGPathAddArc(path, NULL, bottomRightCenterX, bottomRightCenterY, cornerRadii.bottomRight, 0, M_PI_2, NO);
    // 底 左
    CGPathAddArc(path, NULL, bottomLeftCenterX, bottomLeftCenterY, cornerRadii.bottomLeft, M_PI_2,M_PI, NO);
    CGPathCloseSubpath(path);
    return path;
}

-(void)bezierPathByRoundingCornerRadii:(ZQCornerRadii)cornerRadii{
    
    if (![self CornerRadiiEqualTo:cornerRadii andRhs:[self CornerRadiiNull]]) {

        CAShapeLayer *lastLayer = (CAShapeLayer *)self.layer.mask;        
        CGPathRef lastPath = CGPathCreateCopy(lastLayer.path);
        
        CGPathRef path = [self LEECGPathCreateWithRoundedRect:self.bounds andCornerRadii:cornerRadii];

        // 防止相同路径多次设置
        if (!CGPathEqualToPath(lastPath, path)) {
            // 移除原有路径动画
            [lastLayer removeAnimationForKey:@"path"];
            // 重置新路径mask
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.path = path;
            self.layer.mask = maskLayer;
            // 同步视图大小变更动画
            CAAnimation *temp = [self.layer animationForKey:@"bounds.size"];
            if (temp) {
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
                animation.duration = temp.duration;
                animation.fillMode = temp.fillMode;
                animation.timingFunction = temp.timingFunction;
                animation.fromValue = (__bridge id _Nullable)(lastPath);
                animation.toValue = (__bridge id _Nullable)(path);
                [maskLayer addAnimation:animation forKey:@"path"];
            }
        }
        
        CGPathRelease(lastPath);
        CGPathRelease(path);
    }
}

-(void)bezierPathByRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = self.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}

+ (instancetype)zq_viewFromXib
{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

-(void)zq_addGradientLayerWithColor:(NSArray <UIColor *>*)colors withDirection:(ZQDirection)direction
{
    CAGradientLayer*layer = [CAGradientLayer layer];
    
    NSMutableArray *colorArr = @[].mutableCopy;
    for (UIColor *color in colors) {
        [colorArr addObject:(__bridge id)color.CGColor];
    }
    layer.colors = colorArr;

    CGPoint inputPoint0;
    CGPoint inputPoint1;
    
    switch (direction) {
        case ZQDirectionHorizontal:
        {
            inputPoint0 = CGPointMake(0,0);
            inputPoint1 = CGPointMake(1.0,0);
        }
            break;
        case ZQDirectionVertical:
        {
            inputPoint0 = CGPointMake(0,0);
            inputPoint1 = CGPointMake(0,1.0);
        }
            break;
        default:
            break;
    }
    layer.startPoint= inputPoint0;
    layer.endPoint= inputPoint1;
    
    // 默认就是均匀分布
    //layer.locations = @[@0, @0.5, @1];
    
    layer.frame = self.bounds;
    [self.layer insertSublayer:layer atIndex:0];
}

-(void)setAlphaComponent:(CGRect)rect{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.frame];
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0] bezierPathByReversingPath]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [self.layer setMask:shapeLayer];
}

//创建渐变视图
- (void)setGradientView{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    //设置渐变颜色数组,可以加透明度的渐变
    gradientLayer.colors = @[(__bridge id)[[UIColor clearColor] colorWithAlphaComponent:0].CGColor,
    (__bridge id)[[UIColor clearColor] colorWithAlphaComponent:1].CGColor];
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 0.15);//仅仅只有头部渐变
    //注意：这里不用下边的这句话
    //[gradientView.layer addSublayer:gradientLayer];//将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    //设置蒙版，用来改变layer的透明度
    [self.layer setMask:gradientLayer];
}

//创建渐变视图
- (void)setHorizontalGradientView{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    //设置渐变颜色数组,可以加透明度的渐变
    gradientLayer.colors = @[(__bridge id)[[UIColor clearColor] colorWithAlphaComponent:0].CGColor,
    (__bridge id)[[UIColor clearColor] colorWithAlphaComponent:1].CGColor,
    (__bridge id)[[UIColor clearColor] colorWithAlphaComponent:1].CGColor,
    (__bridge id)[[UIColor clearColor] colorWithAlphaComponent:1].CGColor,
    (__bridge id)[[UIColor clearColor] colorWithAlphaComponent:1].CGColor,
    (__bridge id)[[UIColor clearColor] colorWithAlphaComponent:1].CGColor,
    (__bridge id)[[UIColor clearColor] colorWithAlphaComponent:1].CGColor,
    (__bridge id)[[UIColor clearColor] colorWithAlphaComponent:1].CGColor,
    (__bridge id)[[UIColor clearColor] colorWithAlphaComponent:1].CGColor,
    (__bridge id)[[UIColor clearColor] colorWithAlphaComponent:1].CGColor,
    (__bridge id)[[UIColor clearColor] colorWithAlphaComponent:1].CGColor,
    (__bridge id)[[UIColor clearColor] colorWithAlphaComponent:0].CGColor];
    //设置渐变区域的起始和终止位置（范围为0-1）
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.05),@(0.1),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6),@(0.7),@(0.8),@(0.9),@(0.95)];
    //注意：这里不用下边的这句话
    //[gradientView.layer addSublayer:gradientLayer];//将CAGradientlayer对象添加在我们要设置背景色的视图的layer层
    //设置蒙版，用来改变layer的透明度
    [self.layer setMask:gradientLayer];
}

- (UIViewController *)self_viewController {
    UIView *view = self;
    while (view) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        view = view.superview;
      }
    return nil;
}

- (void)setRadius:(CGFloat)radius {
    [self.layer setCornerRadius:radius];
    [self.layer setMasksToBounds:YES];
}

- (void)setBorderColor:(UIColor *)color borderWidth:(CGFloat)width radius:(CGFloat)radius {
    [self.layer setBorderWidth:(width)];
    [self.layer setBorderColor:[color CGColor]];
    if (radius) {
        [self.layer setCornerRadius:(radius)];
        [self.layer setMasksToBounds:YES];
    }
}

- (void)setShadowColor:(UIColor *)shadowColor  radius:(CGFloat)radius shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity{
    [self.layer setCornerRadius:radius];
    [self.layer setMasksToBounds:NO];
    [self.layer setShadowRadius:shadowRadius];
    [self.layer setShadowOffset:shadowOffset];
    [self.layer setShadowOpacity:shadowOpacity];
    [self.layer setShadowColor:[shadowColor CGColor]];
}

- (void)setSomeRadius:(CGFloat)radius isBottomLeft:(BOOL)isBottomLeft isBottomRight:(BOOL)isBottomRight isTopLeft:(BOOL)isTopLeft  isTopRight:(BOOL)isTopRight{
    UIRectCorner corner = UIRectCornerAllCorners;
    if (isBottomLeft) corner = UIRectCornerBottomLeft;
    if (isBottomRight) corner = corner | UIRectCornerBottomRight;
    if (isTopLeft) corner = corner | UIRectCornerTopLeft;
    if (isTopRight) corner = corner | UIRectCornerTopRight;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
