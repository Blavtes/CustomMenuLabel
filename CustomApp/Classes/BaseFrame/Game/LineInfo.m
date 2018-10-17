//
//  LineInfo.m
//  ResetApp
//
//  Created by Blavtes on 2018/4/17.
//  Copyright © 2018年 Blavtes. All rights reserved.
//

#import "LineInfo.h"

@implementation LineInfo
- (instancetype)init
{
    if (self = [super init]) {
        self.path = [UIBezierPath new];
        self.drawColor = [UIColor blackColor];
    }
    return self;
}

- (CAShapeLayer *)lineLayer
{    
    if (!_lineLayer) {
        _lineLayer = [[CAShapeLayer alloc] init];
        _lineLayer.lineWidth = 1.0f;
        _lineLayer.strokeColor = [UIColor blackColor].CGColor;
        _lineLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _lineLayer;
}

- (BOOL)isEqual:(LineInfo *)object
{
    if (([object.startView isEqual:self.startView] &&[object.endView isEqual:self.endView]) || ([object.startView isEqual:self.endView] &&[object.endView isEqual:self.startView]) ) {
        return YES;
    }
    return NO;
}
@end
