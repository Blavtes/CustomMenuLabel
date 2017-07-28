//
//  NotificationRecordListViewController.m
//  CustomMenuLabel
//
//  Created by Blavtes on 2017/7/28.
//  Copyright © 2017年 Blavtes. All rights reserved.
//

#import "NotificationRecordListViewController.h"
#import "RMTBdReportBufferManager.h"

@interface NotificationRecordListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *notificationArr;
@property (nonatomic, strong) NSMutableArray *notificationListArr;

@end

@implementation NotificationRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记录";
    self.view.backgroundColor = COMMON_GREY_COLOR;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:@"1" forKey:BdReportPrimaryKey];
    [dict setObject:@"无" forKey:BdNotificationConstentName];
    [dict setObject:@"无" forKey:BdNotificationKeyName];
    
    NSArray *arr = @[dict];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _notificationArr = [NSMutableArray arrayWithCapacity:1];
    [_notificationArr addObjectsFromArray:arr];
    _notificationListArr = [NSMutableArray arrayWithCapacity:1];
    [_notificationListArr addObjectsFromArray:arr];
    // Do any additional setup after loading the view from its nib.
    [self queryNotificaitonInfo];
    
    [self getAllNotificaiton];
}

- (void)queryNotificaitonInfo
{
    __weak typeof(self) weakSelf = self;
    RMTBdReportBufferManager * manage = [RMTBdReportBufferManager sharedInstance];
    [manage queryNotificaitonConstentCallBackResult:^(NSArray *seqsArray, id result) {
       
        if (seqsArray.count > 0) {
            [weakSelf.notificationArr removeAllObjects];
            [weakSelf.notificationArr addObjectsFromArray:seqsArray];
            _dataArray = @[_notificationArr,_notificationListArr];
        }
       

        [weakSelf.tableView reloadData];
    }];
}

- (void)getAllNotificaiton
{
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    if (localNotifications.count > 0) {
          [_notificationListArr removeAllObjects];
    }
  
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *dict = @{@"user":notification.userInfo,@"time":notification.fireDate};
        [_notificationListArr addObject:dict];
    }
    _dataArray = @[_notificationArr,_notificationListArr];
    [_tableView reloadData];
}

- (void)cancellNotification:(NSString *)key
{
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
   
    
    for (UILocalNotification *notification in localNotifications) {
        
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *infoKey = userInfo[BdNotificationKeyName];
            
            // 如果找到需要取消的通知，则取消
            if ([infoKey isEqualToString:key]) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
    [self getAllNotificaiton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = ((NSArray*)(_dataArray[section])).count;
    DLog(@"count %ld",count);
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 30)];
    view.backgroundColor = COMMON_GREY_WHITE_COLOR;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
    label.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        label.text = @"消息记录";
    } else {
        label.text = @"通知记录";
    }
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Notification";
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.textLabel.textColor = COMMON_BLACK_COLOR;
    cell.textLabel.font = [UIFont systemFontOfSize:kCommonFontSizeSubSubDesc_12];
    cell.textLabel.font = [UIFont systemFontOfSize:kCommonFontSizeTitle_18];
    NSDictionary *dict = _dataArray[indexPath.section][indexPath.row];
   
    DLog(@"cell....");
  
    if (indexPath.section == 1) {
          cell.textLabel.text = dict[@"user"][BdNotificationConstentName];
        if (((NSArray*)_dataArray[indexPath.section]).count > 1) {
            UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, MAIN_SCREEN_WIDTH - 120, 40)];
            detail.font = [UIFont systemFontOfSize:kCommonFontSizeSubSubDesc_12];
            detail.textAlignment = NSTextAlignmentRight;
            NSDate *date = dict[@"time"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //每次启动后都保存一个新的日志文件中
            NSString *dateStr = [formatter stringFromDate:date];
            detail.text = dateStr;
            [cell.contentView addSubview:detail];
        }
       
    } else {
          cell.textLabel.text = dict[BdNotificationConstentName];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dict = _dataArray[indexPath.section][indexPath.row];
        if (indexPath.section == 0) {
            __weak typeof(self) weakSelf = self;
            RMTBdReportBufferManager *manager = [RMTBdReportBufferManager sharedInstance];
            [manager deleteNotificaitonIntoFromTableKey:BdNotificationConstentName value:dict[BdNotificationConstentName] result:^(id result) {
                [weakSelf queryNotificaitonInfo];
            }];
        } else {
            [self cancellNotification:dict[@"user"][BdNotificationKeyName]];
        }
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
