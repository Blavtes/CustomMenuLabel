//
//  RadomViewController.m
//  CustomApp
//
//  Created by yangyong on 2017/6/3.
//  Copyright © 2017年 Blavtes. All rights reserved.
//

#import "RadomViewController.h"
#import "RMTBdReportBufferManager.h"
#import "YesterdayMenuViewController.h"

@interface RadomViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *type1;
@property (weak, nonatomic) IBOutlet UITextField *type2;
@property (weak, nonatomic) IBOutlet UITextField *type3;

@property (nonatomic, strong) NSMutableArray *typeData1;
@property (nonatomic, strong) NSMutableArray *typeData2;
@property (nonatomic, strong) NSMutableArray *typeData3;

@property (nonatomic, strong) NSMutableArray *randomDict;
@end

@implementation RadomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"选菜";
    _typeData1 = [NSMutableArray arrayWithCapacity:1];
    _typeData2 = [NSMutableArray arrayWithCapacity:1];
    _typeData3 = [NSMutableArray arrayWithCapacity:1];
    _randomDict = [NSMutableArray arrayWithCapacity:1];
    [self fileData];
    
    __weak typeof(self) weakSelf = self;
    [self.navTopView showRightTitle:@"昨天吃的啥" rightHandle:^(UIButton *view) {
        YesterdayMenuViewController *vc = [YesterdayMenuViewController new];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)fileData
{
    [_typeData1 removeAllObjects];
    [_typeData2 removeAllObjects];
    [_typeData3 removeAllObjects];
    for (NSDictionary *dict in _menuData) {
        if ([dict[BdTableTypeName] isEqualToString:@"荤"]) {
            [_typeData1 addObject:dict];
        } else if ([dict[BdTableTypeName] isEqualToString:@"素"]) {
            [_typeData2 addObject:dict];
        }  else if ([dict[BdTableTypeName] isEqualToString:@"汤"]) {
            [_typeData3 addObject:dict];
        }
    }
}

- (void)random
{
    [self fileData];
    _textView.text = @"";
    [_randomDict removeAllObjects];
    
    NSInteger count1 = _typeData1.count;
    NSInteger count2 = _typeData2.count;
    NSInteger count3 = _typeData3.count;
    NSMutableString *str = [NSMutableString stringWithCapacity:1];
    
    [str appendString:@"荤:\n\t"];
    [str appendString:[self filetrData:count1 data:_typeData1 type:_type1.text]];
    
    [str appendString:@"素:\n"];
    NSString *str2 = [self filetrData:count2 data:_typeData2 type:_type2.text];
    if (str2.length > 0) {
        [str appendString:@"\t"];
    }
    [str appendString: str2];
    [str appendString:@"汤:\n"];
    
    NSString *str3 = [self filetrData:count3 data:_typeData3 type:_type3.text];
    if (str3.length > 0) {
        [str appendString:@"\t"];
    }
    
    [str appendString:str3];
    
    _textView.text = str;
}

- (NSString *)filetrData:(NSInteger)count data:(NSMutableArray *)arr type:(NSString *)text
{
    NSInteger dataCount = [text integerValue];
    NSInteger arrCount = arr.count;
    NSMutableString *str = [NSMutableString stringWithCapacity:1];
    for (int i = 0; i < dataCount && dataCount <= arrCount; i++) {
        NSInteger x = [self randomData:count];
        if (x >= arrCount) {
            x = 0;
        }
        DLog(@"x %d arr %d",x ,arr.count);
        NSDictionary *dict = [arr objectAtIndex:x];
       
        NSString *name = dict[BdTableMenuName];
        NSString *lable = dict[BdTableMenuLabelName];
        
        [str appendString:name];
        [str appendString:@" : "];
        [str appendString:lable];
        if (i == [text integerValue] - 1) {
            [str appendString:@"\n\n"];
        } else {
            [str appendString:@"\n\n\t"];
        }
        [_randomDict addObject:dict];
        [arr removeObjectAtIndex:x];
        
        arrCount--;
        if (arrCount == 0) {
            break;
        }
    }
    return str;
}


- (NSInteger)randomData:(NSInteger)count
{
    if (count > 1) {
        return arc4random() % count;
    }
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)action:(id)sender {
    [self random];
}

- (IBAction)addAction:(id)sender {
    RMTBdReportBufferManager *manager = [RMTBdReportBufferManager sharedInstance];
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationString = [dateformatter stringFromDate:senddate];
    
    NSLog(@"locationString:%@",locationString);
    for (NSDictionary *dict in _randomDict) {
        [manager insertOldMenuIntoTable:BdOldTableName menuName:dict[BdTableMenuName] menuMutilpeStr:dict[BdTableMenuLabelName] menuType:dict[BdTableTypeName] time:locationString result:^(id result) {
            if (!result) {
                
            } else {
                Show_iToast(result);
            }
            
        }];
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
