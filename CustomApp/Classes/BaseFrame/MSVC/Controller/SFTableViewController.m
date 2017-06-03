//
//  SFTableViewController.m
//  HX_GJS
//
//  Created by gjfax on 16/5/24.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SFTableViewController.h"

@interface SFTableViewController ()

@end

@implementation SFTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 *  执行网络请求， [self.requestService startRequest]
 */
- (void)defaultLoad
{
    [self.requestService startRequest];
}

/**
 *  网络加载数据错误 调用该方法.是指后台返回数据为fail
 *  默认不执行任何事件
 */
- (void)loadError:(SFRequestError *)requestError
{
    
}

/**
 *  网络加载成功 调用该方法。 指返回数据状态为succeed
 *  请求成功  执行reloadData
 */
- (void)loadSuccess
{
    if (_tableView) {
        [self.tableView reloadData];
    }
}

/**
 *  请求网络异常失败，不是后台返回失败。请区别
 */
- (void)loadFail
{
    //不作处理
}



#pragma mark - 

/**
 *  tableViewStyle  默认UITableViewStylePlain
 */
- (UITableViewStyle)tableViewStyle
{
    return UITableViewStylePlain;
}

/**
 *  请求加载的 类
 *  默认 nil
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
    return nil;
}

#pragma mark - Getter && Setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navTopView.height, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - self.navTopView.height)
                                                  style:[self tableViewStyle]];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (SFRequestService *)requestService
{
    Class modelClass = [self requestServiceClass];
    if (!_requestService && modelClass) {
        _requestService = [modelClass new];
        __weak typeof(self) weakSelf = self;
        [_requestService setSucceededBlock:^(id returnValue) {
            //  数据应该已在返回前 处理完毕， 详见constructSuccessData: errorBlock:
            //  到了这里已经是回到了主线程中，开始要做 reloadData等行为了。在此尽量不做数据处理
            [weakSelf loadSuccess];
        
        }];
        [_requestService setErrorBlock:^(SFRequestError *SFError) {
            
            [weakSelf loadError:SFError];
        }];
        
        // 网络异常， 需要返回么？有需要执行的行为么？
        [_requestService setFailureBlock:^{
            
            [weakSelf loadFail];
        }];
    }
    return _requestService;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
