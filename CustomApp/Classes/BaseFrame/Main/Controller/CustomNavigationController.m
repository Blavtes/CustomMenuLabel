//
//  CustomNavigationController.m
//
//  Created by 李涛 on 15/4/26.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import "CustomNavigationController.h"



@interface CustomNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

/**不用返回的结果页控制器名称数组*/
@property (strong, nonatomic) NSArray *viewControllerStrArray;

//  是否正在执行系统push/pop动画
@property (nonatomic, assign) BOOL curAnimating;
//  是否有手势返回
@property (nonatomic, assign) BOOL fromGesture;
@end

@implementation CustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self panBack];
    self.navigationBarHidden = YES;
    self.delegate = self;
}

- (void)setFromGesture:(BOOL)fromGesture
{
    _fromGesture = fromGesture;
}

- (void)setCurAnimating:(BOOL)animation
{
    _curAnimating = animation;
}

#pragma mark - 手势拖动返回
- (void)panBack {
    /* 结果页数组:不用添加返回手势 */
    /* 
     1,充值结果页：ChargeResultViewController
     2,提现结果页：WithdrawResultViewController
     3,注册结果页：RegistFinishViewController
     4,修改交易密码结果页：SetPaymentPWDSuceessViewController
     5,找回交易密码结果页：FindPayPassWordResetViewController
     6,绑定广金所银行卡成功结果页：AddBankCardSuccessViewController
     7,绑定广金所银行卡失败结果页：AddBankCardFailViewController
     8,绑定海盈活期银行卡结果页：MyFundCardSettingPWDResultViewController
     9,绑定盈米基金银行卡成功结果页：YMFundOpenAccountAddBankcardSuccessVC
     10,绑定盈米基金银行卡失败结果页：YMFundOpenAccountAddBankcardFailureVC
     11,普通定期投资结果页：FixedInvestSuccessViewController
     12,汇宝A投资结果页：HarborATypeInvestmentSuccessViewController
     13,活期投资结果页：MyFundPurchaseResultViewController
     14,汇宝D投资结果页：MyFundHarborPurchaseResultViewController
     15,盈米基金投资结果页：YMFundPurchaseResultViewController
     16,转让投资结果页：TransferInvestSuccessViewController
     17,特邀投资结果页：BusinessInvestResultViewController
     18,广积分兑换广金币结果页：IngegralExchangeToGJBResultViewController
     19,广积分兑换万里通成功结果页：ConvertDetailsSuccessViewController
     20,广积分兑换万里通失败结果页：ConvertDetailsFailViewController
     21,广积分兑换广金券结果页：ExchangeGJSTicketResultViewController
     22,更改手机号码完成页：SetPhoneNumberSuccessViewController
     保险投资结果页：
     **/
    
    _viewControllerStrArray = @[@"ChargeResultViewController",@"WithdrawResultViewController",@"RegistFinishViewController",                                    /* 1~3*/
                                @"SetPaymentPWDSuceessViewController",@"FindPayPassWordResetViewController",@"AddBankCardSuccessViewController",                /* 4~6*/
                                @"AddBankCardFailViewController",@"MyFundCardSettingPWDResultViewController", @"YMFundOpenAccountAddBankcardSuccessVC",         /* 7~9*/
                                @"YMFundOpenAccountAddBankcardFailureVC",@"FixedInvestSuccessViewController", @"HarborATypeInvestmentSuccessViewController",    /* 10~12*/
                                @"MyFundPurchaseResultViewController",@"MyFundHarborPurchaseResultViewController",@"YMFundPurchaseResultViewController",        /* 13~15*/
                                @"TransferInvestSuccessViewController",@"BusinessInvestResultViewController", @"IngegralExchangeToGJBResultViewController",     /* 16~18*/
                                @"ConvertDetailsSuccessViewController",@"ConvertDetailsFailViewController",@"ExchangeGJSTicketResultViewController" ,            /* 19~21*/
                                    @"SetPhoneNumberSuccessViewController" /*22*/
                                ];
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

// 返回函数
- (void)handleNavigationTransition:(UIPanGestureRecognizer *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.childViewControllers.count <= 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
//        BLYLogWarn(@"gestureRecognizerShouldBegin 表示用户在根控制器界面，就不需要触发滑动手势");
        return NO;
    }
    
    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    // 当前页面是显示结果页，不响应滑动手势
    UIViewController *vc = [self.childViewControllers lastObject];
    for (int i = 0; i < _viewControllerStrArray.count; i++) {
        Class class = NSClassFromString(_viewControllerStrArray[i]) ;
        if ([vc isKindOfClass:class]) {
//            BLYLogWarn(@"gestureRecognizerShouldBegin 当前页面是显示结果页，不响应滑动手势");
            return NO;
        }
    }
    
    _curAnimating = NO;
    _fromGesture = YES;
    
    return YES;
}

#pragma mark - 设置导航栏通用主题
/**
 *  在程序运行过程中 会在你程序中每个类调用一次initialize
 *  在这里设置Navigation相应主题
 */
+ (void)initialize
{
    //  设置UINavigationBar的主题
    [self setupNavigationBarTheme];
    
    //  设置UINavigationItem的主题
    [self setupNavigationItemTheme];
}

/**
 *  设置UINavigationBar的主题
 */
+ (void)setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];

    //  设置naviBar背景图片 - UIBarMetricsDefault/UIBarMetricsCompact
    if (isRetina) {
        [appearance setBackgroundImage:[UIImage imageNamed:@"navi_background_for_iphone4s"] forBarMetrics:UIBarMetricsDefault];
        appearance.barStyle = UIBarStyleBlack;
    } else {
        //  去掉导航栏的边界灰线
        [appearance setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        if (IOS7 && IOS_VERSION >= 8.0 && FourInch) {
            //  ios7以上关闭透明度
#pragma mark -- bug fix - ios8.0以后才设置
            appearance.translucent = NO;
        }
        appearance.barTintColor = COMMON_BLUE_GREEN_COLOR;
    }
    //  去掉下方shadow线
    [appearance setShadowImage:[[UIImage alloc] init]];
    
    //  设置文字属性 去掉阴影
    NSMutableDictionary *textDic = [NSMutableDictionary dictionary];
    //textDic[UITextAttributeTextColor] = [UIColor whiteColor];
    textDic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    //  过期 : 并不代表不能用, 仅仅是有最新的方案可以取代它
    //  UITextAttributeFont  --> NSFontAttributeName(iOS7)
    textDic[NSFontAttributeName] = CommonNavigationTitleFont;
    //textDic[UITextAttributeFont] = CommonNavigationTitleFont;
    //  取消阴影就是将offset设置为0
    textDic[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textDic];
}

/**
 *  设置UINavigationItem的主题
 */
+ (void)setupNavigationItemTheme
{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    textAttrs[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置高亮状态的文字属性
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // 设置不可用状态(disable)的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    /**设置背景**/
    // 技巧: 为了让某个按钮的背景消失, 可以设置一张完全透明的背景图片
    [appearance setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

}

#pragma mark - 设置导航栏通用按钮
/**
 *  拦截所有push进来的子Vc 判断是否是栈底控制器来实现导航栏的通用按钮
 *
 *  @param viewController Vc
 *  @param animated       animated
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
#pragma mark - 处理动画问题 - 2017.3.13
    if (_curAnimating) {
//        [BuglyTool reportVCPushException:viewController];
        return;
    } else if (animated) {
        _curAnimating = YES;
    }

#pragma mark - 其他问题
    //  如果push进来的不是栈底控制器 则隐藏底部tabBar
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        //  设置通用的导航栏按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"btn_navi_back" highlightImageName:@"btn_navi_back_selected" taget:self action:@selector(back)];
    
    }
    
#pragma mark - 采集数据[只统计非启动加载 && 非tabbar切换]
    //  目标类
    NSString *curClassName = [NSString stringWithUTF8String:object_getClassName(viewController)];
    
    if (self.viewControllers.count > 0) {
        //  当前类 - src
        NSString *srcClassName = [NSString stringWithUTF8String:object_getClassName(self.viewControllers[[self.viewControllers count] - 1])];
      
    }
 
#pragma mark - push跳转
    //  pushVc
    [super pushViewController:viewController animated:animated];
}

/**
 *  拦截所有present进来的子Vc 判断是否是栈底控制器来实现导航栏的通用按钮
 *
 *  @param viewController Vc
 *  @param animated       animated
 */
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {

    //DLog(@"presentVc = %@", [viewControllerToPresent class]);
    _curAnimating = NO;
    //  判断是否naviVc进来
    if (![viewControllerToPresent isKindOfClass:[UINavigationController class]] && [viewControllerToPresent isKindOfClass:[UIViewController class]]) {
        //  在presentVc的时候本身无navVc,需要自己创建一个navigationController，这样ViewController的navigationController属性不为nil,即可使用pushViewController。
        CustomNavigationController *navigationController = [[CustomNavigationController alloc] initWithRootViewController:viewControllerToPresent];
        
        //  设置通用的导航栏按钮
        //navigationController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"btn_navi_back" highlightImageName:@"btn_navi_back_selected" taget:self action:@selector(presentBack)];
        
        
        //  presentVc
        [super presentViewController:navigationController animated:flag completion:completion];
    } else {
        //  presentVc
        [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    }

}

#pragma mark - navi的pop
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
#pragma mark - 处理动画问题 - 2017.3.13
    if (!_fromGesture) {
        if (_curAnimating) {
//            [BuglyTool reportVCPopException:self];
            return nil;
        } else if (animated) {
            _curAnimating = YES;
        }
    } else {
        _fromGesture = NO;
    }
    
    UIViewController *curVc = [super popViewControllerAnimated:animated];
    
#pragma mark - 采集数据[只统计非启动加载 && 非tabbar切换]
    //  目标类
    NSString *curClassName = [NSString stringWithUTF8String:object_getClassName(curVc)];
    
    if (self.viewControllers.count > 0) {
    
    }
    
    return curVc;
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
#pragma mark - 处理动画问题 - 2017.3.13
     _curAnimating = NO;
    
//    BLYLogWarn(@"popToRootViewControllerAnimated");
#pragma mark - 采集数据[只统计非启动加载 && 非tabbar切换]
    //  目标类
    NSString *curClassName = [NSString stringWithUTF8String:object_getClassName(self.topViewController)];
    
    if (self.viewControllers.count > 0) {


    }
    
    return [super popToRootViewControllerAnimated:animated];
}

/**
 *  弹出当前Vc
 */
- (void)back
{
    //  这里用的是self, 因为self就是当前正在使用的导航控制器
    [self popViewControllerAnimated:YES];
}

/**
 *  弹出当前非根Vc
 */
- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}

/**
 *  弹出当前Vc
 */
- (void)presentBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIViewController* topVC = self.topViewController;
    
    return [topVC preferredStatusBarStyle];
    
}

#pragma mark - navi delegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated {
    _curAnimating = NO;
    
}
@end
