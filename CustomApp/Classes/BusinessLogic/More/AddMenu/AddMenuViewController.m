//
//  AddMenuViewController.m
//  CustomApp
//
//  Created by yangyong on 2017/6/3.
//  Copyright © 2017年 Blavtes. All rights reserved.
//

#import "AddMenuViewController.h"
#import "RMTBdReportBufferManager.h"

@interface AddMenuViewController ()
@property (weak, nonatomic) IBOutlet UITextField *menuName;
@property (weak, nonatomic) IBOutlet UITextView *menuLabel;
@property (weak, nonatomic) IBOutlet UITextField *menuLabelInput;
@property (weak, nonatomic) IBOutlet UISegmentedControl *menuType;

@end

@implementation AddMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加菜单";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)clearn:(id)sender {
    [self resetTF];
}

- (IBAction)menuInputAction:(id)sender {
    NSString *oldStr = _menuLabel.text;
    NSMutableString *new = [NSMutableString new];
    
    if (oldStr.length > 0) {
        NSArray *arr = [oldStr componentsSeparatedByString:@","];
        for (NSString *temp in arr) {
            if ([temp isEqualToString:_menuLabelInput.text]) {
                Show_iToast(@"已添加");
                _menuLabelInput.text = @"";
                return;
            }
        }
        [new appendString:oldStr];
        [new appendString:@","];
    }
    [new appendString:_menuLabelInput.text];
    _menuLabel.text = new;
    _menuLabelInput.text = @"";
}

- (void)resetTF
{
    _menuLabelInput.text = @"";
    _menuLabel.text = @"";
    _menuName.text = @"";
    _menuType.selectedSegmentIndex = 0;
}

- (IBAction)menuNameAction:(id)sender {
    if (_menuName.text.length > 0 && _menuLabel.text.length > 0) {
        __weak typeof(self) weakSelf = self;
        
        if (_menuType.selectedSegmentIndex == 0) {
            
        }
        RMTBdReportBufferManager *manager = [RMTBdReportBufferManager sharedInstance];
        [manager insertMenuIntoTable:@"BDMenuTable" menuName:_menuName.text menuMutilpeStr:_menuLabel.text menuType:[_menuType titleForSegmentAtIndex:_menuType.selectedSegmentIndex] result:^(id result) {
            if (!result) {
                [weakSelf resetTF];
            } else {
                Show_iToast(result);
            }
            
        }];
    }
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

@end
