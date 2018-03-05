//
//  CCScoreBannerTableViewCell.m
//  esportking
//
//  Created by jaycechen on 2018/3/2.
//  Copyright © 2018年 wan353. All rights reserved.
//

#import "CCScoreBannerTableViewCell.h"

@interface CCScoreBannerTableViewCell ()

@property (strong, nonatomic) UIImageView *imgView;

@end

@implementation CCScoreBannerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - getter
- (UIImageView *)imgView
{
    if (!_imgView)
    {
        _imgView = [UIImageView new];
        [_imgView setContentMode:UIViewContentModeScaleAspectFill];
        [_imgView setClipsToBounds:YES];
    }
    return _imgView;
}

@end