//
//  CXSPlayerView.h
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/4/8.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CXSPlayVCActionProcotol <NSObject>

- (void)changeLikeMode:(BOOL)isLike;
- (void)downLoadCurrentMusic;
- (void)changeSilder:(CGFloat)value;
- (void)changePlayerMode:(NSInteger)type;
- (void)playLastMusic;
- (void)playPauseMusic:(BOOL)isPlay;
- (void)playNextMusic;
- (void)showCurrentMusicList;

@end

@interface CXSPlayerView : UIView

@property(nonatomic, weak) id<CXSPlayVCActionProcotol> delegate;

- (void)setSliderValue:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
