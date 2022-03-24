//
//  CXSPlayerManager.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/3/23.
//

#import "CXSPlayerManager.h"

@implementation CXSPlayerManager
{
    id timeObserve;// 为 当前AVPlayerItem 添加观察者获取各种播放状态
}

+ (instancetype)shareManager {
    static CXSPlayerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [CXSPlayerManager new];
    });
    return manager;
}

- (instancetype)init {
    if (self =[super init]) {
        
    }
    return self;
}

#pragma mark - private method


#pragma mark - public method
//播放
- (void)playMusic {
    [self.player play];
}

//暂停
- (void)pasueMusic {
    [self.player pause];
}

//播放指定url
- (void)musicPlayerWithURL:(NSURL *)playerItemURL {
    
    //创建要播放的资源
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:playerItemURL];
    //播放当前资源
    if(self.player.currentItem){
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
    }else {
        self.player = [self.player initWithPlayerItem:playerItem];
        [self playMusic];
    }
}

//将slider的值传入使 歌曲进度 前进或后退
-(void)playerProgressWithProgressFloat:(CGFloat)progressFloat{
    //精确跳转
    CGFloat val = CMTimeGetSeconds(self.player.currentItem.duration);
    [self.player seekToTime:CMTimeMake(val*progressFloat, 1) toleranceBefore:CMTimeMake(1, 1000) toleranceAfter:CMTimeMake(1, 1000)];
}

#pragma mark - getter setter 懒加载
- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}

@end
