//
//  AVPlayerManager.h
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/3/16.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, playerType) {
    AVPlayerTypeNormal = 0,           //正常循环播放状态
    AVPlayerTypeRandom,                 //随机播放
    AVPlayerTypeSingle,                 //单曲循环
};

/**返回缓冲进度*/
typedef void(^loadTime)(NSString *str);
/**返回 当前进度、总时长、slider 最大值和当前值*/
typedef void(^returnTime)(NSString *current,NSString *total,float max,float value);
/**返回 AVPlayerItem的序号（换背景图、歌手、歌曲）*/
typedef void(^returnImage)(NSInteger index);

@interface AVPlayerManager : NSObject

/**存放AVplayerItem的数组*/
@property(nonatomic,strong)NSMutableArray *musicArray;

//**歌曲地址数组*/
@property(nonatomic,strong)NSMutableArray *songArray;// 是否进入的已存在的歌单！
/**海报数组*/
@property(nonatomic,strong)NSMutableArray *imageArray;
/**歌手数组*/
@property(nonatomic,strong)NSMutableArray *singerArray;
/**歌曲名数组*/
@property(nonatomic,strong)NSMutableArray *songNameArray;

/**AVPlayer播放器*/
@property (nonatomic, strong) AVPlayer *player;

/**播放模式*/
@property (nonatomic,assign) NSInteger playerType;

/**当前播放时间*/
@property(nonatomic,assign) float currentPlayTime;
/**当前缓冲时间*/
@property(nonatomic,assign)NSTimeInterval currentLoadTime;

/**slider最大值*/
@property(nonatomic,assign) float silderMaxValue;
/**slider当前值*/
@property(nonatomic,assign) float silderValue;
/***/
@property(nonatomic,strong) NSString *playTime;
/**总时长*/
@property(nonatomic,strong) NSString *totalTime;
/**缓冲提示*/
@property(nonatomic,strong) NSString *loadTime;

@property(nonatomic,strong)loadTime block;
@property(nonatomic,strong)returnTime block1;
@property(nonatomic,strong) returnImage block2;

/**通知 获取当前播放状态 控制按钮状态*/
@property(nonatomic,strong) NSNotificationCenter * center;
/**判断是否是从歌单列表进入播放器 还是 直接在进入播放器*/
@property(nonatomic,assign) BOOL listInto;


+ (instancetype)shareManager;
//**播放*/
- (void)musicPlayerWithArray:(NSArray *)musicArray andIndex:(NSInteger )index;
//**正在播放时   播放指定歌曲， */
- (void)musicPlayerWithIndex:(NSInteger )index;
//*播放
-(void)playMusic;
//*暂停
-(void)pasueMusic;
//**下一首*/
- (void)nextSong;
//**上一首*/
- (void)lastSong;
//**进度条 调节 */
- (void)playerProgressWithProgressFloat:(CGFloat)progressFloat;

//**移除观察者*/
-(void)removeObserver;

/**获取当前播放序号*/
-(NSInteger )getcurrentItem;

@end

NS_ASSUME_NONNULL_END
