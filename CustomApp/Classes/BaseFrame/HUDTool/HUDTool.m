//
//  HUDTool.m
//  GjFax
//
//  Created by litao on 15/9/7.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import "HUDTool.h"
#import "CommonDefine.h"
#import "AppDelegate.h"

#import "HttpTool.h"

#import "MBProgressHUD.h"
#import "SVProgressHUD.h"

#import "UIImage+GIF.h"

static NSString * const kDefaultHudLabelText = @"努力加载中..";


@interface HUDTool () <MBProgressHUDDelegate> {
//计时器 检查view 是否需要清理
    NSTimer *timer;
}

//当前hud 添加到的 VC
@property (nonatomic, strong) UIViewController *currentVC;

@property (nonatomic, strong) UIView *viewHud; //view 方式的view

@property (nonatomic, strong) UIView *windowHud;// window方式的view

@property (nonatomic, assign) NSInteger viewReferencedCount;//view 方式的引用计数

@property (nonatomic, assign) NSInteger windowReferencedCount;//window 方式的引用计数
@end

@implementation HUDTool
#pragma mark - hud显示在keyWindow上
/**
 *  显示mbprogresshud on keyWindow
 */
+ (id)showHUDOnKeyWindow:(NSString *)info whileExecutingBlock:(ShowHUDWithBlock)showHUDWithBlock
{
    //  获取keyWindow
    MBProgressHUD *hud  = nil;
    if (![HUDTool shareHUDTool].windowHud) {
        [HUDTool shareHUDTool].windowReferencedCount = 0;
        
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        [HUDTool shareHUDTool].windowHud = keyWindow;
        
        hud = [[MBProgressHUD alloc] initWithView:keyWindow];
        [keyWindow addSubview:hud];
      
    }
    
    [HUDTool shareHUDTool].windowReferencedCount++;
    
    hud.label.text = info ? info : kDefaultHudLabelText;
    
    [hud showAnimated:YES whileExecutingBlock:^{
        showHUDWithBlock();
    } completionBlock:^{
        [hud removeFromSuperview];
        [HUDTool shareHUDTool].windowReferencedCount--;
    }];
    
    
    return hud;
    
}

/**
 *  keyWindow显示hud - 非block
 *
 *  @return
 */
+ (id)showHUDOnKeyWindow
{
    //  显示默认字符hud
    MBProgressHUD *hud = [self showHUDOnKeyWindow:kDefaultHudLabelText];
    
    return hud;
}

/**
 *  keyWindow显示hud - 非block
 *
 *  @return
 */
+ (id)showHUDOnKeyWindow:(NSString *)info
{
    //  获取keyWindow
    MBProgressHUD *hud = nil;
    if (![HUDTool shareHUDTool].windowHud) {
        [HUDTool shareHUDTool].windowReferencedCount = 0;
        UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] lastObject];
        //  先判断keyWindow上有无hud - 有则不添加
        [HUDTool shareHUDTool].windowHud = keyWindow;
        
        hud = [[MBProgressHUD alloc] initWithView:keyWindow];
        [keyWindow addSubview:hud];
    }
    hud.label.text = info;
    
    UIImage *image = [UIImage imageNamed:@"hudGif_1"];
    UIImageView *gifview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width * .5f, image.size.height * .5f)];
    //  帧动画数组
    NSMutableArray *hudImgArray = [NSMutableArray array];
    for (int idx = 1; idx <= 4; idx++) {
        UIImage *hudImg = [UIImage imageNamed:FMT_STR(@"hudGif_%d", idx)];
        [hudImgArray addObject:hudImg];
    }
    if (hudImgArray.count > 0) {
        [gifview setAnimationImages:hudImgArray];
        [gifview setAnimationDuration:hudImgArray.count * .2f];
        [gifview startAnimating];
        
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = gifview;
        //  文字信息置空
        hud.label.text = @"";
        //  背景色
        hud.bezelView.color = RGBColorAlpha(0, 0, 0, .5f);
        //  移除毛玻璃效果UIVisualEffectView
        for (UIView *subView in hud.bezelView.subviews) {
            if ([subView isKindOfClass:[UIVisualEffectView class]]) {
                [subView removeFromSuperview];
                break;
            }
        }
    }
    //  隐藏的时候从父视图移除
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    
    [HUDTool shareHUDTool].windowReferencedCount++;
    
    return hud;
}

#pragma mark - hud显示在view上
/**
 *  显示mbprogresshud
 *
 *  @param view
 *
 */
+ (id)showHUDOnView
{
#pragma mark - 替换层window loading
    MBProgressHUD *hud = [HUDTool showHUDOnKeyWindow];
//    MBProgressHUD *hud = [self showHUDOnViewWithInfo:kDefaultHudLabelText animated:YES];
    
    return hud;
}

/**
 *  显示mbprogresshud
 *
 *  @param view
 *
 */
+ (id)showHUDOnViewWithInfo:(NSString *)info
{
    MBProgressHUD *hud = [self showHUDOnViewWithInfo:info animated:YES];
    
    return hud;
}

/**
 *  显示mbprogresshud
 *  该方法 hud 加载 到windows上，并且可以点击 navbar
 *  使用 timer 检测返回，撤销HUD
 *  @param view
 *
 */
+ (id)showHUDOnViewWithInfo:(NSString *)info
             animated:(BOOL)animated
{
    //  网络检查
    if (![HttpTool isNetworkOpen]) {
        return nil;
    }
    
    MBProgressHUD *hud  = nil;
    if (![HUDTool shareHUDTool].viewHud) {
        [HUDTool shareHUDTool].viewReferencedCount = 0;
        AppDelegate *mainApp = ((AppDelegate*)[[UIApplication sharedApplication] delegate]);
        
        UIWindow *keyWindow = mainApp.window;
//        UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] lastObject];

            //预留 nav 高度，可点击
        UIView *windowView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, keyWindow.width, keyWindow.height - 64)];
        
        windowView.backgroundColor = [UIColor clearColor];
        
        [keyWindow addSubview:windowView];
        [HUDTool shareHUDTool]->_viewHud = windowView;
        
            //    DLog(@" showHUDWithView vc %@",GJSTopMostViewController());
        
        [HUDTool shareHUDTool]->timer = [NSTimer scheduledTimerWithTimeInterval:.25f target:self selector:@selector(removeKeyWindowsView) userInfo:nil repeats:YES];
        
        hud = [[MBProgressHUD alloc] initWithView:windowView];
        [windowView addSubview:hud];
    }
 
    [HUDTool shareHUDTool].viewReferencedCount++;
    //  文字信息
    hud.label.text = info;
    //  隐藏的时候从父视图移除
    hud.removeFromSuperViewOnHide = YES;
    //  设置最短显示时间 - 网速快不需显示 - 设置为0
    hud.minShowTime = 0;
    //  设置宽限期 - 配合标志位taskInProgress
    //  这个属性设置了一个宽限期，它是在没有显示HUD窗口前被调用方法可能运行的时间。
    //  如果被调用方法在宽限期内执行完，则HUD不会被显示。
    //  这主要是为了避免在执行很短的任务时，去显示一个HUD窗口。
    //  默认值是0。只有当任务状态是已知时，才支持宽限期。具体我们看实现代码。
    hud.graceTime = 0;//.5f;
    //  No longer needed
    //hud.taskInProgress = YES;
    //  相对父视图中心点偏移量 - 向上偏移50像素
//    hud.yOffset = -50.0f;
    
    [hud showAnimated:animated];
    [HUDTool shareHUDTool]->_currentVC = GJSTopMostViewController();
    
    return hud;
}

/**
 *  移除timer、HUD
 */
+ (void)removeKeyWindowsView
{
    if ([HUDTool shareHUDTool]->_currentVC != GJSTopMostViewController()
        && [HUDTool shareHUDTool]->_viewHud) {
        [HUDTool hideHUDOnView];
    }
//    DLog(@" removeKeyWindowsView %@ %@",GJSTopMostViewController(),[HUDTool shareHUDTool]->_currentVC);

}


/**
 *  显示mbprogresshud - 自定义图片
 *
 *  @param view
 *
 */
+ (id)showHUDWithDefaultCutomView:(UIView *)view;
{
    //  添加hud
    MBProgressHUD *hud = [self showHUDOnView];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_information"]];
    hud.mode = MBProgressHUDModeCustomView;
    
    return hud;
}

/**
 *  显示mbprogresshud - 自定义图片
 *
 *  @param view
 *
 */
+ (id)showHUDWithCutomView:(UIView *)view
                    imgStr:(NSString *)imgStr
                      info:(NSString *)info
                  animated:(BOOL)animated
{
    //  添加hud
    MBProgressHUD *hud = [self showHUDOnViewWithInfo:info animated:animated];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgStr]];
    hud.mode = MBProgressHUDModeCustomView;
    
    return hud;
}

/**
 *  隐藏mbprogresshud
 *
 *  @param view
 *
 */
+ (BOOL)hideHUDOnView
{
//    DLog(@"%s %@",__FUNCTION__,GJSTopMostViewController());
//    [HUDTool checkViewReferencedCount];
//    if ([HUDTool shareHUDTool].viewReferencedCount > 0) {
//        return NO;
//    }
//    BOOL hide = [MBProgressHUD hideAllHUDsForView:[HUDTool shareHUDTool]->_viewHud animated:YES];
//    
//    [HUDTool resetViewProperty];
//
//    return hide;
#pragma mark - 替换层window loading
    [HUDTool hideHUDOnKeyWindow];
    return YES;
}

/**
 *  隐藏mbprogresshud
 *
 *  @param view
 *
 */
+ (void)hideHUDOnViewWithAfterDelay:(NSTimeInterval)delay
{
//    DLog(@"%s ",__FUNCTION__);
    [HUDTool checkViewReferencedCount];
    if ([HUDTool shareHUDTool].viewReferencedCount > 0) {
        return ;
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[HUDTool shareHUDTool].viewHud];
    //  隐藏
    [hud hideAnimated:YES afterDelay:delay];
    
    [HUDTool resetViewProperty];
}

/**
 *  隐藏keyWindow上得hud
 *
 *  @return
 */
+ (NSUInteger)hideHUDOnKeyWindow
{
    [HUDTool checkWindowReferencedCount];
    if ([HUDTool shareHUDTool].windowReferencedCount > 0) {
        return 0;
    }
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    NSInteger count = [MBProgressHUD hideAllHUDsForView:keyWindow animated:YES];

    [HUDTool resetWindowProperty];


    return count;
}

#pragma mark - MBProgress delegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    //  如果hud存在
    if (hud) {
        [hud removeFromSuperview];
        hud = nil;
    }
}

static HUDTool *_shareHUDTool= nil;
+ (instancetype)shareHUDTool
{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _shareHUDTool = [[HUDTool alloc] init];
    });
    return _shareHUDTool;
}

/**
 *  view 视图的 ReferencedCount --
 */
+ (void)checkViewReferencedCount
{
    [HUDTool shareHUDTool].viewReferencedCount--;
//    DLog(@"fun viewReferencedCount %s %d",__FUNCTION__,[HUDTool shareHUDTool].viewReferencedCount);
}

/**
 *  windows 视图的 ReferencedCount --
 */
+ (void)checkWindowReferencedCount
{
    [HUDTool shareHUDTool].windowReferencedCount--;
//    DLog(@"fun viewReferencedCount %s %d",__FUNCTION__,[HUDTool shareHUDTool].windowReferencedCount);
}

/**
 *  重置view属性
 */
+ (void)resetViewProperty
{
    if ([HUDTool shareHUDTool]->timer) {
        [[HUDTool shareHUDTool]->timer invalidate];
        [HUDTool shareHUDTool]->timer = nil;
    }
    
    [HUDTool shareHUDTool]->_currentVC = nil;
    
    if ([HUDTool shareHUDTool].viewHud) {
        [[HUDTool shareHUDTool].viewHud removeFromSuperview];
        [HUDTool shareHUDTool].viewHud = nil;
    }
    [HUDTool shareHUDTool].viewReferencedCount = 0;

}

/**
 *  重置window属性
 */
+ (void)resetWindowProperty
{
    [HUDTool shareHUDTool].windowReferencedCount = 0;
    if ([HUDTool shareHUDTool].windowHud) {
        [MBProgressHUD hideAllHUDsForView:[HUDTool shareHUDTool].windowHud animated:YES];
    }
    [HUDTool shareHUDTool].windowHud = nil;
}

/**
 *  重置HUD属性
 */
+ (void)resetHUD
{
    [HUDTool resetWindowProperty];
    [HUDTool resetViewProperty];
}
@end
