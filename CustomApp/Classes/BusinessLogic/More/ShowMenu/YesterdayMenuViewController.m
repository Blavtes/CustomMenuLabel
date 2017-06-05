//
//  YesterdayMenuViewController.m
//  CustomApp
//
//  Created by yangyong on 2017/6/3.
//  Copyright © 2017年 Blavtes. All rights reserved.
//

#import "YesterdayMenuViewController.h"
#import "RMTBdReportBufferManager.h"

@interface YesterdayMenuViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *timeArr;
@property (nonatomic, strong) NSMutableArray *dictArr;
@property (nonatomic, assign) NSInteger fontValue;
@end

@implementation YesterdayMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = @"昨天吃了啥";
    _timeArr = [NSMutableArray arrayWithCapacity:1];
    self.dictArr = [NSMutableArray arrayWithCapacity:1];
    _fontValue = 14;
    [self queryData];
    [self fontMore];
    //[self.navTopView showRightTitle:@"字体+" rightHandle:^(UIButton *view) {
        
    //}];
    // Do any additional setup after loading the view from its nib.
}

- (void)fontMore
{
    UIStepper *stp = [[UIStepper alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH - 110, 25, 80, 30)];
    stp.minimumValue = 14;
    stp.maximumValue = 40;
    stp.stepValue = 1;
    stp.tintColor = [UIColor whiteColor];
    [stp addTarget:self action:@selector(stepperAction:) forControlEvents:UIControlEventValueChanged];
    [self.navTopView addSubview:stp];
}

- (void)stepperAction:(UIStepper *)stp
{
    DLog(@"stp %@",stp);
    _fontValue = stp.value;
    [_tableView reloadData];
}

- (void)queryData
{
    RMTBdReportBufferManager *maneger = [RMTBdReportBufferManager sharedInstance];
    __weak typeof(self) weakSelf = self;
    [maneger queryOldDBMenuFromTable:BdOldTableName menuNameKey:BdTableMenuName menuLabelKey:BdTableMenuLabelName menuTypeKey:BdTableTypeName result:^(NSArray *seqsArray, NSArray *infoArray, NSArray *reportTypeArray, id result) {
        __strong typeof(weakSelf) strongSef = weakSelf;
        DLog(@"%@ \n %@ \n %@",seqsArray,infoArray ,reportTypeArray);
        strongSef.dataArr = seqsArray;
        [strongSef filterData];
        [strongSef.tableView reloadData];
    }];
}

- (void)filterData
{
    @synchronized (self) {
        [_timeArr removeAllObjects];
        [_dictArr removeAllObjects];
        
        NSMutableDictionary *timeDict = [NSMutableDictionary dictionaryWithCapacity:1];
        for (NSDictionary *dict in _dataArr) {
            NSString *time = dict[BDOleMenuTimeTable];
            [timeDict setObject:time forKey:time];
        }
        
        for (NSString *keyTime in [timeDict allKeys]) {
            NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];

            for (NSDictionary *dict in _dataArr) {
                NSString *time = dict[BDOleMenuTimeTable];
                if ([time isEqualToString:keyTime]) {
                    [data addObject:dict];
                }
            }
            [self.dictArr addObject:data];
            [_timeArr addObject:keyTime];
        }
     
        NSLog(@"dict %@",_dictArr);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  _dictArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return ((NSMutableArray *)_dictArr[section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 30)];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 0, MAIN_SCREEN_WIDTH - 40, 30);
    label.text = _timeArr[section];
    label.font = [UIFont systemFontOfSize:_fontValue - 6];
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SearchMenuCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.textLabel.textColor = COMMON_BLACK_COLOR;
    cell.textLabel.font = [UIFont systemFontOfSize:_fontValue];
    NSDictionary *dict = _dictArr[indexPath.section][indexPath.row];
    //    if (indexPath.section == 0) {
    //        dict = _data1[indexPath.row];
    //    } else if (indexPath.section == 1) {
    //        dict = _data2[indexPath.row];
    //    } else {
    //        dict = _data3[indexPath.row];
    //    }
    //
    cell.textLabel.text = dict[BdTableMenuName];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dict = _dictArr[indexPath.section][indexPath.row];
        __weak typeof(self) weakSelf = self;
        RMTBdReportBufferManager *manager = [RMTBdReportBufferManager sharedInstance];
        [manager deleteOldMenuFromTable:BdOldTableName tableKey:BdTableMenuName value:dict[BdTableMenuName] result:^(id result) {
            [weakSelf queryData];
        }];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = _dictArr[indexPath.section][indexPath.row];
    
    CustomAlertView *show = [[CustomAlertView alloc] initWithCompletionBlock:^(id  _Nonnull alertView) {
        [alertView dismiss];
    }];
    show.title = dict[BdTableMenuName];
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(20, 42, MAIN_SCREEN_WIDTH - 80, 80)];
    text.backgroundColor = [UIColor clearColor];
    [show.bgContentView addSubview:text];
    text.font = [UIFont systemFontOfSize:_fontValue];
    
    
    NSString *str = dict[BdTableTypeName];
    show.confirmBtnTitle = @"确定";
    text.text = dict[BdTableMenuLabelName];
    [show show];
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
