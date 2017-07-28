//
//  MorePageViewController.m
//  HX_GJS
//
//  Created by litao on 16/1/25.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "MorePageViewController.h"

#import "PreCommonHeader.h"
#import "AddMenuViewController.h"
#import "SearchMenuViewController.h"
#import "NotificationViewController.h"

@interface MorePageViewController () <UITableViewDataSource, UITableViewDelegate>{
    //
}

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *imgArray;

@end

@implementation MorePageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = COMMON_BLUE_GREEN_COLOR;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
 
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configData];
    [self initBaseView];
    [self.navTopView hideBack];
    self.title  = @"我的地盘";
}

- (void)configData
{
    _dataArray = @[@[@"添加菜名", @"查询菜单",@"通知设置"]];
    _imgArray = @[@[@"more_actCenter", @"more_companyInfo", @"more_newsCenter"], @[@"more_helpCenter", @"more_feedback"], @[@"more_recommend", @"more_aboutUs", @"more_score"]];
}

- (void)initBaseView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navTopView.height, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT - self.navTopView.height - TabbarHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COMMON_GREY_WHITE_COLOR;
   
    [self.view addSubview:_tableView];
}


#pragma mark - more模块tabbar小红点

- (void)checkMoreRedNewPoint {
    
    if ([[BadgeTool sharedInstance] getIsShowBadgeWithType:isShowMoreTabbarType]) {
        [CommonMethod showTabbarRedPoint:MORE_INDEX];
    } else {
        [CommonMethod hiddenTabbarRedPoint:MORE_INDEX];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isRetina || iPhone5) {
        return kTableViewCellHeightNormal * .8f;
    }
    
    return kTableViewCellHeightNormal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _dataArray.count - 1) {
        return 0.001f;
    }
    
    return kTableViewFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, kTableViewFooterHeight)];
    footerView.backgroundColor = COMMON_GREY_WHITE_COLOR;
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MorePageCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.textLabel.textColor = COMMON_BLACK_COLOR;
    cell.textLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    
    cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:_imgArray[indexPath.section][indexPath.row]];
    
    CGFloat redPointwidth = 9;
    CGFloat redPointx = 116;
    CGFloat redPointy = 12;
    if (iPhone6Plus) {
        redPointx = 120;
    }
    if (iPhone5||!FourInch) {
        redPointy =  7;
    }
    if (indexPath.section==0) {
        if (indexPath.row ==0) {
#pragma mark - 活动中心小红点
            _redPointLabel0 = [BadgeTool redPointLabel:CGRectMake(redPointx,redPointy, redPointwidth, redPointwidth)];
            [cell.contentView addSubview:_redPointLabel0];
            // 是否显示小红点x
            _redPointLabel0.hidden = ![[BadgeTool sharedInstance] getIsShowBadgeWithType:isShowActCenterType];
        }else if (indexPath.row == 1){
#pragma mark - 新闻动态小红点
            _redPointLabel1 = [BadgeTool redPointLabel:CGRectMake(redPointx,redPointy, redPointwidth, redPointwidth)];
            [cell.contentView addSubview:_redPointLabel1];
            //  是否显示小红点
            _redPointLabel1.hidden = ![[BadgeTool sharedInstance] getIsShowBadgeWithType:isShowNewInfomationType];
        }else if (indexPath.row == 2){
#pragma mark - 系统公告小红点
            _redPointLabel2 = [BadgeTool redPointLabel:CGRectMake(redPointx,redPointy, redPointwidth, redPointwidth)];
            [cell.contentView addSubview:_redPointLabel2];
            //  是否显示小红点
            _redPointLabel2.hidden = ![[BadgeTool sharedInstance] getIsShowBadgeWithType:isShowNewsCenterType];
        }
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        cell.detailTextLabel.textColor = COMMON_GREY_COLOR;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kCommonFontSizeTitle_18];
        cell.detailTextLabel.text = FMT_STR(@"V%@",[CommonMethod appVersion]);
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectCellData:indexPath];
}

#pragma mark - tableCell 选中跳转

- (void)selectCellData:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        AddMenuViewController *vc = [[AddMenuViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1){
        SearchMenuViewController *vc = [SearchMenuViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NotificationViewController *vc = [[NotificationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
