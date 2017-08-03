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
#import "LocalPushCenter.h"

@interface NotificationViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *closeNotiBtn;
#define LOCAL_NOTIFY_SCHEDULE_ID @"LOCAL_NOTIFY_SCHEDULE_ID"
@end

@implementation NotificationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获取当前所有的本地通知
    NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (notificaitons.count > 0) {
        _closeNotiBtn.hidden = NO;
    } else {
        _closeNotiBtn.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    _datePicker.timeZone =  [NSTimeZone systemTimeZone];
    _datePicker.date = [NSDate dateWithTimeIntervalSinceNow:0];
    _datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0];
    __weak typeof(self) weakSelf = self;
    [self.navTopView showRightTitle:@"查看" rightHandle:^(UIButton *view) {
        NotificationRecordListViewController *vc = [NotificationRecordListViewController new];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)resestClick:(id)sender {
    self.textView.text = @"";
}


- (IBAction)addClick:(id)sender {
    if (self.textView.text.length <= 0) {
        Show_iToast(@"蠢货，你加了内容了吗~")
        return;
    }
    [_textView resignFirstResponder];
    NSString *content = self.textView.text;
    NSString *key = [content MD5Sum];
    __weak typeof(self) weakSelf = self;
    RMTBdReportBufferManager *manage = [[RMTBdReportBufferManager alloc] init];
    [manage insertNotificaitonIntoTableForConstent:content
                                               key:key
                                            result:^(id result) {
        DLog(@"instert");
                                                weakSelf.textView.text = @"";
                                                [weakSelf openNotification:nil];
                                                
    }];
}

- (IBAction)closeNotificaiton:(id)sender {
    NSUserDefaults *defa =  [NSUserDefaults standardUserDefaults];
    [defa setBool:NO forKey:@"noti"];
    [defa synchronize];
    [NotificationViewController cancelAllNotificaiton];
    _closeNotiBtn.hidden = YES;
}

- (IBAction)openNotification:(id)sender {
//    [self queryNotificationData];
    NSUserDefaults *defa =  [NSUserDefaults standardUserDefaults];
    [defa setBool:YES forKey:@"noti"];
    [defa synchronize];
    [NotificationViewController setRemindTime];
    _closeNotiBtn.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (void)setRemindTime
{
    [NotificationViewController cancelAllNotificaiton];
    
    //取得系统的时间，并将其一个个赋值给变量
    NSDate* now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |kCFCalendarUnitWeek| NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
   
    
    
    //    int hour = [comps hour];
    //    int min = [comps minute];
    //    int sec = [comps second];
    
    NSArray *arr = @[@(9),@(12),@(15),@(17),@(19),@(21)];
    
    for (int newWeekDay =2; newWeekDay<=6; newWeekDay++) {
        
        for (int i = 0; i < arr.count; i++) {
            int temp = 0;
            int days = 0;
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            comps = [calendar components:unitFlags fromDate:now];
            
            temp = newWeekDay - comps.weekday;
            days = (temp >= 0 ? temp : temp + 7);
            
            [comps setHour:[arr[i] intValue]];
            [comps setMinute:0];
            [comps setSecond:0];
//             NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
            NSDate *newFireDate2 = [[[NSCalendar currentCalendar] dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
//            DLog(@"newFireDate2 %@ %@",newFireDate2,fireDate);
            [NotificationViewController scheduleNotificationWithItem:@"" fireDate:newFireDate2];
        }
    }
    
}

+ (void)scheduleNotificationWithItem:(NSString *)alertItem fireDate:(NSDate*)date
{
//    date = [NSDate dateWithTimeIntervalSinceNow:15];
    RMTBdReportBufferManager *manager = [[RMTBdReportBufferManager alloc] init];
    [manager queryNotificaitonConstentCallBackResult:^(NSArray *seqsArray, id result) {
        DLog(@"seq %@",seqsArray);
        NSInteger count = seqsArray.count;
        
        if (count > 0) {
            if ( count > 1) {
                count =  arc4random() % count;
            } else {
                count = 0;
            }
            
            DLog(@"count %ld",count);
            NSString *infoDic = seqsArray[count][BdNotificationConstentName];
            
            //初始化
            UILocalNotification *locationNotification = [[UILocalNotification alloc]init];
            
            locationNotification.fireDate = date;
            //NSLog(@"推送时间%@",locationNotification.fireDate);
            locationNotification.timeZone = [NSTimeZone defaultTimeZone];
            //设置重复周期
            locationNotification.repeatInterval = kCFCalendarUnitWeek;
            locationNotification.applicationIconBadgeNumber = 1;
            //设置通知的音乐
            locationNotification.soundName = UILocalNotificationDefaultSoundName;
            //设置通知内容
            locationNotification.alertBody = infoDic;
            DLog(@"infoDic %@",infoDic);
            locationNotification.userInfo = [NSDictionary dictionaryWithObject:infoDic forKey:BdNotificationConstentName];
            //执行本地推送
            // ios8后，需要添加这个注册，才能得到授权
            if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
                UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                locationNotification.repeatInterval = kCFCalendarUnitDay;
            } else {
                // 通知重复提示的单位，可以是天、周、月
                locationNotification.repeatInterval = kCFCalendarUnitDay;
            }
            
#warning 注册完之后如果不删除，下次会继续存在，即使从模拟器卸载掉也会保留
            
            //删除之前的通知

            
            [[UIApplication sharedApplication] scheduleLocalNotification:locationNotification];
        } else {
            Show_iToast(@"先添加消息~");
        }
        
    }];
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

-(void)cancelNotification
{
    //取消通知
    
    //获取当前所有的本地通知
    NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (!notificaitons || notificaitons.count <= 0)
    {
        return;
    }
    //取消一个特定的通知
    for (UILocalNotification *notify in notificaitons)
    {
        
        if ([[notify.userInfo objectForKey:@"id"] isEqualToString:LOCAL_NOTIFY_SCHEDULE_ID])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notify];
            
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
        
        
        RMTBdReportBufferManager *manager = [[RMTBdReportBufferManager alloc] init];
        [manager queryNotificaitonConstentCallBackResult:^(NSArray *seqsArray, id result) {
            DLog(@"haveLocalNotificationInfo %@",seqsArray);
            NSInteger count = seqsArray.count;

            if (count > 0) {
                if ( count > 1) {
                    count =  arc4random() % count;
                } else {
                    count = 0;
                }
                
                DLog(@"count %ld",count);
                NSDictionary *dic = seqsArray[count];
                [NotificationViewController repeatNotificaiton:dic nextTime:2 * 60 * 60];
                
            } else {
                Show_iToast(@"先添加消息~");
            }
            
        }];
        

    }];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [NotificationViewController cancelLocalNotificationWithKey:dict[BdNotificationKeyName]];
        
        RMTBdReportBufferManager *manager = [[RMTBdReportBufferManager alloc] init];
        [manager queryNotificaitonConstentCallBackResult:^(NSArray *seqsArray, id result) {
            DLog(@"haveLocalNotificationInfo %@",seqsArray);
            NSInteger count = seqsArray.count;
            
            if (count > 0) {
                if ( count > 1) {
                    count =  arc4random() % count;
                } else {
                    count = 0;
                }
                
                DLog(@"count %ld",count);
                NSDictionary *dic = seqsArray[count];
                [NotificationViewController repeatNotificaiton:dic nextTime:4 * 60 * 60];

            } else {
                Show_iToast(@"先添加消息~");
            }
            
        }];
        
    }];
    [vc addAction:no];
    [vc addAction:yes];
    [GJSTopMostViewController() presentViewController:vc animated:yes completion:^{
        
    }];
}

@end
