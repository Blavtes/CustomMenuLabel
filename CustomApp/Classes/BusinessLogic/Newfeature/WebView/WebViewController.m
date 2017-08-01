//
//  WebViewController.m
//  HX_GJS
//
//  Created by litao on 16/1/26.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "WebViewController.h"
//#import "GJSShareSDKManager.h"

#import "GJSSwipeBackTool.h"
#import "WebViewJavascriptBridge.h"



@interface WebViewController () <UIWebViewDelegate> {
    //
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIImageView  *imageView;//分享时用的图片视图
@property (nonatomic, strong) NSString     *logopathKey;
@property (nonatomic, strong) NSString     *shareLogoUrlKey;
//  第一次加载webView无关闭所有页面按钮，否则存在
@property (nonatomic, assign) BOOL          isFirstLink;
//  记录网页跳转计数器
@property (nonatomic, assign) NSUInteger    clickNum;
//  由于每次页面变化，包括前进或者后退，webViewDidStart都会调用一次，需要区分开前进后退
@property (nonatomic, assign) BOOL          isClickBackBtn;
//  H5交互框架相关
@property WebViewJavascriptBridge           *bridge;
//  是否直接从H5获取分享信息
@property (nonatomic ,assign) BOOL          isShareInfo;

@end

@implementation WebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navTopView.titleLabel.text = self.title;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [HUDTool hideHUDOnView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_GREY_COLOR;
    _webView.backgroundColor = COMMON_GREY_COLOR;
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    
    //  单点登录相关
    [self aboutIsSSO];
    
    //  WebViewJavascriptBridge交互相关
    [self webViewJSBridge];
    
    //  分享图片相关
    [self shareParamsPic];
    
    [self aboutSwipeGesture];
    
    [self aboutNSNotificationCenter];
}

#pragma mark 接收通知相关
- (void)aboutNSNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWebView) name:@"reloadWebView" object:nil];
}

#pragma makr 接收通知的处理
- (void)reloadWebView
{
//    DLog(@"reloadWebView=====");
    
    if ([[WebViewInfoModel manager].webReg.redirectUrl respondsToSelector:@selector(isNullStr)] && ![[WebViewInfoModel manager].webReg.redirectUrl isNullStr] && [[WebViewInfoModel manager].webReg.redirectUrl hasPrefix:@"http"]) {
        
        _urlStr = [WebViewInfoModel manager].webReg.redirectUrl;
       
        [self aboutIsSSO];
    }
    if ([[WebViewInfoModel manager].webLogin.redirectUrl respondsToSelector:@selector(isNullStr)] && ![[WebViewInfoModel manager].webLogin.redirectUrl isNullStr] && [[WebViewInfoModel manager].webLogin.redirectUrl hasPrefix:@"http"]) {
        
        _urlStr = [WebViewInfoModel manager].webLogin.redirectUrl;
    
        [self aboutIsSSO];
    }
    // 清空值
    [WebViewInfoModel cleanWebViewInfoData];
    
    _urlStr = nil;
}


#pragma mark 手势计算相关
- (void)aboutSwipeGesture
{
    [self backClick];
    
    //向右滑动手势返回上一级
    GJSSwipeBackTool *gestureTool = [[GJSSwipeBackTool alloc]init];
    
    [gestureTool creatSwipeGestureRecognizer:self.view taget:self action:@selector(swipeClick:)];
    
    [_webView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:gestureTool.swipe];
    
    self.isFirstLink = YES;
    
    self.clickNum = 0;
}

#pragma mark 单点登录相关
- (void)aboutIsSSO
{
    //拼的一手好URL，需要单点登录的都要这样  HOST + AppJump/toPage?path= + 返回的url
    NSString *urlString = FMT_STR(@"%@",_urlStr);
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (_isSSO) {
        // 判断三值不可缺一，否则不走以下流程  ,且BOOL为NO;
        NSString *token = FMT_STR(@"%@",UserInfoUtil->getUserInfoWithValue(UserInfoValueTypeToken));
        NSString *sessionId = FMT_STR(@"%@",UserInfoUtil->getUserInfoWithValue(UserInfoValueTypeSessionId));
        NSString *rdkey = FMT_STR(@"%@",UserInfoUtil->getUserInfoWithValue(UserInfoValueTypeRdkey));
        if (![token isNullStr] && ![sessionId isNullStr] && ![rdkey isNullStr]) {
            //  清空相关的cookie
            NSString *cookiesKey = FMT_STR(@"%@AppJump/toPage",GJS_WAP_SERVER_HOST_ADDR);
            NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray *ssoCookies = [cookies cookiesForURL:
                                   [NSURL URLWithString:cookiesKey]];
            
            for (NSHTTPCookie* cookie in ssoCookies) {
                [cookies deleteCookie:cookie];
            }
            urlString = FMT_STR(@"%@AppJump/toPage?path=%@", GJS_WAP_SERVER_HOST_ADDR, urlString);
        } else {
            _isSSO = NO;
        }
    }
    NSURL *requestUrl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *requst = [NSMutableURLRequest requestWithURL:requestUrl];
    
    if (_webViewShouldIgnoreCache) {
        requst.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    }
    
    //  单点登录
    if (_isSSO) {
        NSString *token = FMT_STR(@"%@",UserInfoUtil->getUserInfoWithValue(UserInfoValueTypeToken));
        NSString *sessionId = FMT_STR(@"%@",UserInfoUtil->getUserInfoWithValue(UserInfoValueTypeSessionId));
        NSString *rdkey = FMT_STR(@"%@",UserInfoUtil->getUserInfoWithValue(UserInfoValueTypeRdkey));
        
        if (![token isNullStr]) {
            [requst setValue:token forHTTPHeaderField:@"token"];
        }
        if (![sessionId isNullStr]) {
            [requst setValue:sessionId forHTTPHeaderField:@"sessionid"];
        }
        if (![rdkey isNullStr]) {
            [requst setValue:rdkey forHTTPHeaderField:@"rdkey"];
        }
        [requst setValue:[CommonMethod UUIDWithKeyChain] forHTTPHeaderField:@"uuid"];
    }
    [requst setValue:@"app" forHTTPHeaderField:@"from"];
    
    [_webView loadRequest:requst];

    [HUDTool showHUDOnView];
}

#pragma mark 分享图片相关
- (void)shareParamsPic
{
    //需要分享添加分享按钮
    if (self.shareParams) {
        DLog(@"self.shareParams is can");
        [self.navTopView showRightImageName:@"More_ActivityCenter_Share" rightHighlightImageName:@"More_ActivityCenter_Share" rightHandle:^(UIButton *view) {
            [self showShareSheet];
        }];
    }
    
    _logopathKey = ObjectForKeySafety(self.shareParams, @"logopath");
    _shareLogoUrlKey = ObjectForKeySafety(self.shareParams, @"shareLogoUrl");
    if (self.shareParams) {
        if (_logopathKey && ![_logopathKey isNullStr]) {
            DLog(@"logopath%@",ObjectForKeySafety(self.shareParams, @"logopath"));
            //微博对https 图片制约，只能先将logo下载至内存中
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:ObjectForKeySafety(self.shareParams, @"logopath")]];
        } else if (_shareLogoUrlKey && ![_shareLogoUrlKey isNullStr]) {
            DLog(@"shareLogoUrl%@",ObjectForKeySafety(self.shareParams, @"shareLogoUrl"));
            //微博对https 图片制约，只能先将logo下载至内存中
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:ObjectForKeySafety(self.shareParams, @"shareLogoUrl")]];
        }
    }
}

#pragma mark 各种不同返回情况
- (void)backClick
{
    if (_isFromEvaluationRisk) {
        // 从盈米基金首页过来
        self.navTopView.backClick = ^(UIButton *btn) {
            [self backToYMFundDeatil];
        };
    } else if (_isFromYMPurchaseView) {
        //  从盈米申购页过来
        self.navTopView.backClick = ^(UIButton *btn) {
            [self backToSpecificCountSec];
        };
        
    } else if (_isFromBankCardView) {
        //  从注册绑卡页过来
        self.navTopView.backClick = ^(UIButton *btn) {
            [self backToBankCardView];
        };
    } else if (_isFromInvestView) {
        //  从投资卡页过来
        self.navTopView.backClick = ^(UIButton *btn) {
            [self backToSpecificCountSec];
        };
    } else {
        // 正常状态返回上一级
        self.navTopView.backClick = ^(UIButton *btn) {
            [self backClick:btn];
        };
    }
}

#pragma mark WebViewJavascriptBridge交互相关
- (void)webViewJSBridge
{
    if (_bridge) {
//        return;
        DLog(@"_bridge return");
    }
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    
 
}

- (void)backToBankCardView
{
    //回首页
    [CommonMethod goBackHomeWithTabbar:0];
}

- (void)backToSpecificCountSec
{
    [CommonMethod backToSpecificVC:self.navigationController SpecificCount:2 fail:^{
        //  失败回到理财页
        [CommonMethod goBackHomeWithTabbar:1];
    }];
}

- (void)backToYMFundDeatil
{
    [CommonMethod backToSpecificVCWithOrder:self.navigationController SpecificName:@"YMFundDetailViewController" fail:^{
        //  失败回到理财页
        [CommonMethod goBackHomeWithTabbar:1];
    }];
}

- (void)closeAllClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backClick:(id)sender
{
    self.isClickBackBtn = YES;
    if (self.clickNum > 0) {
        self.clickNum --;
    }
    if (_webView.canGoBack) {
        if (self.clickNum == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [_webView goBack];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/** 右滑手势返回上一界面的动作 */
- (void)swipeClick:(UISwipeGestureRecognizer *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

#pragma mark - lazyLoad
- (void)setWebViewShouldIgnoreCache:(BOOL)webViewShouldIgnoreCache
{
    _webViewShouldIgnoreCache = webViewShouldIgnoreCache ? webViewShouldIgnoreCache : NO;
}

#pragma mark - delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // DLog(@"%@",webView.request.allHTTPHeaderFields);
    [HUDTool hideHUDOnView];
    // DLog(@"finishURL = %@", webView.request.URL);
    // 打印异常
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    
    // Undocumented access to UIWebView's JSContext
    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 以 JSExport 协议关联 native 的方法
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[WebViewController class]]) {
            self.context[@"Native"] = temp;
        }
    }
    
    // 注入JS代码无效
  //  [self JS:webView];
}

#pragma mark 注入JS代码
- (void)JS:(UIWebView *)webView
{
    NSString *js = @"function setupWebViewJavascriptBridge(callback) {if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }window.WVJBCallbacks = [callback];var WVJBIframe = document.createElement('iframe');WVJBIframe.style.display = 'none';WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';document.documentElement.appendChild(WVJBIframe);setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)}setupWebViewJavascriptBridge(function(bridge) {})";
    
    [webView stringByEvaluatingJavaScriptFromString:js];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.clickNum ++;
#pragma mark 只要页面发生变化，无论前进或者后退，代理都会被调用，当后退时页面计数器会减1，前进时不记录
    if (self.isClickBackBtn) {
        self.clickNum --;
    }
    if (self.isFirstLink) {
        [self.navTopView hideCloseAll];
    } else {
        [self.navTopView showCloseAllClickHandle:^(UIButton *view) {
            [self closeAllClick:view];
        }];
    }
    self.isFirstLink = NO;
    self.isClickBackBtn = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.clickNum ++;
    DLog(@"error:%@",error);
    [HUDTool hideHUDOnView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //  拦截错误url
    NSURL *requestURL =[request URL];
    //  由于andr打开pdf需要 格式调整为 'pdf: + url' 形式
    //  现iOS调整  拦截所有请求  遇到URL前4位为 'pdf:' 则截取掉
    NSString *specialChars = @"gjfile:";
    if ([requestURL.absoluteString hasPrefix:specialChars]) {
        //  截取特殊字符后的URL
        NSString *handledRequestURLString = [requestURL.absoluteString substringFromIndex:specialChars.length];
        
        //  new request
        NSURL *newURL = [NSURL URLWithString:handledRequestURLString];
        NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:newURL cachePolicy:request.cachePolicy timeoutInterval:request.timeoutInterval];
        
        [webView loadRequest:newRequest];
        return YES;
    }
    //基金测评页 完成按钮交互，返回上一个页面
    NSString *specialCharsRisak = @"gjfinish:";
    if ([requestURL.absoluteString hasPrefix:specialCharsRisak]) {
        
        if (_isFromEvaluationRisk) {
            // 是否从盈米基金首页过来
            [self backToYMFundDeatil];
            
        } else if (_isFromYMPurchaseView || _isFromInvestView) {
            // 是否从盈米申购页过来
            [self backToSpecificCountSec];
            
        } else if (_isFromBankCardView) {
            // 是否从注册绑卡页过来
            [self backToBankCardView];
            
        } else {
            [self backClick:nil];
        }
        return YES;
    }
    // 每个请求头都强行带上 js 交互 *** back不能返回上一层，直接退出
    // 如需 JS 交互 back 返回上一层，需添加属性控制，网页模型 标记 是否标记
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    NSDictionary *headerDic = mutableRequest.allHTTPHeaderFields;
    NSString *fromWhere = [headerDic objectForKeyForSafetyValue:@"from"];
    if (!fromWhere || ![@"app" isEqualToString:fromWhere]) {
        [mutableRequest addValue:@"app" forHTTPHeaderField:@"from"];
        
        request = [mutableRequest copy];
        
        [self.webView loadRequest:request];
        
        return NO;
    }
    return YES;
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 分享事件触发
- (void)showShareSheet
{
//    [UMEventIDManager sendEvent:E_ID_More_ActivityCenter_Click_Shared_Btn];
//    
//    UIImage *image = [UIImage imageWithName:@"icon80x80"];
//    id<ISSCAttachment> imageUrl = nil;
//    
//    if (self.imageView) {
//        NSString *strUrl = ObjectForKeySafety(self.shareParams, @"logopath");
//        NSString *ulrStr = ObjectForKeySafety(self.shareParams, @"shareLogoUrl");
//        if (strUrl && ![strUrl isNullStr]) {
//            imageUrl = [ShareSDK imageWithUrl:ObjectForKeySafety(self.shareParams, @"logopath")];
//        } else if (ulrStr && ![ulrStr isNullStr]) {
//            imageUrl = [ShareSDK imageWithUrl:ObjectForKeySafety(self.shareParams, @"shareLogoUrl")];
//        }
//    }else {
//        imageUrl = [ShareSDK jpegImageWithImage:image quality:1.0];
//    }
//    
//    if (_isShareInfo) {
//        id<ISSContent> shareDic = [ShareSDK content:[WebViewInfoModel manager].getShareInfo.shareContent
//                                     defaultContent:@"分享有惊喜哦!"
//                                              image:[ShareSDK imageWithUrl:[WebViewInfoModel manager].getShareInfo.shareLogoUrl]
//                                              title:[WebViewInfoModel manager].getShareInfo.shareTitle
//                                                url:[WebViewInfoModel manager].getShareInfo.shareUrl
//                                        description:nil
//                                          mediaType:SSPublishContentMediaTypeNews];
//        
//        [GJSShareSDKManager activityCenterstartShareSheet:self shareParams:shareDic];
//    } else if (_logopathKey && ![_logopathKey isNullStr]) {
//        id<ISSContent> shareDic = [ShareSDK content:ObjectForKeySafety(self.shareParams, @"content")
//                                     defaultContent:@"分享有惊喜哦!"
//                                              image:imageUrl
//                                              title:ObjectForKeySafety(self.shareParams, @"title")
//                                                url:ObjectForKeySafety(self.shareParams, @"url")
//                                        description:ObjectForKeySafety(self.shareParams, @"desc")
//                                          mediaType:SSPublishContentMediaTypeNews];
//        
//        [GJSShareSDKManager activityCenterstartShareSheet:self shareParams:shareDic];
//    } else if (_shareLogoUrlKey && ![_shareLogoUrlKey isNullStr]) {
//        id<ISSContent> shareDic = [ShareSDK content:ObjectForKeySafety(self.shareParams, @"shareContent")
//                                     defaultContent:@"分享有惊喜哦!"
//                                              image:imageUrl
//                                              title:ObjectForKeySafety(self.shareParams, @"shareTitle")
//                                                url:ObjectForKeySafety(self.shareParams, @"shareUrl")
//                                        description:ObjectForKeySafety(self.shareParams, @"title")
//                                          mediaType:SSPublishContentMediaTypeNews];
//        
//        [GJSShareSDKManager activityCenterstartShareSheet:self shareParams:shareDic];
//    }
}

- (void)showShareSheetShareContent:(NSString *)shareContent withShareTitle:(NSString *)shareTitle withshareUrl:(NSString *)shareUrl withImageUrl:(NSString *)imageLogoPath
{
//    UIImageView *shareImageView = [[UIImageView alloc] init];
//    [shareImageView sd_setImageWithURL:[NSURL URLWithString:imageLogoPath]];
//    UIImage *image = [UIImage imageWithName:@"icon80x80"];
//    id<ISSCAttachment> imageUrl = nil;
//    //微博对https 图片制约，只能先将logo下载至内存中
//    if (shareImageView) {
////        imageUrl = [ShareSDK jpegImageWithImage:shareImageView.image quality:1.0];
//        imageUrl = [ShareSDK imageWithUrl:imageLogoPath];
//    }else {
//        imageUrl = [ShareSDK jpegImageWithImage:image quality:1.0];
//    }
//    
//    id<ISSContent> shareDic = [ShareSDK content:shareContent
//                                 defaultContent:@"分享有惊喜哦!"
//                                          image:imageUrl
//                                          title:shareTitle
//                                            url:shareUrl
//                                    description:@""
//                                      mediaType:SSPublishContentMediaTypeNews];
//    
//    [GJSShareSDKManager activityCenterstartShareSheet:self shareParams:shareDic];
}


#pragma mark JS和OC交互

#pragma maek 公用方法，判断是否登录状态为前提
- (void)commonLogin:(id)data
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    if (data) {
        [WebViewInfoModel manager].webLogin.redirectUrl  = [(NSDictionary *)data objectForKeyForSafetyValue:@"redirectUrl"];
    }
    
}




#pragma mark 理财页接口
- (void)financialProList:(id)data {
    
    [CommonMethod goBackHomeWithTabbar:1];

}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadWebView" object:nil];
    [_bridge disableJavscriptAlertBoxSafetyTimeout];
}

@end
