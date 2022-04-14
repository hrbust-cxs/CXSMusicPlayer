//
//  CXSPlayerView.h
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/4/8.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

NS_ASSUME_NONNULL_BEGIN

//protocol
@protocol CXSPlayVCActionProcotol <NSObject>

- (void)changeLikeMode:(BOOL)isLike;
- (BOOL)downLoadCurrentMusicSuccess:(BOOL)isDown;
- (void)changeSilder:(CGFloat)value;
- (void)changePlayerMode:(NSInteger)type;
- (void)playLastMusic;
- (void)playPauseMusic:(BOOL)isPlay;
- (void)playNextMusic;
- (void)showCurrentMusicList;

@end

//model
@interface CXSPlayerViewModel : NSObject

@property (nonatomic) BOOL isLike;
@property (nonatomic) BOOL isDownLoad;
@property (nonatomic) NSInteger playType;
@property (nonatomic) BOOL isPlay;

@end

@interface CXSPlayerView : UIView

//class
@property(nonatomic, weak) id<CXSPlayVCActionProcotol> delegate;

@property(nonatomic) CXSPlayerViewModel *model;

- (instancetype)initWithModel:(CXSPlayerViewModel*)model;
- (void)setSliderValue:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
