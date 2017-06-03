//
//  CustomBaseViewController.h
//  GjFax
//
//  Created by Blavtes on 2017/3/23.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavTopView.h"

@interface CustomBaseViewController : UIViewController
@property (nonatomic, weak) CustomNavTopView *navTopView;
- (void)setTitle:(NSString *)title;
- (void)back;
@end
