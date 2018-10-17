//
//  PointView.h
//  ResetApp
//
//  Created by Blavtes on 2018/4/17.
//  Copyright © 2018年 Blavtes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointView : UIView
//编号 1-> 6个点 8条线 
//    2-> 8个点 11条线
@property (nonatomic, assign) int flag;
@property (nonatomic, strong) UILabel *text;
- (BOOL)isEqual:(PointView *)object;
@end
