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
#import "GameCancellController.h"
#import "NormalProductModel.h"
#import "RMTBdReportBufferManager.h"

@interface MorePageViewController () <UITableViewDataSource, UITableViewDelegate>{
    //
}

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *imgArray;
@property (strong, nonatomic) NSString *tipsTitle;
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
      self.tipsTitle = @"0";
    [self configData];
    [self initBaseView];
    [self.navTopView hideBack];
    self.title  = @"我的地盘";
  
    NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:10 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self fetchProductData];
    }];
}

- (void)configData
{
    _dataArray = @[@[@"添加菜名", @"查询菜单",@"通知设置", @"不相交",self.tipsTitle]];
    _imgArray = @[@[@"more_actCenter", @"more_companyInfo", @"more_newsCenter" ,@"more_score",@"more_score"], @[@"more_helpCenter", @"more_feedback", @"more_recommend", @"more_recommend"], @[@"more_recommend", @"more_aboutUs", @"more_score", @"more_companyInfo",@"more_companyInfo"]];
}

- (void)fetchProductData
{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(1) forKey:@"pageNum"];
    [params setObject:@(20) forKey:@"pageSize"];
    
    [HttpTool postUrl:GJS_GJF_FinancialProductList params:params success:^(id responseObj) {
        //加载完成
        DLog(@"log responseObj %@",responseObj);
        
        [self req_callBack:responseObj];
    } failure:^(NSError *error) {
        
    }];
}

- (void)req_callBack:(id)data
{
    NSDictionary *body = [NSDictionary dictionaryWithDictionary:data];
    
    NSString *retStatusStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"status"]);
    NSString *retCodeStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"retCode"]);
    NSString *retNoteStr = FMT_STR(@"%@", [[body objectForKeyForSafetyDictionary:@"retInfo"] objectForKeyForSafetyValue:@"note"]);
    
    if ([[retStatusStr lowercaseString] isEqualToString:kInterfaceRetStatusSuccess]) {
        
        NSArray *resultArray = [[body objectForKeyForSafetyDictionary:@"result"] objectForKeyForSafetyArray:@"list"];
        int a = 0;
        float sum = 0;
        NSMutableArray *retModelArray = [NSMutableArray arrayWithArray:[NormalProductModel modelArrayWithArray:resultArray]];
        for (NormalProductModel *model in retModelArray ) {
            if ([model.productBalance integerValue] > 0) {
                a++;
                sum += [model.productBalance floatValue];
            }
        }
        self.tipsTitle = FMT_STR(@"数量 %d 剩余 %.2f",a,sum);
        Show_iToast( self.tipsTitle);
//        if (sum > 0) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
            [dict setObject:@"aaa" forKey:BdReportPrimaryKey];
            [dict setObject: self.tipsTitle forKey:BdNotificationConstentName];
            [dict setObject:@"消息" forKey:BdNotificationKeyName];
            
            [NotificationViewController registerLocalNotification:4 notiInfo:dict];
//        }
        [self configData];
        [self.tableView reloadData];
    } else {
        
    }
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
    } else if (indexPath.row == 2){
        NotificationViewController *vc = [[NotificationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 3){
        GameCancellController *vc = [GameCancellController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
