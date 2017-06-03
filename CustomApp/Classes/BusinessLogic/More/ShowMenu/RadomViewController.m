//
//  RadomViewController.m
//  CustomApp
//
//  Created by yangyong on 2017/6/3.
//  Copyright © 2017年 Blavtes. All rights reserved.
//

#import "RadomViewController.h"
#import "RMTBdReportBufferManager.h"

@interface RadomViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *type1;
@property (weak, nonatomic) IBOutlet UITextField *type2;
@property (weak, nonatomic) IBOutlet UITextField *type3;

@property (nonatomic, strong) NSMutableArray *typeData1;
@property (nonatomic, strong) NSMutableArray *typeData2;
@property (nonatomic, strong) NSMutableArray *typeData3;
@end

@implementation RadomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"选菜";
    _typeData1 = [NSMutableArray arrayWithCapacity:1];
    _typeData1 = [NSMutableArray arrayWithCapacity:2];
    _typeData1 = [NSMutableArray arrayWithCapacity:3];
    [self fileData];
    // Do any additional setup after loading the view from its nib.
}

- (void)fileData
{
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
    _textView.text = @"";
    
    NSInteger count1 = _typeData1.count;
    NSInteger count2 = _typeData2.count;
    NSInteger count3 = _typeData3.count;
    NSMutableString *str = [NSMutableString stringWithCapacity:1];
    
    [str appendString:@"荤:\n\t"];
    [str appendString:[self filetrData:count1 data:_typeData1 type:_type1.text]];
    
    [str appendString:@"素:\n\t"];
    
    [str appendString: [self filetrData:count2 data:_typeData2 type:_type2.text]];
    [str appendString:@"汤:\n\t"];
    [str appendString:[self filetrData:count3 data:_typeData3 type:_type3.text]];
    
    _textView.text = str;
}

- (NSString *)filetrData:(NSInteger)count data:(NSArray *)arr type:(NSString *)text
{
    NSMutableString *str = [NSMutableString stringWithCapacity:1];
    for (int i = 0; i < [text integerValue] && [text integerValue] <= arr.count; i++) {
        NSInteger x = [self randomData:count];
        NSDictionary *dict = [arr objectAtIndex:x];
        NSString *name = dict[BdTableMenuName];
        NSString *lable = dict[BdTableMenuLabelName];
        [str appendString:name];
        [str appendString:@":"];
        [str appendString:lable];
        if (i == [text integerValue] - 1) {
            [str appendString:@"\n\n"];
        } else {
            [str appendString:@"\n\n\t"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
