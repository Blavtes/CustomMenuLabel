//
//  FoldListSubTitleView.h
//  HX_GJS
//
//  Created by litao on 16/1/13.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomImgBgLabel;

typedef NS_ENUM(NSInteger, FoldBtnStatus) {
    FoldBtnStatusShowed = 0,
    FoldBtnStatusClosed
};

typedef void (^TouchBtnBlock)(FoldBtnStatus btnStatus);

@interface FoldListSubTitleView : UIView

//  左侧图片
@property (strong, nonatomic) UIImageView *imgView;

//  tf
@property (strong, nonatomic) UILabel *titleLb;
//  detailTitle
@property (strong, nonatomic) UILabel *detailLb;

//  btn
@property (strong, nonatomic) UIButton *foldBtn;
//  可购买数量
@property (strong, nonatomic) CustomImgBgLabel *imgBgLb;

@property (assign, nonatomic, getter=getBtnStatus) FoldBtnStatus btnStatus;

- (instancetype)initWithFrame:(CGRect)frame
                    withTitle:(NSString *)title
              withArrowStatus:(FoldBtnStatus)btnStatus
            withTouchBtnBlock:(TouchBtnBlock)touchBtnBlock;

@end
