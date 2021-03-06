//
//  CXSTabBarController.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/3/15.
//

#import "CXSTabBarController.h"
#import "CXSTabBar.h"
#import "CXSPlayerViewController.h"
#import "CXSMainViewController.h"
#import "CXSMainMusicViewController.h"
#import "CXSLovedMusicViewController.h"
#import "CXSLocalMusicViewController.h"

#define ARC4COLOR [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@interface CXSTabBarController ()

@end


@implementation CXSTabBarController

+ (void)initialize
{
    // 通过appearance统一设置所有UITabBarItem的文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 添加子控制器
    [self setupChildVc:[[CXSMainMusicViewController alloc] init] title:@"主歌单" image:@"tabbar_home_os7" selectedImage:@"tabbar_home_selected_os7"];
    
    [self setupChildVc:[[CXSLovedMusicViewController alloc] init] title:@"喜欢音乐" image:@"tabbar_discover_os7" selectedImage:@"tabbar_discover_selected_os7"];
    
    [self setupChildVc:[[CXSLocalMusicViewController alloc] init] title:@"我的音乐" image:@"tabbar_profile_os7" selectedImage:@"tabbar_profile_selected_os7"];
    
    //自定义tabbar
    [self setValue:[[CXSTabBar alloc] init] forKeyPath:@"tabBar"];
}

/**
 * 初始化子控制器
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:vc];
}

@end
