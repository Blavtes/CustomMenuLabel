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

@end

@implementation SearchMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        [weakSelf.tableView reloadData];
    }];
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
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
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
    cell.textLabel.font = [UIFont systemFontOfSize:kCommonFontSizeDetail_16];
    NSDictionary *dict = _data[indexPath.row];
    cell.textLabel.text = dict[BdTableMenuName];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 删除操作
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dict = [_data objectAtIndex:indexPath.row];
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
    
    NSDictionary *dict = [_data objectAtIndex:indexPath.row];
    
    CustomAlertView *show = [[CustomAlertView alloc] initWithCompletionBlock:^(id  _Nonnull alertView) {
        [alertView dismiss];
    }];
    show.title = dict[BdTableMenuName];
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(20, 42, MAIN_SCREEN_WIDTH - 80, 80)];
    text.backgroundColor = [UIColor clearColor];
    [show.bgContentView addSubview:text];
    
    
    
    NSString *str = dict[BdTableTypeName];
    show.confirmBtnTitle = str;
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
