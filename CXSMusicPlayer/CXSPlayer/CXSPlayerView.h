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
- (void)downLoadAndRemoveCurrentMusicSuccess:(BOOL)isDown;
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
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *singer;

@property (nonatomic) NSString *musicImage;

@end

@interface CXSPlayerView : UIView

//class
@property(nonatomic, weak) id<CXSPlayVCActionProcotol> delegate;

@property(nonatomic) CXSPlayerViewModel *model;

@property (nonatomic, strong) UILabel *lyricsLabel;  //歌词

- (instancetype)initWithModel:(CXSPlayerViewModel*)model;
- (void)setSliderValue:(CGFloat)value;
- (void)setTimeLabelWithTotal:(NSTimeInterval)totalTime current:(NSTimeInterval)currentTime;

@end

NS_ASSUME_NONNULL_END
