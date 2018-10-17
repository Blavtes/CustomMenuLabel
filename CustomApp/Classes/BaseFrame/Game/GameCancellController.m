//
//  ViewController.m
//  ResetApp
//
//  Created by Blavtes on 2018/4/17.
//  Copyright © 2018年 Blavtes. All rights reserved.
//

#import "GameCancellController.h"

#import "GameView.h"

@interface GameCancellController ()
@property (nonatomic, weak) GameView *game;
@end

@implementation GameCancellController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configLevel:1 rank:YYGeneralRank];
    GJWeakSelf;
    self.navTopView.backClick = ^(UIButton *view) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)configLevel:(int)level rank:(YYRankType)rank
{
    if (_game) {
        [UIView animateWithDuration:0.5 animations:^{
            _game.alpha = 0;
        } completion:^(BOOL finished) {
            [_game removeFromSuperview];
            [self beginGameLevel:level rank:rank];
        }];
    } else {
        [self beginGameLevel:level rank:rank];
    }
}

- (void)beginGameLevel:(int)level rank:(YYRankType)rank
{
    GameView *game = [[GameView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                [UIScreen mainScreen].bounds.size.width,
                                                                [UIScreen mainScreen].bounds.size.height)
                                               level:level
                                                rank:rank];
    game.alpha = 0;
    [self.view addSubview:game];
    _game = game;
    __weak typeof(self) weakSelf = self;
    game.winBlock = ^(int level, int rank) {
        NSLog(@"level %d rank %d",level,rank);
        [weakSelf configLevel:level + 1 rank:rank];
    };
    game.seleckLevelBlock = ^(int level, int rank) {
        [weakSelf configLevel:level rank:rank];
    };
    game.backBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [UIView animateWithDuration:0.5 animations:^{
        _game.alpha = 1;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
