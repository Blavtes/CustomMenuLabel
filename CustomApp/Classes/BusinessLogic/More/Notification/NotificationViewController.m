//
//  NotificationViewController.m
//  CustomMenuLabel
//
//  Created by Blavtes on 2017/7/27.
//  Copyright © 2017年 Blavtes. All rights reserved.
//

#import "NotificationViewController.h"
#import "RMTBdReportBufferManager.h"
#import "NotificationRecordListViewController.h"

@interface NotificationViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    _datePicker.timeZone =  [NSTimeZone systemTimeZone];
    _datePicker.date = [NSDate dateWithTimeIntervalSinceNow:0];
    _datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0];
    __weak typeof(self) weakSelf = self;
    [self.navTopView showRightTitle:@"记录" rightHandle:^(UIButton *view) {
        NotificationRecordListViewController *vc = [NotificationRecordListViewController new];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)addClick:(id)sender {
    if (self.textView.text.length <= 0) {
        Show_iToast(@"蠢货，你加了内容了吗~")
        return;
    }
    NSString *content = self.textView.text;
    NSString *key = [content MD5Sum];
    RMTBdReportBufferManager *manage = [[RMTBdReportBufferManager alloc] init];
    [manage insertNotificaitonIntoTableForConstent:content
                                               key:key
                                            result:^(id result) {
        DLog(@"instert");
    }];
}

- (IBAction)closeNotificaiton:(id)sender {
    [NotificationViewController cancelAllNotificaiton];
}

- (IBAction)openNotification:(id)sender {
    [self queryNotificationData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)queryNotificationData
{
    __weak typeof(self) weakSelf = self;
    RMTBdReportBufferManager *manager = [[RMTBdReportBufferManager alloc] init];
    [manager queryNotificaitonConstentCallBackResult:^(NSArray *seqsArray, id result) {
        DLog(@"seq %@",seqsArray);
        if (seqsArray.count > 0) {
            NSInteger count =  [weakSelf randomData:seqsArray.count];
            DLog(@"count %ld",count);
            NSDictionary *dic = seqsArray[count];
            [weakSelf addNotificationInfo:dic];
        } else {
            Show_iToast(@"先添加消息~");
        }
        
    }];
}

- (void)addNotificationInfo:(NSDictionary *)dict
{
    
    NSDate *date1 = self.datePicker.date;
    NSDate *data2 = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval time = [date1 timeIntervalSinceDate:data2]; //date1是前一个时间(早)，date2是后一个时间(晚)
    DLog(@" time %f data2 %@ %@",time,data2,date1);
    [NotificationViewController registerLocalNotification:fabs(time) notiInfo:dict];// 4秒后
}

- (NSInteger)randomData:(NSInteger)count
{
    if (count > 1) {
        return arc4random() % count;
    }
    return 0;
}

// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime notiInfo:(NSDictionary *)dict {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    NSLog(@"fireDate=%@ %@",fireDate,dict);
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitSecond;
    
    // 通知内容
    notification.alertBody =  dict[BdNotificationConstentName];
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    notification.applicationIconBadgeNumber = badge + 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    notification.userInfo = dict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = kCFCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = kCFCalendarUnitDay;
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    // 获取所有本地通知数组
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
}

+ (void)cancelAllNotificaiton
{
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
       
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
}

+ (void)repeatNotificaiton:(NSDictionary *)dict nextTime:(CGFloat)timeCount
{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *date1 = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDate *data2 = [NSDate dateWithTimeIntervalSinceNow:timeCount];
    
    NSTimeInterval time = [data2 timeIntervalSinceDate:date1]; //date1是前一个时间(早)，date2是后一个时间(晚)
    DLog(@" time %f data2 %@ %@",time,data2,date1);
    [NotificationViewController registerLocalNotification:fabs(time) notiInfo:dict];// 4秒后
}

+ (void)haveLocalNotificationInfo:(NSDictionary *)dict
{
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
    NSString *notMess = [dict objectForKey:BdNotificationConstentName];
   
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:notMess preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 更新显示的徽章个数
        [NotificationViewController cancelLocalNotificationWithKey:dict[BdNotificationKeyName]];
        
        [NotificationViewController repeatNotificaiton:dict nextTime:2 * 60 * 60];

    }];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [NotificationViewController cancelLocalNotificationWithKey:dict[BdNotificationKeyName]];
      
        [NotificationViewController repeatNotificaiton:dict nextTime:4 * 60 * 60];
        
    }];
    [vc addAction:no];
    [vc addAction:yes];
    [GJSTopMostViewController() presentViewController:vc animated:yes completion:^{
        
    }];
}

@end
