//
//  SFArchiverBaseModel.m
//  GjFax
//
//  Created by gjfax on 16/9/18.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SFArchiverBaseModel.h"

@implementation SFArchiverBaseModel





#pragma mark -  ----------------- 归档 ----------------
/**
 *  归档属性前缀，不继承 则 无前缀,与model保持一致
 *
 *  @return String
 */
- (NSString *)coderPrefix
{
    return @"";
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        
        //  获取所有propertiest
        NSMutableArray *propertiestArray = [self GJSAllPropertiest];
        
        for (NSString *propertiest in propertiestArray) {
            
            NSString *keyStr = [self coderPrefix];
            if (keyStr && ![keyStr isNullStr]) {
                keyStr = [keyStr stringByAppendingString:propertiest];
            } else {
                keyStr = propertiest;
            }
            
            //  将解码出来的值 保存回 对应的propertiest
            if ([decoder decodeObjectForKey:keyStr]) {
                [self setValue:[decoder decodeObjectForKey:keyStr] forKey:propertiest];

            }
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //  获取所有propertiest
    NSMutableArray *propertiestArray = [self GJSAllPropertiest];
    
    for (NSString *propertiest in propertiestArray) {
        
        NSString *keyStr = [self coderPrefix];
        if (keyStr && ![keyStr isNullStr]) {
            keyStr = [keyStr stringByAppendingString:propertiest];
        } else {
            keyStr = propertiest;
        }
        //  编码后 保存
        [encoder encodeObject:[self valueForKey:propertiest] forKey:keyStr];
    }
}
@end
