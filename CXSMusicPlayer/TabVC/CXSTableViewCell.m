//
//  CXSTableViewCell.m
//  CXSMusicPlayer
//
//  Created by 陈新爽 on 2022/4/21.
//

#import "CXSTableViewCell.h"
#import "Masonry.h"

@interface CXSTableViewCell()

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *singerLabel;

@property (nonatomic, strong)CXSTableViewCellModel *model;

@end

@implementation CXSTableViewCellModel

@end

@implementation CXSTableViewCell
- (instancetype)initWithModel:(CXSTableViewCellModel*)model
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
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = self.model.name;
    self.singerLabel.text = self.model.singer;
}

- (void)addAllSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.singerLabel];
}

- (void)layOutAllSubViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(10);
        make.left.mas_offset(20);
        make.height.mas_offset(25);
    }];
    [self.singerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.titleLabel);
        make.height.mas_offset(15);
    }];
}

#pragma mark - setter getter
- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:25.f];
    }
    return _titleLabel;
}

- (UILabel *)singerLabel {
    if(!_singerLabel) {
        _singerLabel = [[UILabel alloc] init];
        _singerLabel.textColor = [UIColor grayColor];
        _singerLabel.backgroundColor = [UIColor clearColor];
        _singerLabel.font = [UIFont systemFontOfSize:16.f];
    }
    return _singerLabel;
}

@end
