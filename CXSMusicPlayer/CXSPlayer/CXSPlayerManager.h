//
//  CXSPlayerManager.h
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/3/23.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXSPlayerManager : NSObject

/**AVPlayer播放器*/
@property (nonatomic, strong) AVPlayer *player;


+ (instancetype)shareManager;

- (void)playMusic;
- (void)pasueMusic;
- (void)musicPlayerWithURL:(NSURL *)playerItemURL;
- (void)playerProgressWithProgressFloat:(CGFloat)progressFloat;

@end

NS_ASSUME_NONNULL_END
