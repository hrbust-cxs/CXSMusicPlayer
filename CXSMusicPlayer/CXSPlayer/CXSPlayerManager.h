//
//  CXSPlayerManager.h
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/3/23.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, playerType) {
    AVPlayerTypeNormal = 0,           //正常循环播放状态
    AVPlayerTypeRandom = 1,                 //随机播放
    AVPlayerTypeSingle = 2,                 //单曲循环
};

@interface CXSPlayerManager : NSObject

@property (nonatomic) void(^setSliderValue)(CGFloat value);

//AVPlayer播放器
@property (nonatomic, strong) AVPlayer *player;
//存放AVplayerItem的数组
@property(nonatomic,strong) NSMutableArray *musicArray;
//播放模式
@property (nonatomic,assign) NSInteger playerType;

//单例
+ (instancetype)shareManager;
//播放音乐
- (void)playMusic;
//暂停
- (void)pasueMusic;
//下一首
- (void)nextSong;
//上一首
- (void)lastSong;
//播放制定url的歌曲
- (void)musicPlayerWithURL:(NSURL *)playerItemURL;
//修改进度
- (void)playerProgressWithProgressFloat:(CGFloat)progressFloat;
//播放musicArray的制定index
- (void)musicPlayerWithArray:(NSArray *)musicArray andIndex:(NSInteger )index;

@end

NS_ASSUME_NONNULL_END
