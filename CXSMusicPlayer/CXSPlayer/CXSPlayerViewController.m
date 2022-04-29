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

const NSString *urlPreString = @"https://music-info-1302643497.cos.ap-guangzhou.myqcloud.com/music";

@interface CXSPlayerViewController () <CXSPlayVCActionProcotol>

@property (nonatomic, strong)CXSPlayerView *playView;
@property (nonatomic, strong)CXSPlayerManager *playerManager;

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
    };
    self.playerManager.updatePlayBtnUI = ^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.playView.model.isPlay = YES;
    };
    self.playerManager.updateCurrentMusicId = ^(CGFloat Id) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.currentId = Id;
        [strongSelf updatePlayViewTitle];
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
        }
        [self downLoadMusicMP3WithURL:url];
        
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
}

#pragma mark - private
- (void)updatePlayViewTitle {
    CXSSong *songInfo = self.infoArray[self.currentId];
    self.playView.model.name = songInfo.name;
    self.playView.model.singer = songInfo.singer;
    [self updateImageView:songInfo.id];
    
}

- (void)updateImageView:(int)Id {
    NSString *idString = [NSString stringWithFormat:@"%d.jpg",Id];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathDocuments = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@", pathDocuments,idString];
    //sdwebimage 异步缓存
    self.playView.model.musicImage = [NSString stringWithFormat:@"%@/image/%d.jpg",urlPreString,Id];
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

@end
