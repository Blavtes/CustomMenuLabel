//
//  SFRequestError.h
//  HX_GJS
//
//  Created by gjfax on 16/5/25.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFRequestError : NSObject


/*
 *  后台返回的状态值 success 为YES  fail 为No
 **/
@property (nonatomic, assign) BOOL                 stautsBool;

/*
 *  后台返回的错误码
 **/
@property (nonatomic, copy) NSString               *errorCode;

/*
 *  后台返回的错误提示语
 **/
@property (nonatomic, copy) NSString               *errorNote;

@end
