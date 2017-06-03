//
//  SecurityNumberKeyBoardView.h
//  HX_GJS
//
//  Created by gjfax on 16/2/1.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GJS_KeyBoard_DownView_Noti      @"GJS_KeyBoard_DownView_Noti"

typedef NS_ENUM(NSInteger, ReturnBlockType) {
    ReturnBlockTypeDefuatl      =   20000,
    ReturnBlockTypeClearAll     =   20001,
    ReturnBlockTypeClearOne     =   20002,
};

typedef void(^KeyBoarReturnBlock)(NSString *textString, ReturnBlockType type);

@interface SecurityNumberKeyBoardView : UIView


@property (nonatomic, copy) KeyBoarReturnBlock      returnBlock;

/*
 *  弹出键盘
 */
- (void)showInView:(UIView *)view;

/*
 *  隐藏键盘
 */
- (void)downInView;

- (instancetype)initWithFrame:(CGRect)frame;
@end
