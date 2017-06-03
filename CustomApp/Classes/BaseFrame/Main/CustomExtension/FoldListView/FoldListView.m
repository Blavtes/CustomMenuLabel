//
//  FoldListView.m
//  HX_GJS
//
//  Created by litao on 16/1/13.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "FoldListView.h"
#import "FoldListSubTitleView.h"


static NSInteger const titleViewHeight = 50.0f;

@interface FoldListView () {
    //
}
//  折叠Block
@property (copy, nonatomic) TouchFoldIconBlock touchFoldIconBlock;

//  当前展示索引
@property (assign, nonatomic) NSInteger curIndex;

//  信息展示区域
@property (strong, nonatomic) UIView *showedContentView;

//  子标题view数组
@property (strong, nonatomic) NSMutableArray *subViewArray;

//  所有列表标签标题数组
@property (strong, nonatomic) NSArray *titleArray;

//  子描述信息数组
@property (strong, nonatomic) NSArray *titleDetailArray;
@end

@implementation FoldListView
#pragma mark - base init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configData];
        
        [self initBaseView];
    }
    
    return self;
}


- (void)configData
{
    _curIndex = 0;
}

- (void)initBaseView
{
    self.backgroundColor = COMMON_WHITE_COLOR;
    
    _showedContentView = [[UIView alloc] init];
    _showedContentView.backgroundColor = COMMON_WHITE_COLOR;
    [self addSubview:_showedContentView];
}

#pragma mark - 实例方法
- (instancetype)initWithFrame:(CGRect)frame
               withTitleArray:(NSArray *)titleArray
            withTouchTipBlock:(TouchFoldIconBlock)touchFoldIconBlock
{
    self = [self initWithFrame:frame withTitleArray:titleArray withTitleDetailArray:nil withTouchTipBlock:touchFoldIconBlock];
    
    if (self) {
        //
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
               withTitleArray:(NSArray *)titleArray
         withTitleDetailArray:(NSArray *)titleDetailArray
            withTouchTipBlock:(TouchFoldIconBlock)touchFoldIconBlock
{
    self = [self initWithFrame:frame];
    if (self) {
        
        _titleArray = titleArray;
        _titleDetailArray = titleDetailArray;
        _touchFoldIconBlock = touchFoldIconBlock;
        
        [self updateFrame];
    }
    
    return self;
}

#pragma mark - UI
- (void)updateFrame
{
    if (!_titleArray) {
        _titleArray = [NSArray array];
    }
    if (!_titleDetailArray) {
        _titleDetailArray = [NSArray array];
    }
    
    if (_titleArray.count > 0) {
        _showedContentView.frame = CGRectMake(0, titleViewHeight, self.width, self.height - _titleArray.count * titleViewHeight);
    } else {
        _showedContentView.frame = CGRectMake(0, 0, self.width, self.height - _titleArray.count * titleViewHeight);
    }
    
    _subViewArray = [NSMutableArray arrayWithCapacity:_titleArray.count];
    
    __weak typeof(self) weakSelf = self;
    
    for (int index = 0; index < _titleArray.count; index++) {
        if (0 == index) {
            FoldListSubTitleView *subView = [[FoldListSubTitleView alloc] initWithFrame:CGRectMake(0, 0, self.width, titleViewHeight) withTitle:_titleArray[index] withArrowStatus:FoldBtnStatusShowed withTouchBtnBlock:^(FoldBtnStatus btnStatus) {
                
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf) {
                    //  返回idnex
                    _touchFoldIconBlock(index, btnStatus == FoldBtnStatusShowed);
                    
                    [strongSelf updateTitleFrame:index withStatus:btnStatus];
                }
                
            }];
            subView.detailLb.text = _titleDetailArray[index];
            subView.tag = index + 1;
            [self addSubview:subView];
            
            [_subViewArray addObject:subView];
        } else {
            FoldListSubTitleView *subView = [[FoldListSubTitleView alloc] initWithFrame:CGRectMake(0, self.height - (_titleArray.count - index) * titleViewHeight, self.width, titleViewHeight) withTitle:_titleArray[index] withArrowStatus:FoldBtnStatusClosed withTouchBtnBlock:^(FoldBtnStatus btnStatus) {
                
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf) {
                    //  返回idnex
                    _touchFoldIconBlock(index, btnStatus == FoldBtnStatusShowed);
                    
                    [strongSelf updateTitleFrame:index withStatus:btnStatus];
                }
                
            }];
            subView.detailLb.text = _titleDetailArray[index];
            subView.tag = index + 1;
            [self addSubview:subView];
            
            [_subViewArray addObject:subView];
        }
    }
}

#pragma mark - update title frame
- (void)updateTitleFrame:(NSInteger)index withStatus:(FoldBtnStatus)btnStatus
{
    _curIndex = index;
    
    //  如果点击后状态是展开  则其他所有均必须是关闭  同一时间只能保证一个被展开
    if (btnStatus == FoldBtnStatusShowed) {
        for (FoldListSubTitleView *subView in _subViewArray) {
            if (subView.tag != index + 1) {
                subView.btnStatus = FoldBtnStatusClosed;
            }
        }
        
        //  变更frame
        for (FoldListSubTitleView *subView in _subViewArray) {
            if (subView.tag <= index + 1) {
                subView.frame = CGRectMake(0, (subView.tag - 1) * titleViewHeight, subView.width, subView.height);
            } else {
                subView.frame = CGRectMake(0, self.height - (_titleArray.count - (subView.tag - 1)) * titleViewHeight, subView.width, subView.height);
            }
        }
        
        _showedContentView.frame = CGRectMake(0, (index + 1) * titleViewHeight, self.width, self.height - _titleArray.count * titleViewHeight);
        _showedContentView.hidden = NO;
    } else {
        //  变更frame
        for (FoldListSubTitleView *subView in _subViewArray) {
            subView.frame = CGRectMake(0, (subView.tag - 1) * titleViewHeight, subView.width, subView.height);
        }
        
        //_showedContentView.frame = CGRectZero;
        _showedContentView.hidden = YES;
    }
}

#pragma mark - 更新可购买数量
- (void)updateLastValue:(NSInteger)index withValue:(NSString *)valueStr
{
    for (FoldListSubTitleView *subView in _subViewArray) {
        
        if (subView.tag == index + 1) {
            
            break;
        }
    }
}

#pragma mark - lazyLoad
- (NSInteger)curShowedIndex
{
    return _curIndex;
}

- (UIView *)curContentView
{
    return _showedContentView;
}

#pragma mark - 移除superView中的自身
+ (void)removeFoldListViewFromSuper:(UIView *)superView
{
    NSArray *subviews = superView.subviews;
    for (FoldListView *foldView in subviews) {
        if ([foldView isKindOfClass:self]) {
            [foldView removeFromSuperview];
        }
    }
}
@end
