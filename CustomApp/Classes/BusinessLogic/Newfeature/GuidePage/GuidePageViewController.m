//
//  GuidePageViewController.m
//  HX_GJS
//
//  Created by litao on 16/3/12.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "GuidePageViewController.h"
#import "PreCommonHeader.h"

static int const kPageTag = 100;

@interface GuidePageViewController () {
    BOOL _animating;
    //  记录该显示第几张引导页图片
    NSInteger curPageIdx;
}
//  scrollView
@property (strong, nonatomic) UIScrollView *pageScrollView;
//  进入app后引导页imgView
@property (strong, nonatomic) UIImageView *enteredGuidePageImageView;
//  本地默认引导页
@property (strong, nonatomic) NSArray *defaultGuideImgArr;
//  网络服务器上引导页
@property (strong, nonatomic) NSMutableArray *serverGuideImgArr;
//  进入app后的指引页
@property (strong, nonatomic) NSArray *enteredGuideImgArr;
@end

@implementation GuidePageViewController
#pragma mark - lazyLoad - setter && getter
- (NSMutableArray *)serverGuideImgArr
{
    if (!_serverGuideImgArr) {
        _serverGuideImgArr = [NSMutableArray array];
    }
    
    return _serverGuideImgArr;
}

#pragma mark - 请求数据

- (void)fetchGuideData
{
    NSMutableDictionary *reqDic = [[NSMutableDictionary alloc] init];
    [reqDic setObject:@"2" forKey:@"bannerType"];
    
    [HttpTool postUrl:HX_BANNER_URL params:reqDic success:^(id responseObj) {
        //  加载完成
        [self fetchGuideData_callBack:responseObj];
    } failure:^(NSError *error) {
        //  do something
    }];
}

- (void)fetchGuideData_callBack:(id)data
{
    NSDictionary *body = [NSDictionary dictionaryWithDictionary:data];
    
    NSString *retStatusStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"status"]);
//    NSString *retCodeStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"retCode"]);
//    NSString *retNoteStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"note"]);

    if ([retStatusStr isEqualToString:kInterfaceRetStatusSuccess]) {
        NSArray *resultArray = [[body objectForKeyForSafetyDictionary:@"result"] objectForKeyForSafetyArray:@"list"];
        for (NSDictionary *dic in resultArray) {
            NSString *guideImgURL = [dic objectForKeyForSafetyValue:@"saveURL"];
            [self.serverGuideImgArr addObject:guideImgURL];
        }
    }
}

#pragma mark - base init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  init
    [self initBaseData];
    [self initBaseView];
}

- (void)initBaseData
{
    //  初始化默认图片数组
    _defaultGuideImgArr = @[@"guidePage_1", @"guidePage_2"];
    _enteredGuideImgArr = @[@"GuidePageImage_1", @"GuidePageImage_2", @"GuidePageImage_3", @"GuidePageImage_4"];
}

- (void)initBaseView
{
    //  引导页
    _pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT)];
    _pageScrollView.pagingEnabled = YES;
    //  保证只能存放最多默认图片的引导页
    NSInteger imgCount = _defaultGuideImgArr.count;
    if (_serverGuideImgArr && _serverGuideImgArr.count > 0) {
        imgCount = _serverGuideImgArr.count;
    }
    _pageScrollView.contentSize = CGSizeMake(self.view.frame.size.width * imgCount, self.view.frame.size.height);
    [_pageScrollView setBounces:NO];
    _pageScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_pageScrollView];
    
    //  无网络图片则使用默认
    if (self.serverGuideImgArr && self.serverGuideImgArr.count <= 0) {
        [self initDefaultGuideImg];
        return;
    }
    
    //  开始下载图片
    UIImageView *view;
    for (int i = 0; i < self.serverGuideImgArr.count; i++) {
        //  下载图片
        NSURL *imgUrl = [NSURL URLWithString:self.serverGuideImgArr[i]];
        UIImage *defaultImg = [UIImage imageNamed:[_defaultGuideImgArr objectAtIndex:i]];
        //  获取默认
        view = [self.pageScrollView viewWithTag:(i + kPageTag)];
        if (view) {
            //  替换图片
            [view sd_setImageWithURL:imgUrl placeholderImage:defaultImg];
        } else {
            //  新建一个imgView
            view = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width * i), 0, self.view.width, self.view.height)];
            //  加载图片
            [view sd_setImageWithURL:imgUrl placeholderImage:defaultImg];
            //  添加view到引导页
            [self.pageScrollView addSubview:view];
            //  最后一页添加点击事件
            if (i == self.serverGuideImgArr.count - 1) {
                //  添加点击事件
                view.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressEnterButton:)];
                [view addGestureRecognizer:tap];
            }
        }
    }
}

- (void)initDefaultGuideImg
{
    //  添加默认图片
    UIImageView *view;
    for (int i = 0; i < _defaultGuideImgArr.count; i++) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width * i), 0, self.view.width, self.view.height)];
        //  默认图片
        view.image = [UIImage imageNamed:[_defaultGuideImgArr objectAtIndex:i]];
        //  添加view到引导页
        view.tag = kPageTag + i;
        [self.pageScrollView addSubview:view];
        //  最后一页添加点击事件
        if (i == _defaultGuideImgArr.count - 1) {
            view.userInteractionEnabled = YES;
            //  点击事件
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressEnterButton:)];
            [view addGestureRecognizer:tap];
        }
    }
}

#pragma mark - 点击事件
- (void)pressEnterButton:(UITapGestureRecognizer *)enterButton
{
    [self hideGuidePage];
    
    UserInfoUtil->setUserInfoWithBool(UserInfoBoolTypeFirstLaunched, YES);
#pragma mark - v3.2.1 取消4页灰色引导页， 注释下一行代码
    //  引导页
//    [self initGuidePageImageView];
}

#pragma mark - 首页新手指引
/**
 *  初始化引导页
 */
-(void)initGuidePageImageView
{
    curPageIdx = 0;
    
    //  如果是第一次进入就展示引导页
    _enteredGuidePageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:_enteredGuidePageImageView];
    
    _enteredGuidePageImageView.image = [UIImage imageNamed:_enteredGuideImgArr[curPageIdx]];
    _enteredGuidePageImageView.userInteractionEnabled = YES;
    [_enteredGuidePageImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGuidePageImageView)]];
    
    //  引导页添加跳过按钮
    UIButton *cancelGuideBtn = [UIButton btnWithTitle:@"跳过" rect:CGRectMake(MAIN_SCREEN_WIDTH - 80, 0, 80, 80) taget:self action:@selector(removeGuideImgView)];
    cancelGuideBtn.backgroundColor = [UIColor clearColor];
    [cancelGuideBtn setTitleColor:COMMON_WHITE_COLOR forState:UIControlStateNormal];
    [cancelGuideBtn setTitleColor:COMMON_CHARACTER_TOUCHDOWN_COLOR forState:UIControlStateHighlighted];
    [_enteredGuidePageImageView addSubview:cancelGuideBtn];
}

/**
 *  点击引导
 */
-(void)clickGuidePageImageView
{
    curPageIdx++;
    if (curPageIdx == [_enteredGuideImgArr count]) {
        [_enteredGuidePageImageView removeFromSuperview];
        return;
    }
    _enteredGuidePageImageView.image = [UIImage imageNamed:_enteredGuideImgArr[curPageIdx]];
    
}

/**
 *  跳过引导页
 */
- (void)removeGuideImgView
{
    [_enteredGuidePageImageView removeFromSuperview];
}

#pragma mark - 显示 - 隐藏引导页
- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)]) {
        return [app.delegate window];
    } else {
        return [app keyWindow];
    }
}

+ (void)show
{
    [[GuidePageViewController sharedInstance].pageScrollView setContentOffset:CGPointMake(0.f, 0.f)];
    [[GuidePageViewController sharedInstance] showGuidePage];
}

+ (void)hide
{
    [[GuidePageViewController sharedInstance] hideGuidePage];
}

- (void)showGuidePage
{
    if (!_animating && self.view.superview == nil)
    {
        [GuidePageViewController sharedInstance].view.frame = [UIScreen mainScreen].bounds;
        [[[UIApplication sharedApplication].delegate window] addSubview:[GuidePageViewController sharedInstance].view];
        
        _animating = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(guideShown)];
        [GuidePageViewController sharedInstance].view.frame = [UIScreen mainScreen].bounds;
        [UIView commitAnimations];
    }
}

- (void)guideShown
{
    _animating = NO;
}

- (void)hideGuidePage
{
    if (!_animating && self.view.superview != nil)
    {
        _animating = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(guideHidden)];
        [GuidePageViewController sharedInstance].view.frame = [UIScreen mainScreen].bounds;
        [UIView commitAnimations];
    }
}

- (void)guideHidden
{
    _animating = NO;
    [[[GuidePageViewController sharedInstance] view] removeFromSuperview];
}

#pragma mark - 单例
+ (GuidePageViewController *)sharedInstance
{
    // 1.定义一个静态变量来保存你类的实例确保在你的类里面保持全局
    static GuidePageViewController *_sharedInstance = nil;
    
    // 2.定义一个静态的dispatch_once_t变量来确保这个初始化存在一次
    static dispatch_once_t oncePredicate;
    
    // 3.用GCD来执行block初始化实例
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[GuidePageViewController alloc] init];
        //  图片
        _sharedInstance->_serverGuideImgArr = [NSMutableArray array];
        _sharedInstance->_defaultGuideImgArr = [NSArray array];
        _sharedInstance->_enteredGuideImgArr = [NSArray array];
    });
    
    return _sharedInstance;
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
