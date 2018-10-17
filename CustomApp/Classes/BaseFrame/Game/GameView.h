//
//  GameView.h
//  ResetApp
//
//  Created by Blavtes on 23/04/2018.
//  Copyright © 2018 Blavtes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointView.h"

typedef enum : NSUInteger {
    YYDefalutRank = 0, //默认
    YYSimpleRank = 1, //简单
    YYGeneralRank = 2, //普通
    YYDifficultyRank = 3,//困难
    YYAnomalyRank = 4,// 变态
} YYRankType;

typedef void(^WinBlock)(int level,int rank);
typedef void(^BackBlock)(void);
typedef void(^SeleckLevelBlock)(int level,int rank);
@interface GameView : UIView

@property (nonatomic, strong) NSMutableArray *poingtArray;
@property (nonatomic, strong) NSMutableArray *lineArray;
@property (nonatomic, strong) PointView *movePoint;
@property (nonatomic, strong) UILabel *lineTipsLabel;
@property (nonatomic, assign) int currentLevel;
@property (nonatomic, assign) YYRankType currentRankType;
@property (nonatomic, copy) WinBlock winBlock;
@property (nonatomic, copy) BackBlock backBlock;
@property (nonatomic, copy) SeleckLevelBlock seleckLevelBlock;
@property (nonatomic, weak) UILabel *timeLable;
@property (nonatomic, assign) int timeCount;

@property (nonatomic, strong) UIView *levelBgView;
- (instancetype)initWithFrame:(CGRect)frame level:(int)level rank:(YYRankType)rank;

@end
