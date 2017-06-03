//
//  RefreshTool.h
//  GjFax
//
//  Created by litao on 15/9/7.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  refresh工具类 负责整个项目的上下拉刷新显示 与第三方弱依赖(暂时简单基于MJRefresh)
 */

/** 进入刷新状态的回调 */
typedef void (^RefreshToolRefreshingBlock)();

@interface RefreshTool : NSObject
/**
 *  返回一个头部下拉刷新
 *
 *  @param target
 *  @param headerRefreshingBlock
 */
+ (id)initHeaderRefresh:(RefreshToolRefreshingBlock)headerRefreshingBlock;

/**
 *  返回一个底部下拉刷新
 *
 *  @param target
 *  @param footerRefreshingBlock
 */
+ (id)initFooterRefresh:(RefreshToolRefreshingBlock)footerRefreshingBlock;
@end
