//
//  SFTableViewController.h
//  HX_GJS
//
//  Created by gjfax on 16/5/24.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRequestService.h"

@interface SFTableViewController : CustomBaseViewController

/**
 *  默认不加载此tableView，调用时即addsubView
 */
@property (nonatomic, strong) UITableView               *tableView;

/**
 *  请求对象，具体为哪个请求类需重写requestServiceClass
 */
@property (nonatomic, strong) SFRequestService          *requestService;


#pragma mark - load Methods

/**
 *  执行网络请求， [self.requestService startRequest]
 */
- (void)defaultLoad;

/**
 *  设置 tableViewStyle 
 *  默认UITableViewStylePlain
 */
- (UITableViewStyle)tableViewStyle;

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
 *  网络加载数据错误 调用该方法.是指后台返回数据为fail
 *  默认不执行任何事件
 */
- (void)loadError:(SFRequestError *)requestError;

/**
 *  网络加载成功 调用该方法。 指返回数据状态为succeed
 *  请求成功  执行reloadData
 */
- (void)loadSuccess;

/**
 *  请求网络异常失败，不是后台返回失败。请区别
 */
- (void)loadFail;

@end
