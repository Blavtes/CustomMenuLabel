//
//  CustomTabBarViewController.m
//
//  Created by 李涛 on 15/4/26.
//  Copyright (c) 2015年 李涛. All rights reserved.
//

#import "CustomTabBarViewController.h"

#import "CustomNavigationController.h"

#pragma mark - V3.0
#import "HomePageViewController.h"


#import "MorePageViewController.h"

#import "PreCommonHeader.h"


@interface CustomTabBarViewController ()
{
    //  ...
}
@end

@implementation CustomTabBarViewController



- (void)addController
{
    NSArray *nomarlImageArr = @[@"tabBar_home",@"tabBar_product",@"tabBar_asset",@"tabBar_more"];
    NSArray *selectImageArr = @[@"tabBar_home_selected",@"tabBar_product_selected",@"tabBar_asset_selected",@"tabBar_more_selected"];
    
  
        //  首页推荐
    HomePageViewController *homeVc = [[HomePageViewController alloc] init];
    [self addOneChildVc:homeVc title:@"菜单" imageName:nomarlImageArr[0] selectedImageName:selectImageArr[0]];
    
//        //  理财
//    CustomBaseViewController *productVc = [[CustomBaseViewController alloc] init];
//        //ProductViewController *productVc = [[ProductViewController alloc] init];
//    [self addOneChildVc:productVc title:@"理财" imageName:nomarlImageArr[1] selectedImageName:selectImageArr[1]];
//    
//        //  资产
//    CustomBaseViewController *assetVc = [[CustomBaseViewController alloc] init];
//    [self addOneChildVc:assetVc title:@"账户" imageName:nomarlImageArr[2] selectedImageName:selectImageArr[2]];
    
        //  更多
    MorePageViewController *moreVc=[[MorePageViewController alloc] init];
    [self addOneChildVc:moreVc title:@"设置" imageName:nomarlImageArr[3] selectedImageName:selectImageArr[3]];
    
    self.tabBar.backgroundImage = [UIImage imageWithName:@"tabBar_background"];

  
}

#pragma mark - 添加子Vc
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self addController];
    
}

#pragma mark - 设置tabbar选中的颜色
/**
 *  只调用一次
 */
+ (void)initialize
{
    [self setupTabBarItemTheme];
}

+ (void)setupTabBarItemTheme
{
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:COMMON_BLUE_GREEN_COLOR, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
}



/**
 *  添加一个控制器
 *
 *  @param childVc           子控制器，viewVc类型，能支持自定义控制器
 *  @param title             title
 *  @param imageName         图标icon
 *  @param selectedImageName 选中状态图标icon
 */
- (void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    //  设置tabbar 和 navi 的title
    childVc.title = title;

    //  设置图标
    UIImage *image = [UIImage imageWithName:imageName];
    
    //  设置选中的图标
    //  在iOS7中, 会对selectedImage的图片进行再次渲染为蓝色
    //  要想显示原图, 就必须得告诉它: 不要渲染
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    if (IOS7)
    {
        //  声明这张图片用原图(别渲染)
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    }
    childVc.tabBarItem.image = image;
    
    childVc.tabBarItem.selectedImage = selectedImage;
   
        //  添加为tabbar控制器的子控制器
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

#pragma mark - 截取tabbar选择 - 记录上次选择index - 清空其下navi所有
-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    //判断是否相等,不同才设置
    if (self.selectedIndex != selectedIndex) {
        //设置最近一次
        _lastSelectedIndex = (int)self.selectedIndex;
        
        //DLog(@"old= %d  new = %ld class = %@", _lastSelectedIndex, selectedIndex, self.selectedViewController);
        
        //  清空tabbar下挂载navi的所有子vc
        CustomNavigationController *naviVc = (CustomNavigationController *)self.selectedViewController;
        
#pragma mark - 采集数据[通过CommonMethod swithTabbar切换]
        //  目标类
        NSString *curClassName = [CommonMethod classNameWithTabbarIndex:selectedIndex];
        ;
        //  当前类 - src
        NSString *srcClassName = [NSString stringWithUTF8String:object_getClassName(naviVc.viewControllers[[naviVc.viewControllers count] - 1])];
    
        
#pragma mark - 清空操作
        [naviVc popToRootViewControllerAnimated:NO];
    }
    
    //调用父类的setSelectedIndex
    [super setSelectedIndex:selectedIndex];
}

/*
 *  3DTouch回到首页，会清空navi的子VC
 */
- (void)fetch3DTouchCallBackHome
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeVC" object:nil];

        //设置最近一次
        _lastSelectedIndex = 0;
        //  清空tabbar下挂载navi的所有子vc
        [CommonMethod backToSpecificVCWithOrder:(CustomNavigationController *)self.selectedViewController SpecificCount:0 fail:nil];
        //调用父类的setSelectedIndex
        [super setSelectedIndex:_lastSelectedIndex];
    }];
}

/*
 *  回到tabbar特定页，会清空navi的子VC
 */
- (void)callBackHomeWithIndex:(int)selectIndex
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeVC" object:nil];
        //设置最近一次
        _lastSelectedIndex = selectIndex;
        //  清空tabbar下挂载navi的所有子vc
        [CommonMethod backToSpecificVCWithOrder:(CustomNavigationController *)self.selectedViewController SpecificCount:0 fail:nil];
        //调用父类的setSelectedIndex
        [super setSelectedIndex:_lastSelectedIndex];
    }];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //获得选中的item
    NSUInteger tabIndex = [tabBar.items indexOfObject:item];
    
    if (tabIndex != self.selectedIndex) {

        
        
#pragma mark - 设置变更tabbar切换操作
        //设置最近一次变更
        _lastSelectedIndex = (int)self.selectedIndex;
    }
}

@end
