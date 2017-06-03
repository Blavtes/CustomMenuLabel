//
//  CheckUpdateAlertView.h
//  GjFax
//
//  Created by gjfax on 16/8/8.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckUpdateAlertView : CustomAlertView

@property (strong, nonatomic, readwrite, nullable) UILabel *decLable;

@property (strong, nonatomic, nullable)UIButton *closeBtn;

@property (strong, nonatomic, nullable)UIScrollView *decScrollView;

- (CheckUpdateAlertView * _Nonnull)initWithCompletionBlock:(ConfirmBlock)completionBlock;

@end
