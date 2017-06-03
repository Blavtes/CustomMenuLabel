//
//  GJSNumKeyBoardField.m
//  HX_GJS
//
//  Created by gjfax on 16/2/22.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "GJSNumKeyBoardField.h"


static NSInteger kNum = 6;

@interface GJSNumKeyBoardField ()

@property (nonatomic, strong) SecurityNumberKeyBoardView    *keyBoardView;
@property (nonatomic, assign) CGFloat                       gridWidth;  //每个格子的宽
@property (nonatomic, assign) UIView                        *curView;
@end

@implementation GJSNumKeyBoardField

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GJS_KeyBoard_DownView_Noti object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame curView:(UIView *)curView {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        if (!curView || ![curView isKindOfClass:[UIView class]]) {
            return self;
        }
        _curView = curView;
        
        UIView *baseView = [[UIView alloc] initWithFrame:self.bounds];
        baseView.layer.borderWidth = 1.f;
        baseView.layer.borderColor = COMMON_LIGHT_GREY_COLOR.CGColor;
        baseView.backgroundColor = [UIColor whiteColor];
        [self addSubview:baseView];
        
        __weak typeof(self) weakSelf = self;
        [baseView GJSHandleClick:^(UIView *view) {
            [weakSelf.keyBoardView showInView:curView];
        }];
        
        self.text = @"";
        
        self.keyBoardView.returnBlock = ^(NSString *textString, ReturnBlockType type) {

            if (ReturnBlockTypeClearOne == type) {
                if (weakSelf.text.length > 0) {
                    weakSelf.text = [weakSelf.text substringToIndex:weakSelf.text.length - 1];
                }
            }else if (ReturnBlockTypeClearAll == type) {
                weakSelf.text = @"";
                
            }else if (weakSelf.text.length < kNum && type == ReturnBlockTypeDefuatl) {
                weakSelf.text = [weakSelf.text stringByAppendingString:textString];
                
            }
            
            [weakSelf initTextInputFlag:weakSelf.text];
        };
        
        
        self.gridWidth = self.width/kNum;
        for (NSInteger i = 0; i < kNum - 1; i++) { //只需5条线
            CGFloat lineX = self.gridWidth*(i+1);
            UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(lineX - 1, 3, 1.f, self.height - 6)];
            sepLine.backgroundColor = COMMON_LIGHT_GREY_COLOR;
            [baseView addSubview:sepLine];
        }
        
        for (NSInteger i = 0; i < kNum; i++) {
            CGFloat lineX = self.gridWidth*i + (self.gridWidth - 20)/2;
            CGFloat lineY = (self.height - 20)/2;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(lineX, lineY, 20, 20)];
            view.tag = 10000+i;
            view.backgroundColor = COMMON_BLACK_COLOR;
            view.layer.cornerRadius = 10;
            view.hidden = YES;
            [baseView addSubview:view];
        }
        
    }
    return self;
}

- (void)initTextInputFlag:(NSString *)text {
    
    NSInteger maxTag = 10005;
    NSInteger length = text.length;
    NSInteger curMaxTag = 10000+length;
    for (NSInteger i = 0; i < length; i++) {
        UIView *view = [self viewWithTag:10000+i];
        view.hidden = NO;
    }
    for (NSInteger i = 0; i <= maxTag - curMaxTag; i++) {
        UIView *view = [self viewWithTag:10005 - i];
        view.hidden = YES;
    }
    
    //length = 0时不返回block;
    if (_block) {
        if (length >= 6) {
            double delayInSeconds = .1f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                _block(length);
            });
        }else if (length > 0) {
            
            _block(length);
        }
    }
    
    
}

- (void)resetKeyBoardText {
    
    self.text = @"";
    [self initTextInputFlag:self.text];
}

- (void)keyBoardResignFirstResponder {
    
    [self.keyBoardView downInView];
}

- (void)keyBoardBecomeFirstResponder {
    [self.keyBoardView showInView:_curView];
}

- (void)returnTextNumberBlcok:(returnTextNumberBlock)block {
    
    _block = block;
}

- (SecurityNumberKeyBoardView *)keyBoardView {
    
    if (!_keyBoardView) {
        //_keyBoardView = [[SecurityNumberKeyBoardView alloc] initWithFrame:CGRectMake(0, MAIN_SCREEN_HEIGHT - 215 - 56, MAIN_SCREEN_WIDTH, 215 + 56)];
        _keyBoardView = [[SecurityNumberKeyBoardView alloc] init];
    }
    return _keyBoardView;
}


@end
