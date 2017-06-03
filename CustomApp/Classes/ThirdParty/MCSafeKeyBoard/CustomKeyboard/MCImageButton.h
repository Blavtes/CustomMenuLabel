//
//  UIButton.h
//  SafeDefineKeyboard
//
//  Created by gjfax on 16/5/25.
//  Copyright © 2016年 macheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCImageButton : UIButton

/** 初始化 */
- (void)initImageName:(NSString*)imageName;

/*
 *  显示大图字母
 */
- (void)showImageViewWithLabelName:(NSString *)labelName;
/*
 *  隐藏大图字母
 */
- (void)hideImageViewWithLabelName:(NSString *)labelName;
@end
