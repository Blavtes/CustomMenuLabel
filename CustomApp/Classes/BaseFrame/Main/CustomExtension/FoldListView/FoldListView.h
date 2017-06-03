//
//  FoldListView.h
//  HX_GJS
//
//  Created by litao on 16/1/13.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 触摸描述的回调 */
typedef void (^TouchFoldIconBlock)(NSInteger showedIndex, BOOL isShowCur);

/**
 *  折叠式列表,仅展开的区域用于展示信息
 */
@interface FoldListView : UIView

//  当前展开索引号
@property (assign, nonatomic, readonly) NSInteger curShowedIndex;

//  信息展示区域
@property (copy, nonatomic, readonly) UIView *curContentView;

#pragma mark - 类方法
/**
 *  返回一个折叠式view
 *
 *  @param superView
 *  @param titleArray
 *  @param touchFoldIconBlock
 *
 *  @return ret a fold list view
 */
- (instancetype)initWithFrame:(CGRect)frame
               withTitleArray:(NSArray *)titleArray
            withTouchTipBlock:(TouchFoldIconBlock)touchFoldIconBlock;

/**
 *  返回一个有标题详情的折叠式view
 *
 *  @param superView
 *  @param titleArray
 *  @param touchFoldIconBlock
 *
 *  @return ret a fold list view
 */
- (instancetype)initWithFrame:(CGRect)frame
               withTitleArray:(NSArray *)titleArray
         withTitleDetailArray:(NSArray *)titleDetailArray
            withTouchTipBlock:(TouchFoldIconBlock)touchFoldIconBlock;

/**
 *  更新可购买数量
 */
- (void)updateLastValue:(NSInteger)index withValue:(NSString *)valueStr;
@end
