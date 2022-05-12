//
//  CXSPlayerViewController.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/3/22.
//

#import "CXSPlayerViewController.h"
#import "CXSPlayerManager.h"
#import "CXSPlayerView.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "CXSCoreDataManager.h"
#import "CXSLrcParser.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import <MediaPlayer/MediaPlayer.h>

const NSString *urlPreString = @"https://music-info-1302643497.cos.ap-guangzhou.myqcloud.com/music";

@interface CXSPlayerViewController () <CXSPlayVCActionProcotol>

@property (nonatomic, strong)CXSPlayerView *playView;
@property (nonatomic, strong)CXSPlayerManager *playerManager;
@property (nonatomic, strong)CXSLrcParser *lrcParser;

@property (nonatomic, strong)NSArray *infoArray;

//播放音乐必须的id数组和index
@property (nonatomic, strong)NSArray *idArray;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, assign)NSInteger currentId;

@end

@implementation CXSPlayerViewController

+ (instancetype)shareViewController {
    static CXSPlayerViewController *sharedVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedVC = [CXSPlayerViewController new];
    });
    return sharedVC;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initDefault];
}

- (void)initDefault {
    [self getCoreDataInfo];
    [self.view addSubview:self.playView];
    __weak typeof(self) weakSelf = self;
    self.playerManager.setSliderValue = ^(CGFloat value) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.playView setSliderValue:value];
        NSTimeInterval totalTime = [strongSelf.playerManager totalTime];
        NSTimeInterval currentTime = [strongSelf.playerManager currentTime];
        [strongSelf.playView setTimeLabelWithTotal:totalTime current:currentTime];
        // 展示歌词
        [strongSelf showCurrentLRC];
    };
    self.playerManager.updatePlayBtnUI = ^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.playView.model.isPlay = YES;
        strongSelf.playView.lyricsLabel.text = @"暂无歌词";
    };
    self.playerManager.updateCurrentMusicId = ^(CGFloat Id) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.currentId = [[strongSelf.idArray objectAtIndex:Id] intValue];
        [strongSelf updatePlayViewTitle];
        [strongSelf setupLockScreenInfo];
    };
}

#pragma mark - coreData request
- (void)getCoreDataInfo {
//    [[CXSCoreDataManager sharedManager] addSongWithInfo:1 name:@"cccccc" singer:@"chenxinshuang"];
    self.infoArray = [[CXSCoreDataManager sharedManager] getSongInfo];
    self.idArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"CXSIDArray"];
    self.index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CXSIndex"] intValue];
    self.currentId = [[self.idArray objectAtIndex:self.index] intValue];
}

#pragma mark - CXSPlayVCActionProcotol
- (void)changeLikeMode:(BOOL)isLike {
    //option
    NSMutableDictionary *lovedDic = [NSMutableDictionary dictionary];
    lovedDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CXSLovedDictionary"] mutableCopy];
    [lovedDic setObject:isLike?@(1):@(0) forKey:[NSString stringWithFormat:@"%ld",(long)self.currentId]];
    [[NSUserDefaults standardUserDefaults] setObject:lovedDic forKey:@"CXSLovedDictionary"];
}

- (void)downLoadAndRemoveCurrentMusicSuccess:(BOOL)isDown {
    //option
    int musicId = self.currentId;
    NSString *idString = [NSString stringWithFormat:@"%d.mp3",musicId];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathDocuments = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@", pathDocuments,idString];
    
    if(!isDown){
        //下载
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/song/%@",urlPreString,idString]];
        //获取document路径
        if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [SVProgressHUD showWithStatus:@"文件已存在"];
            [SVProgressHUD dismissWithDelay:0.5 completion:nil];
            self.playView.model.isDownLoad = NO;
        }else{
            [self downLoadMusicMP3WithURL:url];
        }
    }else{
        //删除
        if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            self.playView.model.isDownLoad = NO;
            [SVProgressHUD showWithStatus:@"文件删除成功"];
        }else{
            [SVProgressHUD showWithStatus:@"文件不存在，删除失败"];
        }
        [SVProgressHUD dismissWithDelay:0.5 completion:nil];
    }
    //设置是否下载的
    NSMutableDictionary *localDic = [NSMutableDictionary dictionary];
    localDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CXSLocalDictionary"] mutableCopy];
    [localDic setObject:isDown?@(0):@(1) forKey:[NSString stringWithFormat:@"%ld",(long)self.currentId]];
    [[NSUserDefaults standardUserDefaults] setObject:localDic forKey:@"CXSLocalDictionary"];
}

- (void)changeSilder:(CGFloat)value {
    //option
    [self.playerManager playerProgressWithProgressFloat:value];
    [self setupLockScreenInfo];
}

- (void)changePlayerMode:(NSInteger)type {
    self.playerManager.playerType = type;
}

- (void)playLastMusic {
    [self.playerManager lastSong];
}

- (void)playPauseMusic:(BOOL)isPlay {
    self.playView.model.isPlay = !isPlay;
    if(!isPlay){
        [self.playerManager playMusic];
    }else {
        [self.playerManager pasueMusic];
    }
    [self setupLockScreenInfo];
}

- (void)playNextMusic {
    [self.playerManager nextSong];
}

- (void)showCurrentMusicList {
    //option
   
}

#pragma mark - AFNetWorking 下载
- (void)downLoadMusicMP3WithURL:(NSURL*)url {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
        //        这个block里面获取下载进度
        [SVProgressHUD showProgress:(CGFloat)downloadProgress.completedUnitCount/(CGFloat)downloadProgress.totalUnitCount status:@"下载中"];
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //        这个block里面返回下载文件存放路径
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        return url;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //        这个block里面拿到下载结果
        NSData *data = [NSData dataWithContentsOfURL:filePath];
        if(data){
            self.playView.model.isDownLoad = YES;
            [SVProgressHUD showSuccessWithStatus:@"下载成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"下载失败"];
        }
        [SVProgressHUD dismissWithDelay:0.4 completion:nil];
    }];
    [downloadTask resume];
}

- (void)downLoadMusicLRCWithURL:(NSURL*)url {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
        //        这个block里面获取下载进度
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        //        这个block里面返回下载文件存放路径
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        return url;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //        这个block里面拿到下载结果
        NSLog(@"%@",filePath);
    }];
    [downloadTask resume];
}

#pragma mark - public
- (void)playOnlineMusic {
    int musicId = -1;
    NSMutableArray *musicArray = [NSMutableArray array];
    for(int i = 0; i < self.idArray.count; i ++) {
        musicId = [[self.idArray objectAtIndex:i] intValue];
        NSString *string = [NSString stringWithFormat:@"%@/song/%d.mp3",urlPreString,musicId];
        NSURL *url = [NSURL URLWithString:string];
        [musicArray addObject:url];
    }
    [self.playerManager musicPlayerWithArray:musicArray andIndex:self.index];
    [self updatePlayViewTitle];
    [self setupLockScreenInfo];
}

- (void)playLocalMusic {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathDocuments = [paths objectAtIndex:0];
    
    int musicId = -1;
    NSMutableArray *musicArray = [NSMutableArray array];
    for(int i = 0; i < self.idArray.count; i ++) {
        musicId = [[self.idArray objectAtIndex:i] intValue];
        NSString *string = [NSString stringWithFormat:@"%@/%d.mp3",pathDocuments,musicId];
        NSURL *url = [NSURL fileURLWithPath:string];
        [musicArray addObject:url];
    }
    [self.playerManager musicPlayerWithArray:musicArray andIndex:self.index];
    [self updatePlayViewTitle];
    [self setupLockScreenInfo];
}

#pragma mark - private
- (void)updatePlayViewTitle {
    CXSSong *songInfo = self.infoArray[self.currentId];
    self.playView.model.name = songInfo.name;
    self.playView.model.singer = songInfo.singer;
    [self updateImageView:songInfo.id];
    [self updateLyricsWithSong:songInfo.id];
    NSMutableDictionary *lovedDic = [NSMutableDictionary dictionary];
    lovedDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CXSLovedDictionary"] mutableCopy];
    self.playView.model.isLike = [[lovedDic objectForKey:[NSString stringWithFormat:@"%ld",(long)self.currentId]] boolValue];
    NSMutableDictionary *localDic = [NSMutableDictionary dictionary];
    localDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"CXSLocalDictionary"] mutableCopy];
    self.playView.model.isDownLoad = [[localDic objectForKey:[NSString stringWithFormat:@"%ld",(long)self.currentId]] boolValue];
}

- (void)updateImageView:(int)Id {
    NSString *idString = [NSString stringWithFormat:@"%d.jpg",Id];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathDocuments = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@", pathDocuments,idString];
    //sdwebimage 异步缓存
    self.playView.model.musicImage = [NSString stringWithFormat:@"%@/image/%d.jpg",urlPreString,Id];
}

- (void)updateLyricsWithSong:(int)Id {
    NSString *idString = [NSString stringWithFormat:@"%d.lrc",Id];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathDocuments = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@", pathDocuments,idString];
    NSString *downLoadPath = [NSString stringWithFormat:@"%@/lyrics/%@", urlPreString,idString];
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        //存在
        NSLog(@"%@",path);
    }else{
        //不存在
        [self downLoadMusicLRCWithURL:[NSURL URLWithString:downLoadPath]];
        //延迟调用1s，下载完成并且获取到文件
        sleep(1);
    }
    //处理歌词文件
    NSString *lrcContent = [self.lrcParser getLrcFile:path];
    if([lrcContent isEqualToString:@"暂无歌词\n"]){
        self.playView.lyricsLabel.text = @"暂无歌词";
        [self.lrcParser removeAllArrayObject];
        return;
    }
    [self.lrcParser parseLrc:lrcContent];
}

- (void)showCurrentLRC {
    //本地文件路径：path 文件操作展示歌词
    float currentTime = [self.playerManager currentTime];
    NSLog(@"%d:%d",(int)currentTime / 60, (int)currentTime % 60);
    for (int i = 0; i < self.lrcParser.timerArray.count; i++) {
        NSArray *timeArray=[self.lrcParser.timerArray[i] componentsSeparatedByString:@":"];
        float lrcTime=[timeArray[0] intValue]*60+[timeArray[1] floatValue]; if(currentTime>lrcTime){
            self.playView.lyricsLabel.text = self.lrcParser.wordArray[i];
        }else
            break;
    }
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
        CXSPlayerViewModel *model = [[CXSPlayerViewModel alloc] init];
        model.isLike = NO;
        model.isDownLoad = NO;
        model.playType = 0;
        model.isPlay = YES;
        model.name = @"XXXX";
        model.singer = @"XXX";
        model.musicImage = @"https://music-info-1302643497.cos.ap-guangzhou.myqcloud.com/music/image/1.jpg";
        _playView = [[CXSPlayerView alloc] initWithModel:model];
        _playView.delegate = self;
        //添加监听
    }
    return _playView;
}

- (CXSLrcParser *)lrcParser {
    if(!_lrcParser){
        _lrcParser = [[CXSLrcParser alloc] init];
    }
    return _lrcParser;
}

#pragma mark - 锁屏信息
- (void)setupLockScreenInfo {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:self.playView.model.musicImage]];
        //获取缓存中的image
        UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
        if(!image){
            //缓存中不存在，使用https的
            NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:key]];
            image = [UIImage imageWithData:imageData];
        }
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeMake(512, 512) requestHandler:^UIImage * _Nonnull(CGSize size) {
            return image;
        }];
        //歌曲名称
        [songInfo setObject:self.playView.model.name forKey:MPMediaItemPropertyTitle];
        //演唱者
        [songInfo setObject:self.playView.model.singer forKey:MPMediaItemPropertyArtist];
        //专辑缩略图
        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        [songInfo setObject:[NSNumber numberWithDouble:self.playerManager.currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime]; //音乐当前已经播放时间
        [songInfo setObject:[NSNumber numberWithFloat:1.0] forKey:MPNowPlayingInfoPropertyPlaybackRate];//进度光标的速度
        [songInfo setObject:[NSNumber numberWithDouble:self.playerManager.totalTime] forKey:MPMediaItemPropertyPlaybackDuration];//歌曲总时间设置
     
        //        设置锁屏状态下屏幕显示音乐信息
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    });
}

@end
