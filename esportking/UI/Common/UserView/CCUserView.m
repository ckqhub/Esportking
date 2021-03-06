//
//  CCUserView.m
//  esportking
//
//  Created by jaycechen on 2018/3/8.
//  Copyright © 2018年 wan353. All rights reserved.
//

#import "CCUserView.h"
#import "CCGenderOldView.h"

#define kHeadWidth  CCPXToPoint(140)

@interface CCUserView ()

@property (strong, nonatomic) UIImageView *headImgView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) CCGenderOldView *genderView;
@property (strong, nonatomic) UILabel *businessLabel;
@property (strong, nonatomic) CCStarView *starView;

@end

@implementation CCUserView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.headImgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.genderView];
    [self addSubview:self.businessLabel];
    [self addSubview:self.starView];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.width.height.mas_equalTo(kHeadWidth);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImgView.mas_bottom).offset(CCPXToPoint(16));
        make.centerX.equalTo(self);
    }];
    [self.genderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.left.equalTo(self.nameLabel.mas_right).offset(CCPXToPoint(8));
        make.height.mas_equalTo(CCPXToPoint(28));
    }];
    [self.businessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(CCPXToPoint(20));
        make.centerX.equalTo(self);
    }];
    [self.starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self);
        make.height.mas_equalTo(CCPXToPoint(40));
    }];
}

#pragma mark - public
- (void)setEnableBusiness:(BOOL)enable
{
    [self.businessLabel setHidden:!enable];
}

- (void)setEnableTouch:(BOOL)enable del:(id<CCStarViewDelegate>)del
{
    [self.starView setEnableTouch:enable del:del];
}

- (void)setUserInfo:(CCUserModel *)model businessCount:(uint64_t)busiCount starCount:(uint64_t)starCount
{
    if (!model)
    {
        return;
    }
    [self.headImgView setImageWithUrl:model.headUrl placeholder:CCIMG(@"Default_Header")];
    [self.nameLabel setText:model.name];
    [self.genderView setGender:model.gender andOld:model.age];
    [self.businessLabel setText:[NSString stringWithFormat:@"已接：%lld单", busiCount]];
    [self.starView setEvaluateStarCount:(uint32_t)starCount];
}

#pragma mark - getter
- (UIImageView *)headImgView
{
    if (!_headImgView)
    {
        _headImgView = [UIImageView scaleFillImageView];
        [_headImgView.layer setCornerRadius:kHeadWidth/2.f];
    }
    return _headImgView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [UILabel createOneLineLabelWithFont:Font_Big color:FontColor_Black];
    }
    return _nameLabel;
}

- (CCGenderOldView *)genderView
{
    if (!_genderView)
    {
        _genderView = [CCGenderOldView new];
        [_genderView.layer setCornerRadius:CCPXToPoint(14)];
    }
    return _genderView;
}

- (UILabel *)businessLabel
{
    if (!_businessLabel)
    {
        _businessLabel = [UILabel createOneLineLabelWithFont:Font_Small color:FontColor_Gray];
    }
    return _businessLabel;
}

- (CCStarView *)starView
{
    if (!_starView)
    {
        _starView = [[CCStarView alloc] initWithFrame:CGRectMake(0, 0, CCPXToPoint(288), CCPXToPoint(40)) starGap:CCPXToPoint(22)];
    }
    return _starView;
}

@end
