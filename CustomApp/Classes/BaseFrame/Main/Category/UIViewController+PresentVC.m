//
//  UIViewController+PresentVC.m
//  GjFax
//
//  Created by Blavtes on 2017/3/17.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "UIViewController+PresentVC.h"
#import "CustomNavigationController.h"

@implementation UIViewController (PresentVC)

- (void)swizzled_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    //重置 CustomNavigationController 动画开关
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    for (UIViewController *temp in vc.childViewControllers) {
        if ([temp isKindOfClass:[CustomNavigationController class]]) {
            CustomNavigationController *vc = (CustomNavigationController*)temp;
            [vc setCurAnimating:NO];
            [vc setFromGesture:NO];
        }
    }
    [self swizzled_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)swizzled_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    for (UIViewController *temp in vc.childViewControllers) {
        if ([temp isKindOfClass:[CustomNavigationController class]]) {
            CustomNavigationController *vc = (CustomNavigationController*)temp;
            [vc setCurAnimating:NO];
            [vc setFromGesture:NO];
        }
    }
    [self swizzled_dismissViewControllerAnimated:flag completion:completion];
}
#pragma mark - Method Swizzling
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [super class];
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(presentViewController:animated:completion:);
        SEL swizzledSelector = @selector(swizzled_presentViewController:animated:completion:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        SEL orginalDis = @selector(dismissViewControllerAnimated:completion:);
        SEL swizzledDis = @selector(swizzled_dismissViewControllerAnimated:completion:);
        
        Method originalMethodDis = class_getInstanceMethod(class, orginalDis);
        Method swizzledMethodDis = class_getInstanceMethod(class, swizzledDis);
        
        BOOL didAddMethodDis =
        class_addMethod(class,
                        orginalDis,
                        method_getImplementation(swizzledMethodDis),
                        method_getTypeEncoding(swizzledMethodDis));
        
        if (didAddMethodDis) {
            class_replaceMethod(class,
                                swizzledDis,
                                method_getImplementation(originalMethodDis),
                                method_getTypeEncoding(originalMethodDis));
        } else {
            method_exchangeImplementations(originalMethodDis, swizzledMethodDis);
        }
    });
}

@end

