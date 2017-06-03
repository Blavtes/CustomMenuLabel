//
//  SFRefreshTableViewController.h
//  HX_GJS
//
//  Created by gjfax on 16/5/23.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRequestListService.h"
#import "SFRequestError.h"

@interface SFRefreshTableViewController : CustomBaseViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView               *tableView;

/**
 *  请求对象，具体为哪个请求类需重写requestServiceClass
 */
@property (nonatomic, strong) SFRequestListService      *listService;

#pragma mark -- 按需继承,不需要的不用重写
#pragma mark - load Methods

/**
 *  执行网络请求， [self.listService startRequest]
 */
- (void)defaultLoad;

/**
 *  下拉 刷新
 */
- (void)dragDown;

/**
 *  上拉 刷新
 */
- (void)dragUp;

/**
 *  网络加载数据错误 调用该方法.是指后台返回数据为fail
 *
 *  默认执行 1.是否需要显示 无数据页面 （依据self.listService.resultListArray.count）
 *          2.停止刷新
 *          3.[self.tableView reloadData]
 */
- (void)loadError:(SFRequestError *)requestError;

/**
 *  网络加载成功 调用该方法。 指返回数据状态为succeed
 *
 *  默认执行 1.是否需要显示 无数据页面 （依据self.listService.resultListArray.count）
 *          2.停止刷新
 *          3.[self.tableView reloadData]
 */
- (void)loadSuccess;

/**
 *  请求网络异常失败，不是后台返回失败。请区别
 *
 *  默认执行 1.是否需要显示 无数据页面 （依据self.listService.resultListArray.count）
 *          2.停止刷新
 *          3.[self.tableView reloadData]
 */
- (void)loadFail;

/**
 *  设置 子类需要的 请求requestService class
 *  return class 。默认 nil
 */
- (Class)requestServiceClass;

/**
 *  设置 子类需要的tablviewCell class。
 *  return class  默认 SFTableViewCell
 */
- (Class)tableViewCellClass;


/**
 *  是否开启 无数据页面 功能
 *  默认 YES 开启
 */
- (BOOL)isOpenShowTipsView;

/**
 *  设置 无数据页面 显示type
 *  return CustomerTipType 。默认 NoDataType 没有数据
 */
- (CustomerTipType)showTipViewDataType;


#pragma mark - 鉴于项目因素，特此新增以下方法
/**
 *  tableViewCell是否是 XIB初始化
 *  默认 NO
 */
- (BOOL)isXib;

/**
 *  是否开启 上、下拉刷新功能.
 *  默认 YES 开启
 */
- (BOOL)isOpenDrag;

@end
