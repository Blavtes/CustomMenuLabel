//
//  SFTableViewCell.h
//  HX_GJS
//
//  Created by gjfax on 16/5/23.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFTableViewCellModel.h"

@interface SFTableViewCell : UITableViewCell

@property (nonatomic, strong) SFTableViewCellModel              *cellModel;

@property (nonatomic, strong) NSIndexPath                       *indexPath;
@end
