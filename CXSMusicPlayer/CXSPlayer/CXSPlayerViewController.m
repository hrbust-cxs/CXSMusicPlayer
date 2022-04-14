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

const NSString *urlPreString = @"https://music-info-1302643497.cos.ap-guangzhou.myqcloud.com/music";

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
    __weak typeof(self) weakSelf = self;
    self.playerManager.setSliderValue = ^(CGFloat value) {
        __strong typeof(self) strongSelf = weakSelf;
        [self.playView setSliderValue:value];
    };
    self.playerManager.updatePlayBtnUI = ^{
        self.playView.model.isPlay = YES;
    };
}

#pragma mark - CXSPlayVCActionProcotol
- (void)changeLikeMode:(BOOL)isLike {
    //option
}

- (BOOL)downLoadCurrentMusicSuccess:(BOOL)isDown {
    //option
    NSString *idString = @"1.mp3";
    if(!isDown){
        //下载
        NSURL *url = [NSURL URLWithString:@"https://music-info-1302643497.cos.ap-guangzhou.myqcloud.com/music/song/1.mp3"];
        //获取document路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *pathDocuments = [paths objectAtIndex:0];
        NSString *path = [NSString stringWithFormat:@"%@/%@", pathDocuments,idString];
        if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [SVProgressHUD showWithStatus:@"文件已存在"];
            [SVProgressHUD dismissWithDelay:0.5 completion:nil];
            return NO;
        }
        [self downLoadMusicMP3WithURL:url];
        return YES;
        
    }else{
        //删除
        return NO;
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
            [SVProgressHUD showSuccessWithStatus:@"下载成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"下载失败"];
        }
        [SVProgressHUD dismissWithDelay:0.4 completion:nil];
    }];
    [downloadTask resume];
}


#pragma mark - private
- (void)playMusic {
    NSMutableArray *musicArray = [NSMutableArray array];
    for(int i = 0; i < 3; i ++) {
        NSString *string = [NSString stringWithFormat:@"%@/song/%d.mp3",urlPreString,i];
        NSURL *url = [NSURL URLWithString:string];
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
        CXSPlayerViewModel *model = [[CXSPlayerViewModel alloc] init];
        model.isLike = NO;
        model.isDownLoad = NO;
        model.playType = 0;
        model.isPlay = YES;
        _playView = [[CXSPlayerView alloc] initWithModel:model];
        _playView.delegate = self;
        //添加监听
    }
    return _playView;
}

@end
