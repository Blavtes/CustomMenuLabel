

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"
#import "MCKeyboardAccessoryView.h"

@class MCNumberKeyboardView;
@protocol MCNumberKeyboardDelegate <NSObject>
@optional
/** 点击了数字键盘数字按钮 */
- (void)keyboard:(MCNumberKeyboardView *)keyboard didClickButton:(UIButton *)button;
/** 点击了数字键盘删除按钮 */
- (void)keyboard:(MCNumberKeyboardView *)keyboard didClickDeleteBtn:(UIButton *)deleteBtn;
/** 点击了切换成字母键盘按钮 */
- (void)keyboard:(MCNumberKeyboardView *)keyboard didClickToCharacterBtn:(UIButton *)toCharacerBtn;
@end


@interface MCNumberKeyboardView : UIView
/** 数字键盘代理属性 */
@property (nonatomic, weak) id<MCNumberKeyboardDelegate> numberDelegate;
/** 初始化的对象方法 */
- (instancetype)initWithNumberKeyboard;

@end
