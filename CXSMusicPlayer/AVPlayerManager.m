//
//  AVPlayerManager.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/3/16.
//

#import "AVPlayerManager.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation AVPlayerManager
{
    id timeObserve;// 为 当前AVPlayerItem 添加观察者获取各种播放状态
}

+(instancetype)shareManager{
    static AVPlayerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AVPlayerManager new];
    });
    return manager;
}

-(instancetype)init{
    if (self =[super init]) {
        _playerType = AVPlayerTypeNormal;
    }
    return self;
}

//播放器懒加载
-(AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}

-(NSMutableArray *)musicArray{
    if (!_musicArray) {
        _musicArray = [NSMutableArray array];
        
        _center = [NSNotificationCenter defaultCenter];
    }
    return _musicArray;
}

//播放指定url
- (void)musicPlayerWithURL:(NSURL *)playerItemURL{
    
    //创建要播放的资源
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:playerItemURL];
    //添加观察者
    //播放当前资源
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
}


-(void)musicPlayerWithIndex:(NSInteger)index{
     // 播放AVPlayerItem数组中指定序号歌曲 (此操作之前需要将上一个item 的 观察者移除 并将 seekTime 设置为0 确保下次播放从头开始)
    [self.player replaceCurrentItemWithPlayerItem:self.musicArray[index]];
    
    self.block2([self.musicArray indexOfObject:self.player.currentItem]);
    
    [self addObserver];
    
}

//重新添加新的歌单列表进来
- (void)musicPlayerWithArray:(NSArray *)musicArray andIndex:(NSInteger )index{
    //首先移除之前的歌单列表 再 重新添加
    [self.songArray removeAllObjects];
    [self.songArray addObjectsFromArray:musicArray];
    
    for (NSString * obj in musicArray) {
        AVPlayerItem *songItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:obj]];
        [self.musicArray addObject:songItem];
    }
    //播放歌单列表序号对应的歌曲
    [self.player replaceCurrentItemWithPlayerItem:self.musicArray[index]];
    //对当前item 添加观察者
    [self addObserver];
}

//播放
-(void)playMusic{
    [self.player play];
}
//暂停
-(void)pasueMusic{
    [self.player pause];
}

//上一首
-(void)lastSong{
    
    [self removeObserver];//先移除当前 观察者
    
    [self.player.currentItem seekToTime:(kCMTimeZero) completionHandler:^(BOOL finished) {
        
        if (self.playerType == AVPlayerTypeNormal) {//顺序循环播放
            //判断当前歌曲是否是第一首歌曲，如果是跳转到最后一首歌
            if ([self.musicArray indexOfObject:self.player.currentItem] ==0) {
                [self.player replaceCurrentItemWithPlayerItem:self.musicArray.lastObject];
            }else{
                [self.player replaceCurrentItemWithPlayerItem:self.musicArray[[self.musicArray  indexOfObject:self.player.currentItem]-1]];
            }
            
        }else if (self.playerType == AVPlayerTypeRandom){//随机播放
            NSInteger random = arc4random_uniform((int)self.musicArray.count);
            NSLog(@"%ld",random);
            
            [self.player replaceCurrentItemWithPlayerItem:self.musicArray[arc4random_uniform((int)self.musicArray.count)]];
        }else if (self.playerType ==AVPlayerTypeSingle){ //单曲循环在自动切换歌曲时进行判断
            //判断当前歌曲是否是第一首歌曲，如果是跳转到最后一首歌
            if ([self.musicArray indexOfObject:self.player.currentItem] ==0) {
                [self.player replaceCurrentItemWithPlayerItem:self.musicArray.lastObject];
            }else{
                [self.player replaceCurrentItemWithPlayerItem:self.musicArray[[self.musicArray  indexOfObject:self.player.currentItem]-1]];
            }
        }
        
        [self playMusic];
        //放回对应歌曲的信息
         self.block2([self.musicArray indexOfObject:self.player.currentItem]);
        [self addObserver];//添加观察者
    }];
}
//下一首
-(void)nextSong{
    [self removeObserver];
    
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
            //判断当前歌曲是否是最后一首歌曲，如果是跳转到第一首歌
            if ([self.musicArray indexOfObject:self.player.currentItem]+1 == self.musicArray.count) {
                [self.player replaceCurrentItemWithPlayerItem:self.musicArray.firstObject];
            }else{
                [self.player replaceCurrentItemWithPlayerItem:self.musicArray[[self.musicArray  indexOfObject:self.player.currentItem]+1]];
            }
        }
        
        [self playMusic];
        self.block2([self.musicArray indexOfObject:self.player.currentItem]);
        [self addObserver];
    }];
    
}

//获取 当前播放歌曲在AVPlayerItem中的 序号
-(NSInteger )getcurrentItem{
    return [self.musicArray indexOfObject:self.player.currentItem];
}

//将slider的值传入使 歌曲进度 前进或后退
-(void)playerProgressWithProgressFloat:(CGFloat)progressFloat{
    if (progressFloat > self.currentLoadTime) {
        NSDictionary *dict = @{@"播放状态":@0};
        [self.center postNotificationName:@"playOrPasue" object:self userInfo:dict];
    }
    [self.player seekToTime:CMTimeMake(progressFloat, 1.0)];
}

//接受播放完成的通知 开始下一首
- (void)playbackFinished:(NSNotification *)notice {
    //判断是否是单曲循环  是的话 移除观察者 将当前进度调为0 重新播放
    if (self.playerType == AVPlayerTypeSingle) {
        
       [self removeObserver];
       [self.player.currentItem seekToTime:kCMTimeZero];
        
       [self musicPlayerWithIndex:[self getcurrentItem]];
       [self playMusic];
    }else{
       [self nextSong];
    }
    
}

//为当前播放的item 添加观察者
-(void)addObserver{
    __weak typeof(self) weekSelf = self;
    __weak AVPlayer *weekPlayer = self.player;
    
    //观察该item 是否能播放
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //观察该item 加载进度
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    //AVPlayer 自带方法：返回歌曲 播放进度 信息
    timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        [weekSelf updateLockedScreenMusic:[weekSelf getcurrentItem]];
        
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(weekPlayer.currentItem.duration);
        weekSelf.currentPlayTime = current;
        if (total > 0) {
            weekSelf.silderMaxValue = total;
        }else{
            weekSelf.silderMaxValue = 300;
        };
        weekSelf.silderValue = current;

        if (current) {
            weekSelf.playTime =[weekSelf timetranstation:[NSString stringWithFormat:@"%.f",current]];
            weekSelf.totalTime =[weekSelf timetranstation:[NSString stringWithFormat:@"%.f",total]];
            
            //判断歌曲播完 后发出通知 -132行 接受通知
            if (current == total) { //    total - current <=1  有时会导致不能正常切换歌曲
                [[NSNotificationCenter defaultCenter] addObserver:weekSelf selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:weekPlayer.currentItem];
            }
            
            //返回 播放界面所需要的内容。
            weekSelf.block1(weekSelf.playTime,weekSelf.totalTime,weekSelf.silderMaxValue,weekSelf.silderValue);
        }
    }];
}

//移除对当前item 的观察 通知
-(void)removeObserver{
    if (timeObserve) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        [self.player removeTimeObserver:timeObserve];
        
    }
}

//观察者
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    AVPlayerItem * songItem = object;
    NSDictionary *dict = @{@"播放状态":@1};
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
                //  BASE_INFO_FUN(@"KVO：未知状态，此时不能播放");
                break;
            case AVPlayerStatusReadyToPlay:
                // self.status = SUPlayStatusReadyToPlay;
                //  BASE_INFO_FUN(@"KVO：准备完毕，可以播放");
                [self.center postNotificationName:@"playOrPasue" object:self userInfo:dict];
                [self.player play];
                break;
            case AVPlayerStatusFailed:
                //  BASE_INFO_FUN(@"KVO：加载失败，网络或者服务器出现问题");
                break;
            default:
                break;
        }
    }else  if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray * array = songItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
        self.currentLoadTime = totalBuffer;
        
        float total = CMTimeGetSeconds(songItem.duration);
      //  NSLog(@"共缓冲%.0f％",totalBuffer/total*100); 计算缓冲进度
        self.loadTime =[NSString stringWithFormat:@"正在缓冲%.0f％",totalBuffer/total*100];
        if ([[NSString stringWithFormat:@"%.0f",totalBuffer/total*100] isEqualToString:@"100"]) {
            self.loadTime =@"";
        }else{
            self.loadTime =[NSString stringWithFormat:@"正在缓冲%.0f％",totalBuffer/total*100];
        }
        CGFloat currentPlayTime =  self.currentPlayTime;
       
        //缓冲完成时间大于当前播放时间5s时通知播放器继续播放 否则暂停
        if (totalBuffer > currentPlayTime +5) {
//            NSDictionary *dict = @{@"播放状态":@1};
//            [self.center postNotificationName:@"playOrPasue" object:self userInfo:dict];
        }else{
            NSDictionary *dict = @{@"播放状态":@0};
            [self.center postNotificationName:@"playOrPasue" object:self userInfo:dict];
        }
        
        NSLog(@"%f ----%f",total,totalBuffer);
        if (totalBuffer + 1 > total) {
            NSDictionary *dict = @{@"播放状态":@1};
            [self.center postNotificationName:@"playOrPasue" object:self userInfo:dict];
        }
        self.block(self.loadTime);
    }
}

#pragma 秒数转为分钟
-(NSString *)timetranstation:(NSString *)time{
    NSString *returnTime =[NSString string];
    NSInteger total = [time integerValue];
    
    returnTime =[NSString stringWithFormat:@"%02ld:%02ld",total/60,total%60];
    return returnTime;
}


#pragma mark - 锁屏时候的设置，效果需要在真机上才可以看到
- (void)updateLockedScreenMusic:(NSInteger )index{
    // 播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    // 初始化播放信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 专辑名称
//    info[MPMediaItemPropertyAlbumTitle] = [sel];
    // 歌手
    info[MPMediaItemPropertyArtist] = self.singerArray[index];
    // 歌曲名称
    info[MPMediaItemPropertyTitle] =  self.songNameArray[index];
    // 设置图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageArray[index]]]]]];
    // 设置持续时间（歌曲的总时间）
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.player.currentItem duration])] forKey:MPMediaItemPropertyPlaybackDuration];
    // 设置当前播放进度
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.player.currentItem currentTime])] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    // 切换播放信息
    center.nowPlayingInfo = info;
    
}

@end
