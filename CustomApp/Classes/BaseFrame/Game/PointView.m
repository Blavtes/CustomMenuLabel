//
//  PointView.m
//  ResetApp
//
//  Created by Blavtes on 2018/4/17.
//  Copyright © 2018年 Blavtes. All rights reserved.
//

#import "PointView.h"

@implementation PointView

- (instancetype)init
{
    if (self = [super init]) {
        _text = [UILabel new];
        _text.frame = CGRectMake(0, 0, 25, 25);
        _text.textColor = [UIColor whiteColor];
        _text.font = [UIFont systemFontOfSize:10];
        _text.textAlignment = NSTextAlignmentCenter;
        _text.adjustsFontSizeToFitWidth = YES;
        self.userInteractionEnabled = NO;
        [self addSubview:_text];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)isEqual:(PointView*)object
{
    if ( fabs(object.center.x - self.center.x) < 1e-6 && fabs(object.center.y - self.center.y) < 1e-6) {
        return YES;
    }
    return NO;
}
@end
