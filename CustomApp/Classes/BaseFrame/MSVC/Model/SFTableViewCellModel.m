//
//  SFTableViewCellModel.m
//  HX_GJS
//
//  Created by gjfax on 16/5/23.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SFTableViewCellModel.h"

@implementation SFTableViewCellModel


- (CGFloat)cellHeight {
    if (_cellHeight <= 0) {
        _cellHeight  = 50;
    }
    return _cellHeight;
}

@end
