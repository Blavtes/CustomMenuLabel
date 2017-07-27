//
//  NotificationViewController.h
//  CustomMenuLabel
//
//  Created by Blavtes on 2017/7/27.
//  Copyright © 2017年 Blavtes. All rights reserved.
//

#import "CustomBaseViewController.h"

@interface NotificationViewController : CustomBaseViewController


// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime;
+ (void)cancelLocalNotificationWithKey:(NSString *)key;


@end
