//
//  CustomBaseViewController.m
//  GjFax
//
//  Created by Blavtes on 2017/3/23.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "CustomBaseViewController.h"

@interface CustomBaseViewController ()

@end

@implementation CustomBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COMMON_GREY_WHITE_COLOR;
    [self.view endEditing:YES];
    [self initNavTopView];
    // Do any additional setup after loading the view.
}

- (void)initNavTopView
{
    CustomNavTopView *top = [[CustomNavTopView alloc] initWithTitle:@"" backClickHandle:^(UIButton *view) {
        [self back];
    }];
    [self.view addSubview:top];
    _navTopView = top;
}

- (void)setTitle:(NSString *)title
{
    self.navTopView.titleLabel.text = title;
    super.title = title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
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
