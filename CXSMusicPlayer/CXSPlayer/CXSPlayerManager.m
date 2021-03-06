//
//  CXSPlayerManager.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/3/23.
//

#import "CXSPlayerManager.h"

@interface CXSPlayerManager()

@property (nonatomic, retain) NSTimer *timer;

@end

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
        [self initDefault];
    }
    return self;
}

#pragma mark - private method
- (void)initDefault {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(playerAction) userInfo:nil repeats:YES];
}

-(void)playerAction{
    //当前时间 / 总时间
    CGFloat value = CMTimeGetSeconds(self.player.currentItem.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
    self.setSliderValue(value);
    //进度条结束
    if(value >= 0.999){
        [self nextSong];
        self.updatePlayBtnUI();
    }
}

#pragma mark - public method
//播放
- (void)playMusic {
    [self.player play];
}

//暂停
- (void)pasueMusic {
    [self.player pause];
}

//上一首
-(void)lastSong{
    [self.player.currentItem seekToTime:(kCMTimeZero) completionHandler:^(BOOL finished) {
        
        if (self.playerType == AVPlayerTypeNormal) {//顺序循环播放
            //判断当前歌曲是否是第一首歌曲，如果是跳转到最后一首歌
            if ([self.musicArray indexOfObject:self.player.currentItem] == 0) {
                [self.player replaceCurrentItemWithPlayerItem:self.musicArray.lastObject];
            }else{
                [self.player replaceCurrentItemWithPlayerItem:self.musicArray[[self.musicArray  indexOfObject:self.player.currentItem]-1]];
            }
            
        }else if (self.playerType == AVPlayerTypeRandom){//随机播放
            
            [self.player replaceCurrentItemWithPlayerItem:self.musicArray[arc4random_uniform((int)self.musicArray.count)]];
        }else if (self.playerType ==AVPlayerTypeSingle){ //单曲循环在自动切换歌曲时进行判断
            [self.player replaceCurrentItemWithPlayerItem:self.musicArray[[self.musicArray  indexOfObject:self.player.currentItem]]];
        }
        self.updatePlayBtnUI();
        [self playMusic];
        CGFloat Id = [self.musicArray indexOfObject:self.player.currentItem];
        self.updateCurrentMusicId(Id);
    }];
}

//下一首
-(void)nextSong{
    [self.player.currentItem seekToTime:(kCMTimeZero) completionHandler:^(BOOL finished) {
       
        if (self.playerType == AVPlayerTypeNormal) {
            //判断当前歌曲是否是最后一首歌曲，如果是跳转到第一首歌
            if ([self.musicArray indexOfObject:self.player.currentItem]+1 == self.musicArray.count) {
                [self.player replaceCurrentItemWithPlayerItem:self.musicArray.firstObject];
            }else{
                [self.player replaceCurrentItemWithPlayerItem:self.musicArray[[self.musicArray  indexOfObject:self.player.currentItem]+1]];
            }
            
        }else if (self.playerType == AVPlayerTypeRandom){
          [self.player replaceCurrentItemWithPlayerItem:self.musicArray[arc4random_uniform((int)self.musicArray.count)]];
        }else if (self.playerType == AVPlayerTypeSingle){
            [self.player replaceCurrentItemWithPlayerItem:self.musicArray[[self.musicArray  indexOfObject:self.player.currentItem]]];
        }
        self.updatePlayBtnUI();
        [self playMusic];
        CGFloat Id = [self.musicArray indexOfObject:self.player.currentItem];
        self.updateCurrentMusicId(Id);
    }];
    
}

//播放指定url
- (void)musicPlayerWithURL:(NSURL *)playerItemURL {
    
    //创建要播放的资源
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:playerItemURL];
    //播放当前资源
    if(self.player.currentItem){
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
        self.updatePlayBtnUI();
    }else {
        self.player = [self.player initWithPlayerItem:playerItem];
    }
    [self playMusic];
}

//将slider的值传入使 歌曲进度 前进或后退
-(void)playerProgressWithProgressFloat:(CGFloat)progressFloat{
    //精确跳转
    CGFloat val = CMTimeGetSeconds(self.player.currentItem.duration);
    [self.player seekToTime:CMTimeMake(progressFloat*val, 1) toleranceBefore:CMTimeMake(1, 1000) toleranceAfter:CMTimeMake(1, 1000)];
}

//播放指定url的歌曲
- (void)musicPlayerWithArray:(NSArray *)musicArray andIndex:(NSInteger )index{
    [self.musicArray removeAllObjects];
    for (NSURL * obj in musicArray) {
        AVPlayerItem *songItem = [[AVPlayerItem alloc] initWithURL:obj];
        [self.musicArray addObject:songItem];
    }
    //播放歌单列表序号对应的歌曲
    //播放当前资源
    if(self.player.currentItem){
        [self.player replaceCurrentItemWithPlayerItem:self.musicArray[index]];
        self.updatePlayBtnUI();
    }else {
        self.player = [self.player initWithPlayerItem:self.musicArray[index]];
    }
    [self playMusic];
}

- (NSTimeInterval)totalTime {
    CMTime totalTime = self.player.currentItem.duration;
    NSTimeInterval sec = CMTimeGetSeconds(totalTime);
    if (isnan(sec)) {
        return 0;
    }
    return sec;
}

- (NSTimeInterval)currentTime {
    CMTime currentTime = self.player.currentItem.currentTime;
    NSTimeInterval sec = CMTimeGetSeconds(currentTime);
    if (isnan(sec)) {
        return 0;
    }
    return sec;
}

#pragma mark - getter setter 懒加载
- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}

- (NSMutableArray *)musicArray {
    if(!_musicArray) {
        _musicArray = [NSMutableArray array];
    }
    return _musicArray;
}

@end
