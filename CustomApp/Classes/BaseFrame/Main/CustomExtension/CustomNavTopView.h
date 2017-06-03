//
//  CustomNavTopView.h
//  GjFax
//
//  Created by Blavtes on 2017/3/23.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BackClickHandle)(UIButton *view);

typedef void(^RightClickHandle)(UIButton *view);

typedef void(^CloseAllClickHandle)(UIButton *view);

@interface CustomNavTopView : UIView

@property (nonatomic, copy) BackClickHandle backClick;
@property (nonatomic, copy) RightClickHandle rightClick;
@property (nonatomic, copy) CloseAllClickHandle closeAllClick;
//标题
@property (nonatomic, weak) UILabel *titleLabel;
//返回按钮
@property (nonatomic, weak) UIButton *backBtn;
//右导航按钮
@property (nonatomic, weak) UIButton *rightBtn;

@property (nonatomic, weak) UIView *closeLine;

@property (nonatomic, weak) UIButton *closeAllBtn;

@property (nonatomic, weak) UIButton *loginBtn;
////back 按钮 + title
- (instancetype)initWithTitle:(NSString *)title backClickHandle:(BackClickHandle)handle;

////right 文字按钮 + title
- (instancetype)initWithTitle:(NSString *)title rightTitle:(NSString *)rightTitle rightClickHandle:(RightClickHandle)rightClick;

//back 按钮 + title + right 文字按钮
- (instancetype)initWithTitle:(NSString *)title showBackImage:(BOOL)show rightTitle:(NSString *)rightTitle backClickHandle:(BackClickHandle)handle rightClickHandle:(RightClickHandle)rightClick;

//back 按钮 + title + right 按钮
- (instancetype)initWithTitle:(NSString *)title showBackImage:(BOOL)show rightImageName:(NSString *)rightNor rightHighlightImageName:(NSString *)rightHight backClickHandle:(BackClickHandle)handle rightClickHandle:(RightClickHandle)rightClick;

- (void)showTitle:(NSString *)title;

- (void)showBackTitle:(NSString *)title backHandle:(BackClickHandle)handle;

//默认返回按钮
- (void)showBackHandle:(BackClickHandle)handle;

- (void)showRightTitle:(NSString *)title rightHandle:(RightClickHandle)handle;

- (void)showRightImageName:(NSString *)rightNor rightHighlightImageName:(NSString *)rightHight rightHandle:(RightClickHandle)handle;

- (void)hideBack;
- (void)itemWithTaget:(id)taget backHandle:(BackClickHandle)handle;

- (void)showCloseAllClickHandle:(CloseAllClickHandle)close;

- (void)hideCloseAll;
@end
