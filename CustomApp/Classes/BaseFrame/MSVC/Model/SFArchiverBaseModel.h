//
//  SFArchiverBaseModel.h
//  GjFax
//
//  Created by gjfax on 16/9/18.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SFBaseModel.h"

@interface SFArchiverBaseModel : SFBaseModel <NSCoding>



/**
 *  归档属性前缀，不继承 则 无前缀,与model保持一致
 *
 *  @return String
 */
- (NSString *)coderPrefix;
@end
