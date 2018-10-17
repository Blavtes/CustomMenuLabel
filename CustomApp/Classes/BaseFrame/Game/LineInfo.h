//
//  LineInfo.h
//  ResetApp
//
//  Created by Blavtes on 2018/4/17.
//  Copyright © 2018年 Blavtes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PointView.h"

@interface LineInfo : NSObject
@property (nonatomic, strong) PointView *startView;
@property (nonatomic, strong) PointView *endView;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIColor  *drawColor;
@property (nonatomic, strong) CAShapeLayer   *lineLayer;
- (BOOL)isEqual:(LineInfo *)object;
@end
