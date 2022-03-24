//
//  CXSPlayerViewController.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/3/22.
//

#import "CXSPlayerViewController.h"
#import "CXSPlayerManager.h"

@interface CXSPlayerViewController ()

@property (nonatomic, strong)CXSPlayerManager *playerManager;

@end

@implementation CXSPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.text = @"点击播放";
    btn.titleLabel.textColor = [UIColor blackColor];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn addTarget:self action:@selector(playMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)playMusic {
    NSURL *url = [NSURL URLWithString:@"https://test-cxs.oss-cn-hangzhou.aliyuncs.com/test/test.mp3?Expires=1648089998&OSSAccessKeyId=TMP.3KieCGQxUeHZnFa4ufef699Xe8XHSy7KYdPTHaEVFRveL5HYMAVHvJnyku7ebpDqeBPshrgtBDnmujSwuvyPEM1zTbpejb&Signature=it33DuMAJf4PJQglpUqnylxWjHM%3D"];
    [self.playerManager musicPlayerWithURL:url];
}

- (void)progressSliderDidChange {
    [self.playerManager playerProgressWithProgressFloat:0.8];
}

#pragma mark - getter setter
- (CXSPlayerManager *)playerManager {
    if(!_playerManager) {
        _playerManager = [CXSPlayerManager shareManager];
    }
    return _playerManager;
}

@end
