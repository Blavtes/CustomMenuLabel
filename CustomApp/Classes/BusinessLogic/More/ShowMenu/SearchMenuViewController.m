//
//  SearchMenuViewController.m
//  CustomApp
//
//  Created by yangyong on 2017/6/3.
//  Copyright © 2017年 Blavtes. All rights reserved.
//

#import "SearchMenuViewController.h"
#import "RMTBdReportBufferManager.h"
#import "RadomViewController.h"

@interface SearchMenuViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *data1;
@property (nonatomic, strong) NSMutableArray *data2;
@property (nonatomic, strong) NSMutableArray *data3;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) NSMutableArray *arrData;
@end

@implementation SearchMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArr = @[@"荤",@"素",@"汤"];
    [self queryData];
    [self addRight];
    self.title = @"菜单";
    // Do any additional setup after loading the view from its nib.
}

- (void)queryData
{
    RMTBdReportBufferManager *maneger = [RMTBdReportBufferManager sharedInstance];
    __weak typeof(self) weakSelf = self;
    [maneger queryDBMenuFromTable:BdTableName menuNameKey:BdTableMenuName menuLabelKey:BdTableMenuLabelName menuTypeKey:BdTableTypeName result:^(NSArray *seqsArray, NSArray *infoArray, NSArray *reportTypeArray, id result) {
        DLog(@"%@ \n %@ \n %@",seqsArray,infoArray ,reportTypeArray);
        weakSelf.data = seqsArray;
        [weakSelf filterData];
        [weakSelf.tableView reloadData];
    }];
}

- (void)filterData
{
    _data1 = [NSMutableArray arrayWithCapacity:1];
    _data2 = [NSMutableArray arrayWithCapacity:1];
    _data3 = [NSMutableArray arrayWithCapacity:1];
    _arrData = [NSMutableArray arrayWithCapacity:1];
    
    for (NSDictionary *dict in _data) {
        NSString *name = dict[BdTableTypeName];
        if ([name isEqualToString:@"荤"]) {
            [_data1 addObject:dict];
        } else if ([name isEqualToString:@"素"]) {
            [_data2 addObject:dict];
        } else {
            [_data3 addObject:dict];
        }
    }
    [_arrData addObject:_data1];
    [_arrData addObject:_data2];
    [_arrData addObject:_data3];
}

- (void)addRight
{
    __weak typeof(self) weakSelf = self;
    [self.navTopView showRightTitle:@"选菜" rightHandle:^(UIButton *view) {
        RadomViewController *vc = [[RadomViewController alloc] init];
        vc.menuData = weakSelf.data;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return ((NSMutableArray *)_arrData[section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 30)];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 0, 100, 30);
    label.text = _titleArr[section];
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
    cell.textLabel.font = [UIFont systemFontOfSize:kCommonFontSizeTitle_18];
    NSDictionary *dict = _arrData[indexPath.section][indexPath.row];
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
        NSDictionary *dict = _arrData[indexPath.section][indexPath.row];
        __weak typeof(self) weakSelf = self;
        RMTBdReportBufferManager *manager = [RMTBdReportBufferManager sharedInstance];
        [manager deleteMenuFromTable:BdTableName tableKey:BdTableMenuName value:dict[BdTableMenuName] result:^(id result) {
            [weakSelf queryData];
        }];
     
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = _arrData[indexPath.section][indexPath.row];
    
    CustomAlertView *show = [[CustomAlertView alloc] initWithCompletionBlock:^(id  _Nonnull alertView) {
        [alertView dismiss];
    }];
    show.title = dict[BdTableMenuName];
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(20, 42, MAIN_SCREEN_WIDTH - 80, 80)];
    text.backgroundColor = [UIColor clearColor];
    [show.bgContentView addSubview:text];
    
    text.font = [UIFont systemFontOfSize:18];
    
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
