//
//  SecurityNumberKeyBoardView.m
//  HX_GJS
//
//  Created by gjfax on 16/2/1.
//  Copyright © 2016年 GjFax. All rights reserved.
//

#import "SecurityNumberKeyBoardView.h"


#define kLineWidth 1
#define kNumFont [UIFont systemFontOfSize:27]
#define KsizeX  MAIN_SCREEN_WIDTH/3
#define Kheight 216

@interface SecurityNumberKeyBoardView ()

@property (nonatomic, strong) NSArray       *randomArray;
@end

@implementation SecurityNumberKeyBoardView


- (instancetype)init {
    
    self = [super initWithFrame:CGRectMake(0, MAIN_SCREEN_HEIGHT, MAIN_SCREEN_WIDTH, Kheight + 56)];
    if (self) {

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(closeInView)
                                                     name:GJS_KeyBoard_DownView_Noti
                                                   object:nil];
        [self initTopView];
        [self initBaseView];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(closeInView)
                                                     name:GJS_KeyBoard_DownView_Noti
                                                   object:nil];
        [self initTopView];
        [self initBaseView];
        
    }
    return self;
}

- (void)initTopView {
    
    UIView *topView = [self viewWithTag:12345];
    if (!topView) {
        topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 44)];
        topView.tag = 12345;
        topView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 7, 30, 30)];
        logoView.image = [UIImage imageNamed:@"Custom_KeyBoard_Logo_Icon"];
        [topView addSubview:logoView];
        
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 44)];
        tipsLabel.text = @"正在使用安全键盘";
        tipsLabel.textColor = COMMON_BLACK_COLOR;
        tipsLabel.font = [UIFont systemFontOfSize:16.f];
        [topView addSubview:tipsLabel];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(topView.width - 54, 0, 44, 44);
        [doneBtn setImage:[UIImage imageNamed:@"Custom_KeyBoard_Down_Icon"] forState:UIControlStateNormal];
        [topView addSubview:doneBtn];
        
        __weak typeof(self) weakSelf = self;
        [doneBtn GJSHandleClick:^(UIView *view) {
            [weakSelf downInView];
        }];
    }
    [self addSubview:topView];

}

- (void)initBaseView {
    
    self.randomArray = [self getRandomArray];
    
    UIView *keyBoardView = [self viewWithTag:20001];
    
    if (!keyBoardView) {
        keyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, MAIN_SCREEN_WIDTH, Kheight+10)];
        keyBoardView.tag = 20001;
        keyBoardView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:keyBoardView];
    }
    
    //初始化12个btn按钮
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            UIButton *button = [self creatButtonWithX:i Y:j];
            [keyBoardView addSubview:button];
        }
    }
    
}

-(UIButton *)creatButtonWithX:(NSInteger)x Y:(NSInteger)y
{
    NSInteger num = y + 3*x + 1;

    UIButton *button = [self viewWithTag:num];
    
    if (!button) {
        CGFloat frameY = (Kheight/4) * x +10;
        
        button = [[UIButton alloc] initWithFrame:CGRectMake(y*KsizeX, frameY, KsizeX - 1, Kheight/4 - 1)];
        button.tag = num;
        button.layer.cornerRadius = 8.f;
        UIColor *colorNormal = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1];
        UIColor *colorHightlighted = [UIColor colorWithRed:186.0/255 green:189.0/255 blue:194.0/255 alpha:1.0];
        button.backgroundColor = colorNormal;
        button.clipsToBounds = YES;
        [button setBackgroundColor:colorHightlighted forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    NSString *title = @"";

    if (num < 10) {
        title = [NSString stringWithFormat:@"%@",self.randomArray[num - 1]];
    }
    else if (num == 10) {
        title = @"清除";
    }
    else if (num == 11) {
        title = [NSString stringWithFormat:@"%@",[self.randomArray lastObject]];
    }
    else if (num == 12) {
        
        [button setImage:[UIImage imageNamed:@"Custom_KeyBoard_Clear_Icon"] forState:UIControlStateNormal];
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (num == 10 || num == 12) {
        button.backgroundColor = COMMON_LIGHT_GREY_COLOR;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    return button;
}


-(void)clickButton:(UIButton *)sender
{
//    Show_iToast(FMT_STR(@"%@",sender.titleLabel.text));
    
    if (self.returnBlock) {
        if (sender.tag == 10) {
            self.returnBlock(@"", ReturnBlockTypeClearAll);
        }else if (sender.tag == 12) {
            self.returnBlock(@"", ReturnBlockTypeClearOne);
        }else {
            self.returnBlock(sender.titleLabel.text, ReturnBlockTypeDefuatl);
        }
    }
    
}


/*
 *  弹出键盘
 */
- (void)showInView:(UIView *)view {
    
    if (self.y == MAIN_SCREEN_HEIGHT) {
        [self initTopView];
        [self initBaseView];
        
        [UIView animateWithDuration:0.25f animations:^{
            self.frame = CGRectMake(0, MAIN_SCREEN_HEIGHT - Kheight - 56, MAIN_SCREEN_WIDTH, Kheight + 56);
        }];
//        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [view addSubview:self];
        [view bringSubviewToFront:self];
    }

}

/*
 *  隐藏键盘
 */
- (void)downInView {
    
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = CGRectMake(0, MAIN_SCREEN_HEIGHT, MAIN_SCREEN_WIDTH, Kheight + 56);
    }];
}

- (void)closeInView {
    
    [self removeAllSubviews];
    [self removeFromSuperview];
}

//键盘数组随机
- (NSArray *)getRandomArray
{
    //随机数从这里边产生
    NSMutableArray *startArray = [[NSMutableArray alloc] initWithObjects:@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, nil];
    //随机数产生结果
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
    //随机数个数
    NSInteger number = startArray.count;
    for (int i = 0; i < number; i++) {
        int t = arc4random () % startArray.count;
        resultArray[i] = startArray[t];
        startArray[t] = [startArray lastObject]; //为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    return resultArray;
}

@end
