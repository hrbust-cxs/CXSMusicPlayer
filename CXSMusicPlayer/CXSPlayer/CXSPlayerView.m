//
//  CXSPlayerView.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/4/8.
//

#import "CXSPlayerView.h"
#import "UIImageView+WebCache.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation CXSPlayerViewModel

@end

@interface CXSPlayerView()

@property (nonatomic, strong) UILabel *nameLabel;  //歌名
@property (nonatomic, strong) UILabel *singerLabel; //歌手名

@property (nonatomic, strong) UIImageView *musicImageView; //海报图片

@property (nonatomic, strong) UIButton *likeBtn;  //喜欢按钮
@property (nonatomic, strong) UIButton *downLoadBtn; //下载按钮
@property (nonatomic, strong) UILabel *currentTimeLabel;  //当前时间
@property (nonatomic, retain) UISlider *musicSlider;  //进度条
@property (nonatomic, strong) UILabel *songTimeLabel;  //歌曲时长
@property (nonatomic, strong) UIButton *playTypeBtn;  //播放模式
@property (nonatomic, retain) UIButton *lastMusicBtn; //上一曲
@property (nonatomic, retain) UIButton *playPauseBtn; //播放暂停
@property (nonatomic, retain) UIButton *nextMusicBtn; //下一曲
@property (nonatomic, retain) UIButton *currentMusicListBtn; //当前播放歌单列表



@end

@implementation CXSPlayerView

- (instancetype)initWithModel:(CXSPlayerViewModel*)model
{
    self = [super init];
    if (self) {
        self.model = model;
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
    [self.model addObserver:self forKeyPath:@"isLike" options:NSKeyValueObservingOptionNew context:nil];
    [self.model addObserver:self forKeyPath:@"isDownLoad" options:NSKeyValueObservingOptionNew context:nil];
    [self.model addObserver:self forKeyPath:@"playType" options:NSKeyValueObservingOptionNew context:nil];
    [self.model addObserver:self forKeyPath:@"isPlay" options:NSKeyValueObservingOptionNew context:nil];
    [self.model addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    [self.model addObserver:self forKeyPath:@"singer" options:NSKeyValueObservingOptionNew context:nil];
    [self.model addObserver:self forKeyPath:@"musicImage" options:NSKeyValueObservingOptionNew context:nil];
    
    self.nameLabel.text = _model.name;
    self.singerLabel.text = _model.singer;
}

- (void)addAllSubViews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.singerLabel];
    [self addSubview:self.musicImageView];
    [self addSubview:self.lyricsLabel];
    [self addSubview:self.likeBtn];
    [self addSubview:self.downLoadBtn];
    [self addSubview:self.currentTimeLabel];
    [self addSubview:self.musicSlider];
    [self addSubview:self.songTimeLabel];
    [self addSubview:self.playTypeBtn];
    [self addSubview:self.lastMusicBtn];
    [self addSubview:self.playPauseBtn];
    [self addSubview:self.nextMusicBtn];
    [self addSubview:self.currentMusicListBtn];
}

- (void)layOutAllSubViews {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(self).offset(10);
        make.height.mas_offset(25);
    }];
    [self.singerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(4);
        make.height.mas_offset(16);
    }];
    [self.musicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(self).offset(80);
        make.width.height.mas_offset(380);
    }];
    [self.lyricsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.musicImageView);
        make.top.mas_equalTo(self.musicImageView.mas_bottom).offset(50);
        make.width.mas_offset(380);
        make.height.mas_offset(50);
    }];
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(50);
        make.top.mas_equalTo(self).offset(600);
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
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.musicSlider);
        make.right.mas_equalTo(self.musicSlider.mas_left).offset(-5);
        make.height.mas_offset(20);
    }];
    [self.songTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.musicSlider);
        make.left.mas_equalTo(self.musicSlider.mas_right).offset(5);
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

- (NSString*)stringWithNSTimeInterval:(NSTimeInterval)interval {
    NSInteger min = interval/60;
    NSInteger sec = (NSInteger)interval % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
}

#pragma mark - public
- (void)setSliderValue:(CGFloat)value {
    self.musicSlider.value = value;
}

- (void)setTimeLabelWithTotal:(NSTimeInterval)totalTime current:(NSTimeInterval)currentTime {
    self.currentTimeLabel.text = [self stringWithNSTimeInterval:currentTime];
    self.songTimeLabel.text = [self stringWithNSTimeInterval:totalTime];
}

#pragma mark - action
//喜欢按钮点击
- (void)didLikeButtonClick {
    self.model.isLike = !self.model.isLike;
    [self.delegate changeLikeMode:self.model.isLike];
}

//下载按钮点击
- (void)didDownDeleteLoadButtonClick {
    [self.delegate downLoadAndRemoveCurrentMusicSuccess:self.model.isDownLoad];
}

//进度条拖动
- (void)sliderDidImpress:(UISlider *)silder {
    CGFloat current = silder.value;
    [self.delegate changeSilder:current];
}

//播放模式按钮点击
- (void)didPlayTypeButtonClick {
    //切换下一个
    self.model.playType = (self.model.playType+1)%3;
    
    //other option
    [self.delegate changePlayerMode:self.model.playType];
}

//上一曲按钮点击
- (void)didLastMusicButtonClick {
    //播放上一曲
    [self.delegate playLastMusic];
}

//播放/暂停按钮点击
- (void)didPlayPauseButtonClick {
    self.model.isPlay = !self.model.isPlay;
    //other option
    [self.delegate playPauseMusic:self.model.isPlay];
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

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"isLike"]){
        if(self.model.isLike) {
            [_likeBtn setBackgroundImage:[UIImage imageNamed:@"play_icn_loved"] forState:UIControlStateNormal];
        } else {
            [_likeBtn setBackgroundImage:[UIImage imageNamed:@"play_icn_love"] forState:UIControlStateNormal];
        }
    }else if([keyPath isEqualToString:@"isDownLoad"]){
        if(self.model.isDownLoad > 0) {
            [_downLoadBtn setBackgroundImage:[UIImage imageNamed:@"play_bar_downloaded"] forState:UIControlStateNormal];
        } else {
            [_downLoadBtn setBackgroundImage:[UIImage imageNamed:@"play_bar_download"] forState:UIControlStateNormal];
        }
    }else if([keyPath isEqualToString:@"playType"]){
        if(self.model.playType == 0) {
            [_playTypeBtn setBackgroundImage:[UIImage imageNamed:@"play_icn_loop"] forState:UIControlStateNormal];
        }else if(self.model.playType == 1) {
            [_playTypeBtn setBackgroundImage:[UIImage imageNamed:@"play_icn_random"] forState:UIControlStateNormal];
        }else if(self.model.playType == 2) {
            [_playTypeBtn setBackgroundImage:[UIImage imageNamed:@"play_icn_one"] forState:UIControlStateNormal];
        }
    }else if([keyPath isEqualToString:@"isPlay"]){
        if(self.model.isPlay){
            [_playPauseBtn setBackgroundImage:[UIImage imageNamed:@"play_btn_pause"] forState:UIControlStateNormal];
        }else {
            [_playPauseBtn setBackgroundImage:[UIImage imageNamed:@"play_btn_play"] forState:UIControlStateNormal];
        }
    }else if([keyPath isEqualToString:@"name"]){
        self.nameLabel.text = self.model.name;
    }else if([keyPath isEqualToString:@"singer"]){
        self.singerLabel.text = self.model.singer;
    }else if([keyPath isEqualToString:@"musicImage"]){
        [self.musicImageView sd_setImageWithURL:[NSURL URLWithString:self.model.musicImage]];
    }
}


#pragma mark - setter getter
- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:25.f];
    }
    return _nameLabel;
}

- (UILabel *)singerLabel {
    if(!_singerLabel) {
        _singerLabel = [[UILabel alloc] init];
        _singerLabel.textColor = [UIColor blackColor];
        _singerLabel.backgroundColor = [UIColor clearColor];
        _singerLabel.font = [UIFont systemFontOfSize:16.f];
    }
    return _singerLabel;
}

- (UIImageView *)musicImageView {
    if(!_musicImageView){
        _musicImageView = [[UIImageView alloc] init];
    }
    return _musicImageView;
}

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
        [_downLoadBtn addTarget:self action:@selector(didDownDeleteLoadButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_downLoadBtn setBackgroundImage:[UIImage imageNamed:@"play_bar_download"] forState:UIControlStateNormal];
    }
    return _downLoadBtn;
}

- (UILabel *)currentTimeLabel {
    if(!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor blackColor];
        _currentTimeLabel.backgroundColor = [UIColor clearColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:12.f];
        _currentTimeLabel.text = @"00:00";
    }
    return _currentTimeLabel;
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

- (UILabel *)songTimeLabel {
    if(!_songTimeLabel) {
        _songTimeLabel = [[UILabel alloc] init];
        _songTimeLabel.textColor = [UIColor blackColor];
        _songTimeLabel.backgroundColor = [UIColor clearColor];
        _songTimeLabel.font = [UIFont systemFontOfSize:12.f];
        _songTimeLabel.text = @"00:00";
    }
    return _songTimeLabel;
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

//歌词
- (UILabel *)lyricsLabel {
    if(!_lyricsLabel) {
        _lyricsLabel = [[UILabel alloc] init];
        _lyricsLabel.textColor = [UIColor blackColor];
        _lyricsLabel.backgroundColor = [UIColor clearColor];
        _lyricsLabel.font = [UIFont systemFontOfSize:24.f];
        _lyricsLabel.text = @"暂无歌词";
        _lyricsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _lyricsLabel;
}

@end
