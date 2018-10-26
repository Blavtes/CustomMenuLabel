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
#import "LocationTool.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"
#import "NSStream+SKPSMTPExtensions.h"

@interface MorePageViewController () <UITableViewDataSource, UITableViewDelegate,SKPSMTPMessageDelegate>{
    //
}

@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UISwitch *swit;
@property (weak,nonatomic) UITextField *field;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *imgArray;
@property (strong, nonatomic) NSString *tipsTitle;
@property (nonatomic, strong) NSTimer *time;
@property (nonatomic, assign) BOOL isFecth;
@property (nonatomic, assign) int fecthCount;
@property (nonatomic, assign) int repeatTime;
@property (nonatomic,strong)SKPSMTPMessage *mail;
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
    self.repeatTime = 5.0f;
    self.tipsTitle = @"0";;
    [self configData];
    [self initBaseView];
    [self.navTopView hideBack];
    self.title  = @"我的地盘";
    
    [self.tableView endEditing:YES];
 
}

- (void)configData
{
    _dataArray = @[@[@"添加菜名", @"查询菜单",@"通知设置", @"不相交",self.tipsTitle]];
    _imgArray = @[@[@"more_actCenter", @"more_companyInfo", @"more_newsCenter" ,@"more_score",@"more_score"], @[@"more_helpCenter", @"more_feedback", @"more_recommend", @"more_recommend"], @[@"more_recommend", @"more_aboutUs", @"more_score", @"more_companyInfo",@"more_companyInfo"]];
}

- (void)input:(UITextField*)field
{
    self.repeatTime = [field.text intValue] > 5 ? [field.text intValue] : 5;
    [self switchChange:_swit];
}

- (void)switchChange:(UISwitch *)se
{
    [self.field resignFirstResponder];
//    [self sendTenEmailTo:@"" verifyCode:@"test"];
//    return;
    DLog(@"UISwitch %d",se.isOn);
    if (se.isOn) {
        _isFecth = YES;
        if (_time) {
            [_time invalidate];
            _time = nil;
        }
        self.fecthCount = 0;
        [LocationTool setLocationServicesEnabled:YES];
        NSTimer *time = [NSTimer scheduledTimerWithTimeInterval:self.repeatTime repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self fetchProductData];
            self.fecthCount++;
        }];
        _time = time;
        
    } else {
        if (_time) {
            [_time invalidate];
            _time = nil;
        }
        self.fecthCount = 0;
        [LocationTool setLocationServicesEnabled:NO];
        _isFecth = NO;
    }
//    [self.tableView reloadData];
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
        self.tipsTitle = FMT_STR(@"数量 %d 剩余 %.2f 统计次数 %d",a,sum,self.fecthCount);
//        Show_iToast( self.tipsTitle);
        if (sum > 0) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1];
            [dict setObject:@"aaa" forKey:BdReportPrimaryKey];
            [dict setObject: self.tipsTitle forKey:BdNotificationConstentName];
            [dict setObject:@"消息" forKey:BdNotificationKeyName];
            
            [NotificationViewController registerLocalNotification:4 notiInfo:dict];
        }
        [self configData];
        [self.tableView reloadData];
    } else {
        
    }
}

- (void)sendTenEmailTo:(NSString *)toEmail verifyCode:(NSString *)verifyCode
{
    SKPSMTPMessage *mail = [[SKPSMTPMessage alloc] init];
    mail.fromEmail = @"574949555@qq.com"; //发送邮箱
    mail.toEmail = @"574949555@qq.com"; //收件邮箱
//    myMessage.bccEmail = @"1290925941@qq.com";//抄送
    
    mail.relayHost = @"smtp.exmail.qq.com";//发送地址host 腾讯企业邮箱:smtp.exmail.qq.com
    mail.requiresAuth = YES;
    mail.login = @"574949555@qq.com";//发送邮箱的用户名
    mail.pass = @"nrgkdqeoippvbdef";//发送邮箱的密码
    
    mail.wantsSecure = YES;
    mail.subject = @"test";//邮件主题
    mail.delegate = self;
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,[NSString stringWithFormat:@"%@",verifyCode],kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey, nil];
    mail.parts = @[param];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        [mail send];

        [[NSRunLoop currentRunLoop] run];//这里开启一下runloop要不然重试其他端口的操作不会进行

    });
}

- (void)messageSent:(SKPSMTPMessage *)message

{
    NSLog(@"%@", message);
}

- (void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error

{
    NSLog(@"message - %@\nerror - %@", message, error);//因为存在发送失败的情况，所以这里可用再次调用 sendEMail方法 我的测试情况是 一般3次就可以成功了
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
        } else if (indexPath.row == 4) {
            UISwitch *swit = [[UISwitch alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 60, 10, 100, kTableViewCellHeightNormal)];
            [swit setOn:self.isFecth];
            [swit addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:swit];
            UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 120, 10, 40, 30)];
            field.keyboardType = UIKeyboardTypeDecimalPad;
            field.backgroundColor = COMMON_GREY_COLOR;
            [cell.contentView addSubview:field];
            field.text = FMT_STR(@"%d",self.repeatTime);
            [field addTarget:self action:@selector(input:) forControlEvents:UIControlEventEditingDidEnd];
            self.swit = swit;
            self.field = field;
        }
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        cell.detailTextLabel.textColor = COMMON_GREY_COLOR;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kCommonFontSizeTitle_18];
        cell.detailTextLabel.text = FMT_STR(@"V%@",[CommonMethod appVersion]);
    }
    if(indexPath.row != 4){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
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
