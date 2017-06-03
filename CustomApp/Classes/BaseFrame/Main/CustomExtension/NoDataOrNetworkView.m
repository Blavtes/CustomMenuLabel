//
//  NoDataOrNetworkView.m
//  YiYunMi
//
//  Created by litao on 15/9/8.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import "NoDataOrNetworkView.h"
@interface NoDataOrNetworkView () {
    //
}
//  显示lb
@property (nonatomic, weak) UILabel *descLb;
//  触摸回调block
@property (nonatomic, copy) TouchTipBlock touchTipBlock;
@end

@implementation NoDataOrNetworkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithTipType:NoDataType];
    
    if (self) {
        //  default setting
    }
    
    return self;
}

#pragma mark - 初始化view
/**
 *  初始化一个view - 默认填充整个屏幕
 */
- (instancetype)initWithTipType:(CustomerTipType)tipType
{
    self = [self initWithFrame:MAIN_SCREEN_BOUNDS tipType:tipType touchTipBlock:nil];
    
    return self;
}

/**
 *  初始化一个view
 */
- (instancetype)initWithFrame:(CGRect)frame tipType:(CustomerTipType)tipType
{
    self = [self initWithFrame:frame tipType:tipType touchTipBlock:nil];
    
    return self;
}

/**
 *  初始化一个view - 默认填充整个屏幕 - block
 */
- (instancetype)initWithTipType:(CustomerTipType)tipType touchTipBlock:(TouchTipBlock)touchTipBlock
{
    self = [self initWithFrame:CGRectMake(0, 64, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - 64) tipType:tipType touchTipBlock:touchTipBlock];
    
    return self;
}

/**
 *  初始化一个view - block
 */
- (instancetype)initWithFrame:(CGRect)frame tipType:(CustomerTipType)tipType touchTipBlock:(TouchTipBlock)touchTipBlock
{
    NSString *imgStr = @"";
    //  V3.11需求为统一图案展示
    if (NoNetworkType == tipType) {
        // 默认图标
        imgStr= @"common_noData_backGround";
    } else {
        // 默认图标
        imgStr = @"common_noData_backGround";
    }
    
    NSString *tipsString = [self tipStringWithTipType:tipType];
    
    //  block
    if (touchTipBlock) {
        _touchTipBlock = touchTipBlock;
    }

    self = [self initWithFrame:frame imageString:imgStr tipsString:tipsString];
    
    return self;
}

#pragma mark - 根据类型转义

- (NSString *)tipStringWithTipType:(CustomerTipType)tipType
{
    NSString *tipsString = @"";
    //  显示文案信息
    switch (tipType) {
        case NoDataType:
        {
            tipsString = @"暂无数据";
        }
            break;
            
        case NoProductType:
        {
            tipsString = @"暂无产品";
        }
            break;
            
        case NoNetworkType:
        {
            tipsString = @"暂无数据";
        }
            break;
        case NoInvestRecord:
        {
            tipsString = @"暂无投资记录";
        }
            break;
        case NoTransferProduct:
        {
            tipsString = @"暂无转让产品";
        }
            break;
        case NoSearchDataType:
        {
            tipsString = @"未搜索到相关产品，\n换个搜索词试试～";
        }
            break;
        case NoDateNoTap:
        {
            tipsString = @"暂无记录";
        }
            break;
        case NoGJSTicket:
        {
            tipsString = @"您当前暂无任何广金券";
        }
            break;
        case NoExchangeTicket:
        {
            tipsString = @"暂无可供兑换的广金券";
        }
            break;
        case  NoFixInvestType:
        {
            tipsString = @"暂时没有投资的项目哦~";
        }
            break;
        case  NoFixInvestRecondType:
        {
            tipsString = @"暂时没有投资记录哦~";
        }
            break;
        case  NoFixTransferRecordType:
        {
            tipsString = @"暂时没有转让记录哦~";
        }
            break;
        case  NoFixListRecordType:
        {
            tipsString = @"暂时没有历史收款哦~";
        }
            break;            
        case  NoCurrentInvestType:
        {
            tipsString = @"暂时没有投资的项目哦~";
        }
            break;
        case  NoCurrentListRecordType:
        {
            tipsString = @"暂时没有交易记录哦~";
        }
            break;
        case  NoFundInvestType:
        {
            tipsString = @"暂时没有投资的项目哦~";
        }
            break;
        case  NoFundRecordType:
        {
            tipsString = @"暂时没有交易记录哦~";
        }
            break;
        case  NoInsuranceHoldingType:
        {
            tipsString = @"暂时没有持有中的项目哦~";
        }
            break;
        case NoInsuranceSurrenderingType:
        {
            tipsString = @"暂时没有退保中的项目哦~";
        }
            break;
        case NoInsuranceSurrenderedType:
        {
            tipsString = @"暂时没有已退保的项目哦~";
        }
            break;
        case NoCanTransferType:
        {
            tipsString = @"暂时没有可转让的项目哦~";
        }
            break;
        case NoTransferingType:
        {
            tipsString = @"暂时没有转让中的项目哦~";
        }
            break;
        case NoTransferedType:
        {
            tipsString = @"暂时没有已转让的项目哦~";
        }
            break;
        case NoTransferRecordType:
        {
            tipsString = @"暂时没有转让记录哦~";
        }
            break;
        case NoActivityRewardType:
        {
            tipsString = @"暂时没有奖励哦~";
        }
            break;
        case NoMyGJSCoinType:
        {
            tipsString = @"暂时什么都没有哦~";
        }
            break;
        case NoRewardRecordType:
        {
            tipsString = @"暂时没有奖励记录哦~";
        }
            break;
        case NoMyRecommendType:
        {
            tipsString = @"暂时没有推荐过好友哦~";
        }
            break;
        case NoAssetRecordType:
        {
            tipsString = @"暂时没有资金记录哦~";
        }
            break;
        case NoActivityCenter:
        {
            tipsString = @"暂时什么都没有哦~";
        }
            break;            
        default:
            break;
    }

    return tipsString;
}


#pragma mark - 基类方法

- (instancetype)initWithFrame:(CGRect)frame
                  imageString:(NSString *)imageString
                   tipsString:(NSString *)tipsString
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COMMON_GREY_WHITE_COLOR;
        //  图片
        UIImage *img = [[UIImage alloc] init];
        //  网络错误单独使用图片
        img = [UIImage imageNamed:imageString];
    
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.size = img.size;
        imgView.center = CGPointMake(frame.size.width * .5f, frame.size.height * .4f);
        imgView.image = img;
        [self addSubview:imgView];
        imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshView)];
        [imgView addGestureRecognizer:tapImg];
        
        //  初始化描述
        UILabel *descLb = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.frame.origin.y + imgView.frame.size.height + 5, frame.size.width, CommonLbHeight)];
        descLb.textColor = COMMON_GREY_COLOR;
        if (iPhone5 || isRetina) {
            descLb.font = [UIFont systemFontOfSize:kCommonFontSizeSubDesc_14];
        } else {
            descLb.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
        }
        descLb.textAlignment = NSTextAlignmentCenter;
        descLb.numberOfLines = 0;
        [self addSubview:descLb];
        _descLb = descLb;
        
        //  添加触摸事件
        descLb.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshView)];
        [descLb addGestureRecognizer:tap];
        
        //  计算描述文字高度，动态设置
        descLb.text = tipsString;
        CGFloat textFont = kCommonFontSizeSubDesc_14;
        if (iPhone5 || isRetina) {
            textFont = kCommonFontSizeSubDesc_14;
        } else {
            textFont = kCommonFontSizeDetail_16;
        }
        CGFloat tipsHeight = [descLb.text getTextSize:textFont maxWidth:descLb.width].height;
        if (tipsHeight < 30) {
            tipsHeight = 30;
        }
        descLb.height = tipsHeight;
    }
    
    return self;
}


#pragma mark - 类方法
/**
 *  显示一个无数据提示页面
 */
+ (instancetype)showTipView:(CustomerTipType)tipType view:(UIView *)view touchTipBlock:(TouchTipBlock)touchTipBlock
{
    //  先移除已有
    [self hideTipView:view];
    NoDataOrNetworkView *tipView = [[NoDataOrNetworkView alloc] initWithFrame:CGRectMake(0, 64, view.width, view.height - 64) tipType:tipType];
    //  添加到目标view
    [view addSubview:tipView];
    
    //  block
    if (touchTipBlock) {
        tipView.touchTipBlock = touchTipBlock;
    }
    
    return tipView;
}

/**
 *  显示一个无数据提示页面
 */
+ (instancetype)showTipView:(CustomerTipType)tipType view:(UIView *)view viewFrame:(CGRect)frame touchTipBlock:(TouchTipBlock)touchTipBlock
{
    //  先移除已有
    [self hideTipView:view];
    NoDataOrNetworkView *tipView = [[NoDataOrNetworkView alloc] initWithFrame:frame tipType:tipType];
    //  添加到目标view
    [view addSubview:tipView];
    
    //  block
    if (touchTipBlock) {
        tipView.touchTipBlock = touchTipBlock;
    }
    
    return tipView;
}

#pragma mark - 移除父视图下所有自身视图
/**
 *  移除提示页面
 */
+ (void)hideTipView:(UIView *)view
{
    NSArray *subviews = view.subviews;
    for (NoDataOrNetworkView *tipView in subviews) {
        if ([tipView isKindOfClass:self]) {
            [tipView removeFromSuperview];
        }
    }
}

#pragma mark - 触摸手势事件
- (void)refreshView
{
    //  block回调
    if (_touchTipBlock) {
        _touchTipBlock();
    }
    //  是否移除自身
    if (_isTouchRemove) {
        DLog(@"remove self from super view when touching tipLb");
        [self removeFromSuperview];
    }
}
@end
