//
//  CXSMainViewController.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/4/8.
//

#import "CXSMainViewController.h"
#import "CXSPlayerViewController.h"

@interface CXSMainViewController ()

@end

@implementation CXSMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    btn.backgroundColor = [UIColor systemPinkColor];
    [btn setTitle:@"进入PlayVC" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(pushPlayMusicViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)pushPlayMusicViewController {
    CXSPlayerViewController *vc = [[CXSPlayerViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
    }];
}

@end
