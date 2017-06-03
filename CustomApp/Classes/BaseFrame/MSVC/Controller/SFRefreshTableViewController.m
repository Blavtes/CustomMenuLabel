//
//  SFRefreshTableViewController.m
//  HX_GJS
//
//  Created by gjfax on 16/5/23.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SFRefreshTableViewController.h"
#import "SFTableViewCellModel.h"
#import "SFTableViewCell.h"
#import "UIScrollView+MJRefresh.h"
#import <QuartzCore/QuartzCore.h>

@interface SFRefreshTableViewController ()

@end

@implementation SFRefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
}

#pragma mark - load Methods

/**
 *  执行网络请求， [self.listService startRequest]
 */
- (void)defaultLoad
{
    self.listService.dataRequestType = RequestDataTypeDefault;
    [self.listService startRequest];
}

/**
 *  上拉
 */
- (void)dragUp
{
    self.listService.dataRequestType = RequestDataTypeLoadMore;
    [self.listService startRequest];
}

/**
 *  下拉
 */
- (void)dragDown
{
    self.listService.dataRequestType = RequestDataTypeRefresh;
    [self.listService startRequest];
}

/**
 *  停止刷新
 */
- (void)endRefreshing
{
//    [self.tableView.mj_header endRefreshing];
//    [self.tableView.mj_footer endRefreshing];
}

/**
 *  网络加载数据错误 调用该方法.是指后台返回数据为fail
 *
 *  默认执行 1.是否需要显示 无数据页面 （依据self.listService.resultListArray.count）
 *          2.停止刷新
 *          3.[self.tableView reloadData]
 */
- (void)loadError:(SFRequestError *)requestError
{
    //  不处理其他错误？仅处理了 0082
//    [HttpTool handleErrorCodeFromServer:@(requestError.errorCode) withNote:@""];
    
    [self isShowTipView];
    [self endRefreshing];
    [self.tableView reloadData];
}

/**
 *  网络加载成功 调用该方法。 指返回数据状态为succeed
 *
 *  默认执行 1.是否需要显示 无数据页面 （依据self.listService.resultListArray.count）
 *          2.停止刷新
 *          3.[self.tableView reloadData]
 */
- (void)loadSuccess
{
    [self isShowTipView];
    [self endRefreshing];
    [self.tableView reloadData];
}

/**
 *  请求网络异常失败，不是后台返回失败。请区别
 *
 *  默认执行 1.是否需要显示 无数据页面 （依据self.listService.resultListArray.count）
 *          2.停止刷新
 *          3.[self.tableView reloadData]
 */
- (void)loadFail
{
    [self isShowTipView];
    [self endRefreshing];
    [self.tableView reloadData];
}

/**
 *  设置 子类需要的 请求requestService class
 *  return class 。默认 nil
 */
- (Class)requestServiceClass
{
    return nil;
}

/**
 *  默认 SFTableViewCell
 */
- (Class)tableViewCellClass
{
    return [SFTableViewCell class];
}

/**
 *  设置 无数据页面 显示type
 *  return CustomerTipType 。默认 NoDataType 没有数据
 */
- (CustomerTipType)showTipViewDataType
{
    return NoDataType;
}

/**
 *  tableViewCell是否是 XIB初始化
 *  默认 NO
 */
- (BOOL)isXib
{
    return NO;
}

/**
 *  是否开启 上、下拉刷新功能
 *  默认 YES 开启
 */
- (BOOL)isOpenDrag
{
    return YES;
}

/**
 *  是否开启 无数据页面 功能
 *  默认 YES 开启
 */
- (BOOL)isOpenShowTipsView
{
    return YES;
}

#pragma mark - error View
/**
 *  是否显示错误页面
 **/
- (void)isShowTipView
{
    if ([self isOpenShowTipsView]) {
        
        if (self.listService.resultListArray.count > 0) {
            [self removeTipView];
        } else {
            [self showTipView];
        }
    }
    
}

/**
 *  显示提示页面
 */
- (void)showTipView
{ 
    [NoDataOrNetworkView showTipView:[self showTipViewDataType] view:self.view touchTipBlock:^{
        //V3.6不支持任何形式刷新,只展示图片
    }];
}

/**
 *  移除提示页面
 */
- (void)removeTipView
{
    [NoDataOrNetworkView hideTipView:self.view];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.listService.resultListArray GJSObjectIndexSafe:indexPath.row] cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listService.resultListArray count];
}

//每一行的界面
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indetify = @"SFTableViewCell";
    //使用自定义的cell
    id cell = [tableView dequeueReusableCellWithIdentifier:indetify];
    if (!cell) {
        if ([self isXib]) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self tableViewCellClass])
                                                  owner:self options:nil] lastObject];
            
        }else {
            cell = [[[self tableViewCellClass] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetify];
            
        }
    }
    ((SFTableViewCell *)cell).indexPath = indexPath;
    ((SFTableViewCell *)cell).cellModel = [self.listService.resultListArray GJSObjectIndexSafe:indexPath.row];
    
    return cell;
}


#pragma mark - Getter && Setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navTopView.height, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - self.navTopView.height)
                                                  style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if ([self isOpenDrag]) {
            _tableView.mj_header = [RefreshTool initHeaderRefresh:^{
                //  下拉刷新
                [self dragDown];
            }];
            _tableView.mj_footer = [RefreshTool initFooterRefresh:^{
                //  上拉刷新
                [self dragUp];
            }];
        }
        
    }
    return _tableView;
}

- (SFRequestListService *)listService
{
    Class modelClass = [self requestServiceClass];
    if (!_listService && modelClass) {
        _listService = [modelClass new];
        __weak typeof(self) weakSelf = self;
        [_listService setSucceededBlock:^(id returnValue) {
            //  到了这里已经是回到了主线程中，开始要做 reloadData等行为了。在此尽量不做数据处理
            [weakSelf loadSuccess];
        }];
        [_listService setFailureBlock:^{
            
            [weakSelf loadFail];
            
        }];
        [_listService setErrorBlock:^(SFRequestError *SFError) {

            [weakSelf loadError:SFError];
            
        }];
    }
    return _listService;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
