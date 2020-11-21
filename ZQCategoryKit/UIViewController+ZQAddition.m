//
//  UIViewController+ZQAddition.m
//  Client
//
//  Created by apple on 2020/5/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import "UIViewController+ZQAddition.h"
#import <objc/runtime.h>

@interface UIViewController ()

@property (nonatomic, copy) BtnActionBlock btnActionBlock;

@end

@implementation UIViewController (ZQAddition)

- (void)setKtype:(NSInteger)ktype {
    objc_setAssociatedObject(self, @selector(ktype), @(ktype), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)ktype {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setKname:(NSString *)kname {
    objc_setAssociatedObject(self, @selector(kname),kname, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)kname {
    return objc_getAssociatedObject(self,_cmd);
}

#pragma mark - 获取当前屏幕显示的VC
+ (UIViewController *)zq_getCurrentViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    }else if([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    }else{
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

#pragma mark - 设置状态栏（通知栏）颜色

-(void)zq_backToController:(NSString *)controllerName animated:(BOOL)animaed{
    if (self.navigationController) {
        NSArray *controllers = self.navigationController.viewControllers;
        NSArray *result = [controllers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [evaluatedObject isKindOfClass:NSClassFromString(controllerName)];
        }]];
        
        if (result.count > 0) {
            [self.navigationController popToViewController:result[0] animated:YES];
        }
    }
}

- (void)popToViewController:(Class)viewControllerClass {
    if (self.navigationController) {
        NSArray *arr = self.navigationController.viewControllers;
        for (int i=0;i<arr.count;i++) {
            UIViewController *v = [self.navigationController.viewControllers objectAtIndex:i];
            if([v isKindOfClass:viewControllerClass])
            {
                [self.navigationController popToViewController:v animated:YES];
                break;
            }
        }
    }
}

/// 移除某个控制器
-(void)zq_removeController:(NSString *)controllerName {
    [self zq_removeControllers:@[controllerName].mutableCopy];
}

/// 移除多个控制器
-(void)zq_removeControllers:(NSMutableArray <NSString *>*)controllers {
    if (self.navigationController) {
        NSMutableArray *vcArr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
        NSMutableArray *vcin = [NSMutableArray array];
        for (NSString *vcstr in controllers) {
            for (UIViewController *vc in vcArr) {
                if ([vc isKindOfClass:[NSClassFromString(vcstr) class]]) {
                    [vcin addObject:vc];
                }
            }
        }
        for (UIViewController *x in vcin) {
            [vcArr removeObject:x];
            [x removeFromParentViewController];
        }
        self.navigationController.viewControllers = vcArr;
    }
}

-(UIButton *)addLeftNavigateItemWithImage:(NSString *)imageName target:(UIViewController *)targetViewController btnHandler:(BtnActionBlock)btnActionBlock{
    return [self addNavigateItemWithTarget:self andPosition:NavigateItemPositionLeft andType:NavigateItemTypeImage andTypeStr:imageName andItemColor:UIColor.whiteColor btnHandler:btnActionBlock];
}

-(UIButton *)addRightNavigateItemWithImage:(NSString *)imageName target:(UIViewController *)targetViewController btnHandler:(BtnActionBlock)btnActionBlock{
    return [self addNavigateItemWithTarget:self andPosition:NavigateItemPositionRight andType:NavigateItemTypeImage andTypeStr:imageName andItemColor:UIColor.whiteColor btnHandler:btnActionBlock];
}

-(UIButton *)addLeftNavigateItemWithTitle:(NSString *)itemName target:(UIViewController *)targetViewController itemColor:(UIColor *)itemColor btnHandler:(BtnActionBlock)btnActionBlock{
    return [self addNavigateItemWithTarget:self andPosition:NavigateItemPositionLeft andType:NavigateItemTypeImage andTypeStr:itemName andItemColor:itemColor btnHandler:btnActionBlock];
}

-(UIButton *)addRightNavigateItemWithTitle:(NSString *)itemName target:(UIViewController *)targetViewController itemColor:(UIColor *)itemColor btnHandler:(BtnActionBlock)btnActionBlock{
    return [self addNavigateItemWithTarget:self andPosition:NavigateItemPositionRight andType:NavigateItemTypeImage andTypeStr:itemName andItemColor:itemColor btnHandler:btnActionBlock];
}

#pragma mark - 内部方法
-(UIButton *)addNavigateItemWithTarget:(UIViewController *)targetViewController andPosition:(NavigateItemPosition)position andType:(NavigateItemType)type andTypeStr:(NSString *)typeStr andItemColor:(UIColor *)titleColor btnHandler:(BtnActionBlock)btnActionBlock{
    self.btnActionBlock = btnActionBlock;
    UIButton *button = [[UIButton alloc] init];
    CGFloat imaW = 0;
    switch (type) {
        case NavigateItemTypeTitle:
        {
            [button setTitle:typeStr forState:UIControlStateNormal];
            NSInteger index = typeStr.length;
            CGFloat w = 20 + 18*(index - 1);
            button.frame = CGRectMake(0, 0, w + imaW, 44);
            
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            
            if (titleColor) {
                [button setTitleColor:titleColor forState:UIControlStateNormal];
            }else{
                [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
            }
        }
            break;
        case NavigateItemTypeImage:
        {
            imaW = 44;
            [button setImage:[UIImage imageNamed:typeStr] forState:UIControlStateNormal];
            [button setFrame:CGRectMake(0, 0, imaW, imaW)];
        }
            break;
    }
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    switch (position) {
        case NavigateItemPositionLeft:
            targetViewController.navigationItem.leftBarButtonItem = barBtn;
            break;
        case NavigateItemPositionRight:
            targetViewController.navigationItem.rightBarButtonItem = barBtn;
        break;
        default:
            break;
    }
    
    [button addTarget:self action:@selector(fm_btnAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)fm_btnAction:(UIButton *)sender {
    if (self.btnActionBlock) {
        self.btnActionBlock(sender);
    }
}
@end
