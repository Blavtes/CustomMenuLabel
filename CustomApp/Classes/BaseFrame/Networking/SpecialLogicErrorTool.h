//
//  SpecialLogicErrorTool.h
//  GjFax
//
//  Created by litao on 16/5/26.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialLogicErrorTool : NSObject

/**
 *  处理特殊错误码
 *
 *  @param errorCode 错误码
 *  @param errorNote note提示
 *
 *  @return 返回是否属于特殊错误码[属于直接处理了]
 */
+ (BOOL)handleSpecialErrorWithCode:(NSString *)errorCode andNote:(NSString *)errorNote;

@end
