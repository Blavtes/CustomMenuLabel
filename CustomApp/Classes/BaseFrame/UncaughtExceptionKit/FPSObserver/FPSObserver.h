//
//  FPSObserver.h
//  GjFax
//
//  Created by litao on 2017/3/24.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPSObserver : NSObject

@property (nonatomic, readonly, getter=fps) NSInteger fps;

+ (instancetype)startObserver;

@end
