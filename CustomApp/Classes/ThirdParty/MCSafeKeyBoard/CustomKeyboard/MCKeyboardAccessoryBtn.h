

#import <UIKit/UIKit.h>
@class MCKeyboardAccessoryBtn;
@protocol MCKeyboardAccessoryBtnDelegate <NSObject>
@optional
/** 点击了完成按钮 */
- (void)accessaryBtn:(MCKeyboardAccessoryBtn *)keyboard didClickFinishButton:(UIButton *)finishButton;

@end

@interface MCKeyboardAccessoryBtn : UIButton
// 代理属性
@property (nonatomic, weak) id<MCKeyboardAccessoryBtnDelegate>  accessaryBtnDelegate;

/* 初始化 */
+ (instancetype)initKeyBoardAccessory;
@end
