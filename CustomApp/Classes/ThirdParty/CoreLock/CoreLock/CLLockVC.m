//
//  CLLockVC.m
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockVC.h"
#import "CoreLockConst.h"
#import "CoreArchive.h"
#import "CLLockLabel.h"
#import "CLLockNavVC.h"
#import "CLLockView.h"
#import "CLLockInfoView.h"
#import "PreCommonHeader.h"

#import "iToast.h"
#import "AppDelegate.h"



#import "AudioUtil.h"

@interface CLLockVC () <UIAlertViewDelegate>
{
    //  输入次数限制
    int verifyCount;
    //  校验手势密码错误 次数  后台不返回次数
    NSInteger    _verifyErrorCount;
}

/** 操作成功：密码设置成功、密码验证成功 */
@property (nonatomic,copy) void (^successBlock)(CLLockVC *lockVC, NSString *pwd);

//  稍后设置或者返回
@property (nonatomic, copy) void (^cancelBlock)();

@property (nonatomic,copy) void (^forgetPwdBlock)();

@property (nonatomic, copy) void (^accountLoginBlock)();

@property (weak, nonatomic) IBOutlet CLLockLabel *label;

@property (nonatomic,copy) NSString *msg;

@property (weak, nonatomic) IBOutlet CLLockView *lockView;

@property (weak, nonatomic) IBOutlet CLLockInfoView *lockInfoView;

@property (nonatomic,weak) UIViewController *vc;

@property (nonatomic,strong) UIBarButtonItem *resetItem;


@property (nonatomic,copy) NSString *modifyCurrentTitle;


@property (weak, nonatomic) IBOutlet UIView *actionView;

@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;

@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;


/** 直接进入修改页面的 */
@property (nonatomic,assign) BOOL isDirectModify;

//  用账号登陆
@property (nonatomic, weak) UIButton *accountLoginBtn;

//  关闭按钮
@property (nonatomic, weak) UIButton *closeBtn;
@end

@implementation CLLockVC

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //控制器准备
    [self vcPrepare];
    
    //数据传输
    [self dataTransfer];
    
    //事件
    [self event];
}

#pragma mark - 事件处理
/*
 *  事件
 */
-(void)event
{
    /*
     *  设置密码
     */
    
    /** 开始输入：第一次 */
    self.lockView.setPWBeginBlock = ^() {
        
        [self.label showNormalMsg:CoreLockPWDTitleFirst];
    };
    
    /** 开始输入：确认 */
    self.lockView.setPWConfirmlock = ^() {
        
        [self.label showNormalMsg:CoreLockPWDTitleConfirm];
    };
    
    
    /** 密码长度不够 */
    self.lockView.setPWSErrorLengthTooShortBlock = ^(NSUInteger currentCount) {
      
        [self.label showWarnMsg:[NSString stringWithFormat:@"请连接至少%@个点",@(CoreLockMinItemCount)]];
        [[AudioUtil sharedInstance] startAudioVibrate];
    };
    
    /** 两次密码不一致 */
    self.lockView.setPWSErrorTwiceDiffBlock = ^(NSString *pwd1,NSString *pwdNow) {
        
        [self.label showWarnMsg:CoreLockPWDDiffTitle];
        [[AudioUtil sharedInstance] startAudioVibrate];
    };
    
    /** 第一次输入密码：正确 */
    self.lockView.setPWFirstRightBlock = ^(NSString *pwd) {
      
        [self.label showNormalMsg:CoreLockPWDTitleConfirm];
        //  显示第一次输入的密码
        self.lockInfoView.firstRightPWD = pwd;
        //  第一次输入正确后就出现重设按钮
        self.navigationItem.rightBarButtonItem = self.resetItem;
    };
    
    /** 再次输入密码一致 */
    self.lockView.setPWTwiceSameBlock = ^(NSString *pwd) {
      
        //  存储密码[V3.2.1保存到后台]
        //[CoreArchive setStr:pwd key:CoreLockPWDKey];
        
        //禁用交互
        self.view.userInteractionEnabled = NO;
 
       
    };
    
    /*
     *  验证密码
     */
    
    /** 开始 */
    self.lockView.verifyPWBeginBlock = ^(){
        
        [self.label showNormalMsg:CoreLockVerifyNormalTitle];
    };
    
    /** 验证 */
    self.lockView.verifyPwdBlock = ^(NSString *pwd){
    
     
        return NO;
        
    };
    
    /*
     *  修改
     */
    
    /** 开始 */
    self.lockView.modifyPwdBlock =^(){
      
        [self.label showNormalMsg:self.modifyCurrentTitle];
    };
    
}

/*
 *  数据传输
 */
- (void)dataTransfer
{
    
    [self.label showNormalMsg:self.msg];
    
    //传递类型
    self.lockView.type = self.type;
}

/*
 *  控制器准备
 */
- (void)vcPrepare
{

    //设置背景色
    self.view.backgroundColor = CoreLockViewBgColor;
    
    //初始情况隐藏
    self.navigationItem.rightBarButtonItem = nil;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //默认标题
    self.modifyCurrentTitle = CoreLockModifyNormalTitle;
    
    if(CoreLockTypeModifyPwd == _type) {
        
        _actionView.hidden = YES;
        
        [_actionView removeFromSuperview];

        if(_isDirectModify) return;
        
#pragma mark - 关闭按钮
        [CustomNavigationBarButtonItem customLeftItemTitle:@"关闭" target:self action:@selector(dismiss)];

    }
    
    if (![self.class hasPwd]) {
        [_modifyBtn removeFromSuperview];
    }
    
    //  是否显示默认按钮
    [_modifyBtn setHidden:YES];
    [_modifyBtn setEnabled:NO];
    
    [_forgetBtn setHidden:YES];
    [_forgetBtn setEnabled:NO];
    //  创建账号登陆按钮
    UIButton *accountLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (isRetina) {
        //  4s
        accountLoginBtn.frame = CGRectMake(MAIN_SCREEN_WIDTH * .5f - 50, MAIN_SCREEN_HEIGHT - 40 - STATUS_BAR_HEIGHT - NAVI_HEIGHT, 100, 40);
    } else {
        //  非4s
        accountLoginBtn.frame = CGRectMake(MAIN_SCREEN_WIDTH * .5f - 50, MAIN_SCREEN_HEIGHT - 60 - STATUS_BAR_HEIGHT - NAVI_HEIGHT, 100, 40);
    }
    
    [accountLoginBtn setTitle:@"账号登录" forState:UIControlStateNormal];
    [accountLoginBtn setTitleColor:COMMON_CHARACTER_TOUCHDOWN_COLOR forState:UIControlStateHighlighted];
    [accountLoginBtn setTitleColor:COMMON_BLUE_GREEN_COLOR forState:UIControlStateNormal];
    accountLoginBtn.backgroundColor = [UIColor clearColor];
    accountLoginBtn.clipsToBounds = YES;
    [accountLoginBtn addTarget:self action:@selector(pushLoginVc) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:accountLoginBtn];
    _accountLoginBtn = accountLoginBtn;
    
    //  是否显示底部按钮
    if (_isDefaultLockLogin) {
        [self showDefaultBtn];
    } else {
        [_accountLoginBtn setTitle:@"账号验证" forState:UIControlStateNormal];
        [self hideDefaultBtn];
    }
    
    if (self.type == CoreLockTypeSetPwd) {
        [_accountLoginBtn setHidden:YES];
        [_accountLoginBtn setEnabled:NO];
    } else {
        [_accountLoginBtn setHidden:NO];
        [_accountLoginBtn setEnabled:YES];
    }
    
    //  注册流程中打开按钮
    if (_isRegistSetting) {
        [_accountLoginBtn setHidden:NO];
        [_accountLoginBtn setEnabled:YES];
        [_accountLoginBtn setTitle:@"稍后设置" forState:UIControlStateNormal];
        [_accountLoginBtn setTitleColor:COMMON_CHARACTER_TOUCHDOWN_COLOR forState:UIControlStateHighlighted];
        
        [accountLoginBtn removeTarget:self action:@selector(pushLoginVc) forControlEvents:UIControlEventTouchUpInside];
        [accountLoginBtn addTarget:self action:@selector(dismissCancel) forControlEvents:UIControlEventTouchUpInside];
        //  到这里表示已经看过这个页面了
        UserInfoUtil->setUserInfoWithBool(UserInfoBoolTypeShowedGestureView, YES);
    }
    
    //  关闭按钮

    [CustomNavigationBarButtonItem customLeftItemTitle:@"关闭" target:self action:@selector(back)];

    
    //  验证次数重置
    verifyCount = 0;
}

#pragma mark - 懒加载相关
/**
 *  懒加载
 *
 *  @param isDefaultLockLogin
 */
- (void)setIsDefaultLockLogin:(BOOL)isDefaultLockLogin
{
    _isDefaultLockLogin = isDefaultLockLogin ? isDefaultLockLogin : YES;
}

- (void)setIsRegistSetting:(BOOL)isRegistSetting
{
    _isRegistSetting = isRegistSetting ? isRegistSetting : NO;
}

- (void)setIsCloseGestureOnAppServer:(BOOL)isCloseGestureOnAppServer
{
    _isCloseGestureOnAppServer = isCloseGestureOnAppServer ? isCloseGestureOnAppServer :NO;
}

#pragma mark - 消失关闭相关
/**
 *  消失
 */
-(void)dismiss
{
    [self dismiss:0];
}

/**
 *  关闭
 */
- (void)back
{
    //  消失手势密码弹窗
    if (_isRegistSetting) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:NO completion:nil];
        });
        //  回调
        _cancelBlock();
        
        //  最好切到第一页
        [CommonMethod switchTabBar:HOME_INDEX];
        
    } else {
        
        [self dismiss];
        //  是否用于登陆
        if (_isDefaultLockLogin) {
            //  最好切到第一页
            [CommonMethod switchTabBar:HOME_INDEX];
        }
    }
}

#pragma mark - 不同类型设置处理
/*
 *  密码重设
 */
- (void)setPwdReset
{
    
    [self.label showNormalMsg:CoreLockPWDTitleFirst];
    
    //隐藏
    self.navigationItem.rightBarButtonItem = nil;
    
    //通知视图重设
    [self.lockView resetPwd];
}

/*
 *  忘记密码
 */
- (void)forgetPwd
{
    //
}

/*
 *  修改密码
 */
- (void)modiftyPwd
{
    //
}

/**
 *  隐藏修改按钮 显示自定义按钮
 */
- (void)hideDefaultBtn
{
    //  隐藏修改按钮 和 忘记按钮
}

#pragma mark - 账号登陆
- (void)pushLoginVc
{

    
}

- (void)showDefaultBtn
{
    //
}

/*
 *  是否有本地密码缓存？即用户是否设置过初始密码？
 */
+ (BOOL)hasPwd{
    
    NSString *pwd = [CoreArchive strForKey:CoreLockPWDKey];
    
    if (pwd.length <= 0) {
        pwd = nil;
    }
    
    return pwd != nil;
}

#pragma mark - 展示控制器相关
/*
 *  展示设置密码控制器
 */
+ (instancetype)showSettingLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock
{
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"设置手势密码";
    
    //设置类型
    lockVC.type = CoreLockTypeSetPwd;
    
    //保存block
    lockVC.successBlock = successBlock;
    
    return lockVC;
}

/**
 *  第一次见手势密码设置
 */
+ (instancetype)showSettingLockVCWithRegistSettingInVC:(UIViewController *)vc cancelBlock:(void(^)())cancelBlock successBlock:(void(^)(CLLockVC *lockVC,NSString *pwd))successBlock
{
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"设置手势密码";
    
    //设置类型
    lockVC.type = CoreLockTypeSetPwd;
    
    //第一次设置
    lockVC.isRegistSetting = YES;
    
    //保存block
    lockVC.successBlock = successBlock;
    //取消
    lockVC.cancelBlock = cancelBlock;
    
    return lockVC;
}

/*
 *  展示验证密码输入框
 */
+ (instancetype)showVerifyLockVCInVC:(UIViewController *)vc forgetPwdBlock:(void(^)())forgetPwdBlock successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock
{
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"手势解锁";
    
    //设置类型
    lockVC.type = CoreLockTypeVeryfiPwd;
    
    //保存block
    lockVC.successBlock = successBlock;
    lockVC.forgetPwdBlock = forgetPwdBlock;
    
    return lockVC;
}

/*
 *  关闭 手势密码
 */
+ (instancetype)showVerifyLockVCInVCForCloseGesture:(UIViewController *)vc forgetPwdBlock:(void(^)())forgetPwdBlock successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock
{
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"手势解锁";
    
    //设置类型
    lockVC.type = CoreLockTypeVeryfiPwd;
    
    //  是否关闭服务器手势密码
    lockVC.isCloseGestureOnAppServer = YES;
    
    //保存block
    lockVC.successBlock = successBlock;
    lockVC.forgetPwdBlock = forgetPwdBlock;
    
    return lockVC;
}

/**
 *  展示密码输入框--账号登陆
 */
+ (instancetype)showVerifyLockWithAccoutLoginVCInVC:(UIViewController *)vc forgetPwdBlock:(void(^)())forgetPwdBlock successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock
{
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"手势解锁";
    
    //设置类型
    lockVC.type = CoreLockTypeVeryfiPwd;
    
    // 是否登录
    lockVC.isDefaultLockLogin = YES;
    
    //保存block
    lockVC.successBlock = successBlock;
    lockVC.forgetPwdBlock = forgetPwdBlock;
    
    return lockVC;
}

/*
 *  展示 重置密码前的 验证手势
 */
+ (instancetype)showModifyLockVCInVC:(UIViewController *)vc
                        successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock
{
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"修改密码";
    
    //设置类型
    lockVC.type = CoreLockTypeModifyPwd;

    lockVC.successBlock = successBlock;
    
    return lockVC;
}

/*
 *  展示 重置密码
 */
+ (instancetype)showRetSettingLockVCInVC:(UIViewController *)vc
                           oldGesturePwd:(NSString *)oldGesturePwd
                            resetPwdType:(NSString *)resetPwdType
                            successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock
{
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"设置手势密码";
    
    //设置类型
    lockVC.type = CoreLockTypeSetPwd;
    
    lockVC.isVeryfiRetSetPwd = YES;
    // 旧的密码
    lockVC.oldGesturePwd = oldGesturePwd;
    // 重置密码的类型
    lockVC.resetPwdType = FMT_STR(@"%@",resetPwdType);
    //保存block
    lockVC.successBlock = successBlock;
    
    return lockVC;
}


+ (instancetype)lockVC:(UIViewController *)vc
{
    
    CLLockVC *lockVC = [[CLLockVC alloc] init];

    lockVC.vc = vc;
    
    CLLockNavVC *navVC = [[CLLockNavVC alloc] initWithRootViewController:lockVC];
    
    [vc presentViewController:navVC animated:YES completion:nil];

    
    return lockVC;
}

- (void)setType:(CoreLockType)type
{
    
    _type = type;
    
    //根据type自动调整label文字
    [self labelWithType];
}

/*
 *  根据type自动调整label文字
 */
- (void)labelWithType
{
    
    if (CoreLockTypeSetPwd == _type) {//设置密码
        
        self.msg = CoreLockPWDTitleFirst;
        
    } else if (CoreLockTypeVeryfiPwd == _type) {//验证密码
        
        self.msg = CoreLockVerifyNormalTitle;
        
    } else if (CoreLockTypeModifyPwd == _type) {//修改密码
        
        self.msg = CoreLockModifyNormalTitle;
    }
}

/**
 *  自定义label
 *
 *  @param str
 */
- (void)labelWithStr:(NSString *)str
{
    [self.label showNormalMsg:FMT_STR(@"%@", str)];
}

/*
 *  消失
 */
- (void)dismiss:(NSTimeInterval)interval {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

/**
 *  消失 - 第一次设置使用
 */
- (void)dismissCancel
{
    //  消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:nil];
    });
    //  回调
    if (_cancelBlock) {
        //  执行
        _cancelBlock();
    }
}

/*
 *  重置
 */
- (UIBarButtonItem *)resetItem
{
    
    if(_resetItem == nil){
        //添加右按钮
        _resetItem= [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(setPwdReset)];
    }
    
    return _resetItem;
}

- (IBAction)forgetPwdAction:(id)sender {

    [self dismiss:0];
    if(_forgetPwdBlock != nil) _forgetPwdBlock();
}

- (IBAction)modifyPwdAction:(id)sender {
    
    CLLockVC *lockVC = [[CLLockVC alloc] init];
    
    lockVC.title = @"修改密码";
    
    lockVC.isDirectModify = YES;
    
    //设置类型
    lockVC.type = CoreLockTypeModifyPwd;
    
    [self.navigationController pushViewController:lockVC animated:YES];
}

#pragma mark - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //得到输入框
        UITextField *pwdStrTF=[alertView textFieldAtIndex:0];
        if (pwdStrTF.text.length < 6 || pwdStrTF.text.length > 15) {
            [[[[iToast makeText:@"密码必须在6位以上,16位以下,由数字/字母/符号综合组成"] setGravity:iToastGravityCenter] setDuration:iToastDurationNormal] show];
        } else {
            [self verifyLoginPwd:pwdStrTF.text];
        }
    }
}

/**
 *  按钮动态地可用或者不可用
 */
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *pwdTF = [alertView textFieldAtIndex:0];
    
    //  pwd至少6位
    if (pwdTF.text.length > 5) {
        return YES;
    }
    return NO;
}

#pragma mark - 验证账号密码
- (void)verifyLoginPwd:(NSString *)pwdStr
{


}


/**
 *  登陆数据解析
 *
 *  @param data
 */
- (void)reqLogin_callBack:(id)data oldPwd:(NSString *)oldPwd
{
    // 密码验证成功
    [self dismiss];
    //  跳转到重新设置手势密码页面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //  当前显示页面的根视图
        UIViewController *curVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        // “1”是手势密码校验   “2”是登录密码校验
        [CLLockVC showRetSettingLockVCInVC:curVc oldGesturePwd:oldPwd resetPwdType:@"2" successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            [lockVC dismiss:.2f];
        }];
    });
}

@end
