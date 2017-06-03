

#import <UIKit/UIKit.h>
@class MCKeyboardAccessoryView;
@protocol MCKeyboardAccessoryViewDelegate <NSObject>
@optional
/** 点击了完成按钮 */
- (void)accessaryBtn:(MCKeyboardAccessoryView *)keyboard didClickFinishButton:(UIButton *)finishButton;

@end

@interface MCKeyboardAccessoryView : UIView
// 代理属性
@property (nonatomic, weak) id<MCKeyboardAccessoryViewDelegate>  accessaryBtnDelegate;

/* 初始化 */
+ (instancetype)initKeyBoardAccessory;
@end
