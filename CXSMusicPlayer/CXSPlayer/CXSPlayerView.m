//
//  CXSPlayerView.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/4/8.
//

#import "CXSPlayerView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface CXSPlayerView()

@property (nonatomic) BOOL isLike;
@property (nonatomic) BOOL isDownLoad;
@property (nonatomic) NSInteger playType;
@property (nonatomic) BOOL isPlay;


@property (nonatomic, strong) UIButton *likeBtn;  //喜欢按钮
@property (nonatomic, strong) UIButton *downLoadBtn; //下载按钮
@property (nonatomic, retain) UISlider *musicSlider;  //进度条
@property (nonatomic, strong) UIButton *playTypeBtn;  //播放模式
@property (nonatomic, retain) UIButton *lastMusicBtn; //上一曲
@property (nonatomic, retain) UIButton *playPauseBtn; //播放暂停
@property (nonatomic, retain) UIButton *nextMusicBtn; //下一曲
@property (nonatomic, retain) UIButton *currentMusicListBtn; //当前播放歌单列表



@end

@implementation CXSPlayerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initDefaultInfo];
        [self addAllSubViews];
        [self layOutAllSubViews];
    }
    return self;
}

#pragma mark - private
- (void)initDefaultInfo {
    self.backgroundColor = [UIColor grayColor];
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _isLike = NO;
    _isDownLoad = NO;
    _playTypeBtn = 0;
    _isPlay = YES;
}

- (void)addAllSubViews {
    [self addSubview:self.likeBtn];
    [self addSubview:self.downLoadBtn];
    [self addSubview:self.musicSlider];
    [self addSubview:self.playTypeBtn];
    [self addSubview:self.lastMusicBtn];
    [self addSubview:self.playPauseBtn];
    [self addSubview:self.nextMusicBtn];
    [self addSubview:self.currentMusicListBtn];
}

- (void)layOutAllSubViews {
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(50);
        make.top.mas_equalTo(self).offset(550);
    }];
    [self.downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-50);
        make.centerY.equalTo(self.likeBtn);
    }];
    [self.musicSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.likeBtn.mas_bottom).offset(30);
        make.width.mas_offset(kScreenWidth - 100);
        make.height.mas_offset(20);
    }];
    
    [self.playPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.musicSlider.mas_bottom).offset(30);
    }];
    
    [self.lastMusicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.playPauseBtn);
        make.right.mas_equalTo(self.playPauseBtn.mas_left).offset(-40);
    }];
    [self.nextMusicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.playPauseBtn);
        make.left.mas_equalTo(self.playPauseBtn.mas_right).offset(40);
    }];
    [self.playTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.playPauseBtn);
        make.right.mas_equalTo(self.lastMusicBtn.mas_left).offset(-50);
    }];
    [self.currentMusicListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.playPauseBtn);
        make.left.mas_equalTo(self.nextMusicBtn.mas_right).offset(50);
    }];
}

#pragma mark - public
- (void)setSliderValue:(CGFloat)value {
    self.musicSlider.value = value;
}


#pragma mark - action
//喜欢按钮点击
- (void)didLikeButtonClick {
    _isLike = !_isLike;
    if(_isLike) {
        [_likeBtn setBackgroundImage:[UIImage imageNamed:@"play_icn_loved"] forState:UIControlStateNormal];
    } else {
        [_likeBtn setBackgroundImage:[UIImage imageNamed:@"play_icn_love"] forState:UIControlStateNormal];
    }
    //other option
    [self.delegate changeLikeMode:_isLike];
}

//下载按钮点击
- (void)didDownLoadButtonClick {
    _isDownLoad = !_isDownLoad;
    if(_isDownLoad) {
        [_downLoadBtn setBackgroundImage:[UIImage imageNamed:@"play_bar_downloaded"] forState:UIControlStateNormal];
    } else {
        [_downLoadBtn setBackgroundImage:[UIImage imageNamed:@"play_bar_download"] forState:UIControlStateNormal];
    }
    //other option
    [self.delegate downLoadCurrentMusic];
    
}

//进度条拖动
- (void)sliderDidImpress:(UISlider *)silder {
    CGFloat current = silder.value;
    [self.delegate changeSilder:current];
}

//播放模式按钮点击
- (void)didPlayTypeButtonClick {
    //切换下一个
    _playType = (_playType+1)%3;
    
    if(_playType == 0) {
        [_playTypeBtn setBackgroundImage:[UIImage imageNamed:@"play_icn_loop"] forState:UIControlStateNormal];
    }else if(_playType == 1) {
        [_playTypeBtn setBackgroundImage:[UIImage imageNamed:@"play_icn_random"] forState:UIControlStateNormal];
    }else if(_playType == 2) {
        [_playTypeBtn setBackgroundImage:[UIImage imageNamed:@"play_icn_one"] forState:UIControlStateNormal];
    }
    //other option
    [self.delegate changePlayerMode:_playType];
}

//上一曲按钮点击
- (void)didLastMusicButtonClick {
    //播放上一曲
    [self.delegate playLastMusic];
}

//播放/暂停按钮点击
- (void)didPlayPauseButtonClick {
    _isPlay = !_isPlay;
    if(_isPlay){
        [_playPauseBtn setBackgroundImage:[UIImage imageNamed:@"play_btn_pause"] forState:UIControlStateNormal];
    }else {
        [_playPauseBtn setBackgroundImage:[UIImage imageNamed:@"play_btn_play"] forState:UIControlStateNormal];
    }
    //other option
    [self.delegate playPauseMusic:_isPlay];
}

//下一曲按钮点击
- (void)didNextMusicButtonClick {
   //播放下一曲
    [self.delegate playNextMusic];
}

//歌单按钮点击
- (void)didMusicListButtonClick {
    //other option
    [self.delegate showCurrentMusicList];
}


#pragma mark - setter getter
- (UIButton *)likeBtn {
    if(!_likeBtn) {
        _likeBtn = [[UIButton alloc] init];
        _likeBtn.backgroundColor = [UIColor clearColor];
        [_likeBtn addTarget:self action:@selector(didLikeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_likeBtn setBackgroundImage:[UIImage imageNamed:@"play_icn_love"] forState:UIControlStateNormal];
    }
    return _likeBtn;
}

- (UIButton *)downLoadBtn {
    if(!_downLoadBtn) {
        _downLoadBtn = [[UIButton alloc] init];
        _downLoadBtn.backgroundColor = [UIColor clearColor];
        [_downLoadBtn addTarget:self action:@selector(didDownLoadButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_downLoadBtn setBackgroundImage:[UIImage imageNamed:@"play_bar_download"] forState:UIControlStateNormal];
    }
    return _downLoadBtn;
}

//进度条
- (UISlider *)musicSlider {
    if(!_musicSlider) {
        _musicSlider = [[UISlider alloc] init];
        _musicSlider.minimumValue = 0.0;
        _musicSlider.maximumValue = 1.0;
        [_musicSlider addTarget:self action:@selector(sliderDidImpress:) forControlEvents:UIControlEventValueChanged];
    }
    return _musicSlider;
}


//播放模式
- (UIButton *)playTypeBtn {
    if(!_playTypeBtn) {
        _playTypeBtn = [[UIButton alloc] init];
        _playTypeBtn.backgroundColor = [UIColor clearColor];
        [_playTypeBtn addTarget:self action:@selector(didPlayTypeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_playTypeBtn setBackgroundImage:[UIImage imageNamed:@"play_icn_loop"] forState:UIControlStateNormal];
    }
    return _playTypeBtn;
}

//上一曲
- (UIButton *)lastMusicBtn {
    if(!_lastMusicBtn) {
        _lastMusicBtn = [[UIButton alloc] init];
        _lastMusicBtn.backgroundColor = [UIColor clearColor];
        [_lastMusicBtn addTarget:self action:@selector(didLastMusicButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_lastMusicBtn setBackgroundImage:[UIImage imageNamed:@"play_btn_prev"] forState:UIControlStateNormal];
    }
    return _lastMusicBtn;
}

//播放暂停
- (UIButton *)playPauseBtn {
    if(!_playPauseBtn) {
        _playPauseBtn = [[UIButton alloc] init];
        _playPauseBtn.backgroundColor = [UIColor clearColor];
        [_playPauseBtn addTarget:self action:@selector(didPlayPauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_playPauseBtn setBackgroundImage:[UIImage imageNamed:@"play_btn_pause"] forState:UIControlStateNormal];
    }
    return _playPauseBtn;
}

//下一曲
- (UIButton *)nextMusicBtn {
    if(!_nextMusicBtn) {
        _nextMusicBtn = [[UIButton alloc] init];
        _nextMusicBtn.backgroundColor = [UIColor clearColor];
        [_nextMusicBtn addTarget:self action:@selector(didNextMusicButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_nextMusicBtn setBackgroundImage:[UIImage imageNamed:@"play_btn_next"] forState:UIControlStateNormal];
    }
    return _nextMusicBtn;
}

//歌单
- (UIButton *)currentMusicListBtn {
    if(!_currentMusicListBtn) {
        _currentMusicListBtn = [[UIButton alloc] init];
        _currentMusicListBtn.backgroundColor = [UIColor clearColor];
        [_currentMusicListBtn addTarget:self action:@selector(didMusicListButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_currentMusicListBtn setBackgroundImage:[UIImage imageNamed:@"play_icn_list"] forState:UIControlStateNormal];
    }
    return _currentMusicListBtn;
}

@end