//
//  pushNotifiWebViewViewController.m
//  HX_GJS
//
//  Created by gjfax on 15/11/6.
//  Copyright © 2015年 ZXH. All rights reserved.
//

#import "pushNotifiWebViewViewController.h"
#import "UIImage+Extension.h"
#import "UIView+Extension.h"

@interface pushNotifiWebViewViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView                 *webView;
@property (nonatomic, strong) UIActivityIndicatorView   *indView;
@end

@implementation pushNotifiWebViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self.view addSubview:self.webView];
    
    
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"btn_navi_back" highlightImageName:@"btn_navi_back_selected" taget:self action:@selector(dismissVC)];
    
    //加载返回键
    [self initLeftBtn];
    
    //  加载网页
    NSURLRequest *requst = [NSURLRequest requestWithURL:[NSURL URLWithString:self.requestURL]];
    [self.webView loadRequest:requst];
    
    [self.indView startAnimating];

}

/*
 *  加载返回按钮
 */
- (void)initLeftBtn
{
    UIView  *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 44, 44)];
    bgView.alpha = .8f;
    bgView.layer.cornerRadius = bgView.size.width/2;
    bgView.backgroundColor = [UIColor grayColor];
    [self.webView addSubview:bgView];
    
    UIButton *btn = [self itemWithImageName:@"btn_navi_back"
                         highlightImageName:@"btn_navi_back_selected"
                                      taget:self
                                     action:@selector(dismissVC)];
    [btn setX:(bgView.width-btn.width)/2.f];
    [btn setY:(bgView.height-btn.height)/2.f];
    [bgView addSubview:btn];
}

/*
 *  返回
 */
- (void)dismissVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIButton *)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName taget:(id)taget action:(SEL)action
{
    //  设置背景图片
    UIButton *barButtonItem = [[UIButton alloc] init];
    [barButtonItem setBackgroundImage:[UIImage imageWithName:imageName] forState:UIControlStateNormal];
    [barButtonItem setBackgroundImage:[UIImage imageWithName:highlightImageName] forState:UIControlStateHighlighted];
    
    //  设置大小
    barButtonItem.size = barButtonItem.currentBackgroundImage.size;
    
    //  按钮点击高光
    barButtonItem.showsTouchWhenHighlighted = YES;
    
    //  监听点击事件
    [barButtonItem addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
    
    //  返回自定义UIBarButtonItem
    return barButtonItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Getter && Setter
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
        _webView.keyboardDisplayRequiresUserAction = NO;
        [_webView setScalesPageToFit:YES];
    }
    return _webView;
}

-(UIActivityIndicatorView *)indView
{
    if (!_indView) {
        _indView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indView setHidesWhenStopped:YES]; //当旋转结束时隐藏
        _indView.center = self.webView.center;
        [self.webView addSubview:_indView];
    }
    return _indView;
}

-(void)setRequestURL:(NSString *)requestURL
{
    _requestURL = requestURL;
}


#pragma mark -- webView Delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.indView stopAnimating];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
