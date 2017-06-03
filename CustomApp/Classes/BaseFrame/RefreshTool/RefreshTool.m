//
//  RefreshTool.m
//  GjFax
//
//  Created by litao on 15/9/7.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import "RefreshTool.h"
#import "HttpTool.h"

#import "MJRefresh.h"

@implementation RefreshTool
/**
 *  返回一个头部下拉刷新
 *
 *  @param target
 *  @param headerRefreshingBlock
 */
+ (id)initHeaderRefresh:(RefreshToolRefreshingBlock)headerRefreshingBlock
{
    //  初始化
    MJRefreshNormalHeader *headerRefresh = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //  执行刷新回调block
        headerRefreshingBlock();
    }];
    
    //  隐藏时间
    headerRefresh.lastUpdatedTimeLabel.hidden = YES;
    // 设置文字
    [headerRefresh setTitle:@"下拉刷新数据.." forState:MJRefreshStateIdle];
    [headerRefresh setTitle:@"释放刷新数据.." forState:MJRefreshStatePulling];
    [headerRefresh setTitle:@"刷新中.." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    headerRefresh.stateLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    headerRefresh.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    
    // 设置颜色
    headerRefresh.stateLabel.textColor = COMMON_GREY_COLOR;
    headerRefresh.lastUpdatedTimeLabel.textColor = COMMON_GREY_COLOR;
    
    return headerRefresh;
}

/**
 *  返回一个底部下拉刷新
 *
 *  @param target
 *  @param footerRefreshingBlock
 */
+ (id)initFooterRefresh:(RefreshToolRefreshingBlock)footerRefreshingBlock
{
    //  初始化
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //  执行加载回调block
        footerRefreshingBlock();
    }];
    
    //  设置文字
    [footerRefresh setTitle:@"上拉加载更多.." forState:MJRefreshStateIdle];
    [footerRefresh setTitle:@"正在加载.." forState:MJRefreshStateRefreshing];
    [footerRefresh setTitle:@"没有更多.." forState:MJRefreshStateNoMoreData];
    
    //  设置字体
    footerRefresh.stateLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    
    //  设置颜色
    footerRefresh.stateLabel.textColor = COMMON_GREY_COLOR;
    
    return footerRefresh;
}
@end
