//
//  CXSPlayerViewController.h
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/3/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXSPlayerViewController : UIViewController

+ (instancetype)shareViewController;
//播放在线音乐
- (void)playOnlineMusic;
//播放本地音乐
- (void)playLocalMusic;

@end

NS_ASSUME_NONNULL_END
