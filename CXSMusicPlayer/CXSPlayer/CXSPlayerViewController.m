//
//  CXSPlayerViewController.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/3/22.
//

#import "CXSPlayerViewController.h"
#import "CXSPlayerManager.h"
#import "CXSPlayerView.h"

@interface CXSPlayerViewController () <CXSPlayVCActionProcotol>

@property (nonatomic, strong)CXSPlayerView *playView;
@property (nonatomic, strong)CXSPlayerManager *playerManager;

@end

@implementation CXSPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDefault];
}

- (void)initDefault {
    [self.view addSubview:self.playView];
    [self playMusic];
    self.playerManager.setSliderValue = ^(CGFloat value) {
        [self.playView setSliderValue:value];
    };
}

#pragma mark - CXSPlayVCActionProcotol
- (void)changeLikeMode:(BOOL)isLike {
    //option
}

- (void)downLoadCurrentMusic {
    //option
}

- (void)changeSilder:(CGFloat)value {
    //option
    [self.playerManager playerProgressWithProgressFloat:value];
}

- (void)changePlayerMode:(NSInteger)type {
    self.playerManager.playerType = type;
}

- (void)playLastMusic {
    [self.playerManager lastSong];
}

- (void)playPauseMusic:(BOOL)isPlay {
    if(isPlay){
        [self.playerManager playMusic];
    }else {
        [self.playerManager pasueMusic];
    }
}

- (void)playNextMusic {
    [self.playerManager nextSong];
}

- (void)showCurrentMusicList {
    //option
}



#pragma mark - private
- (void)playMusic {
    NSMutableArray *musicArray = [NSMutableArray array];
    for(int i = 0; i < 3; i ++) {
        NSString *name = [NSString stringWithFormat:@"test%d",i];
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"mp3"]];
        [musicArray addObject:url];
    }
    [self.playerManager musicPlayerWithArray:musicArray andIndex:0];
}

#pragma mark - getter setter
- (CXSPlayerManager *)playerManager {
    if(!_playerManager) {
        _playerManager = [CXSPlayerManager shareManager];
    }
    return _playerManager;
}

- (CXSPlayerView *)playView {
    if(!_playView) {
        _playView = [[CXSPlayerView alloc] init];
        _playView.delegate = self;
    }
    return _playView;
}

@end
