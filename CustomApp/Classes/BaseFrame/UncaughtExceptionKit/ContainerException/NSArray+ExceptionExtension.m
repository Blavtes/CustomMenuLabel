//
//  NSArray+ExceptionExtension.m
//  GjFax
//
//  Created by litao on 2017/3/23.
//  Copyright © 2017年 GjFax. All rights reserved.
//

#import "NSArray+ExceptionExtension.h"

@implementation NSArray (ExceptionExtension)

- (instancetype)GJ_objectAtIndex:(NSUInteger)index
{
    if (self.count <= index) {
        DLog(@"Container Exception Crash!");
        return nil;
    }
    
    return [self GJ_objectAtIndex:index];
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = NSClassFromString(@"__NSArrayI");
        
        SEL originalSelector = @selector(objectAtIndex:);
        SEL swizzledSelector = @selector(GJ_objectAtIndex:);
        
        [self swizzleSelector:originalSelector withSwizzledSelector:swizzledSelector withClass:class];
    });
}
@end
