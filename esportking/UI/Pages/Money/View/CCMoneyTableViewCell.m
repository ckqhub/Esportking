//
//  CCMoneyTableViewCell.m
//  esportking
//
//  Created by jaycechen on 2018/2/28.
//  Copyright © 2018年 wan353. All rights reserved.
//

#import "CCMoneyTableViewCell.h"

@interface CCMoneyTableViewCell ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *moneyLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UIView *bottomLineView;

@end

@implementation CCMoneyTableViewCell

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.bottomLineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(CCPXToPoint(32));
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-CCPXToPoint(32));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-CCPXToPoint(32));
        make.left.equalTo(self.titleLabel);
    }];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moneyLabel);
        make.bottom.equalTo(self.timeLabel);
    }];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.moneyLabel);
        make.height.mas_equalTo(CCOnePoint);
    }];
}

- (void)setMoneyDict:(NSDictionary *)dict
{
    uint32_t type = [dict[@"type"] intValue];
    CGFloat money = [dict[@"amount"] floatValue];
    uint32_t status = [dict[@"status"] intValue];
    NSString *time = dict[@"create_time"];
    
    [self.statusLabel setText:time];
    [self.timeLabel setText:time];
    switch (type)
    {
        case 1:
        {
            [self.titleLabel setText:@"订单收入"];
            [self.moneyLabel setText:[NSString stringWithFormat:@"+%.2f", money]];
        }
            break;
        case 2:
        {
            [self.titleLabel setText:@"红包收入"];
            [self.moneyLabel setText:[NSString stringWithFormat:@"+%.2f", money]];
        }
            break;
        case 3:
        {
            [self.titleLabel setText:@"订单支出"];
            [self.moneyLabel setText:[NSString stringWithFormat:@"-%.2f", money]];
        }
            break;
        case 4:
        {
            [self.titleLabel setText:@"提现"];
            [self.moneyLabel setText:[NSString stringWithFormat:@"-%.2f", money]];
            if (status == 1)
            {
                [self.statusLabel setText:@"提现中"];
            }
            else if (status == 2)
            {
                [self.statusLabel setText:@"提现失败"];
            }
            else if (status == 3)
            {
                [self.statusLabel setText:@"提现成功"];
            }
            else if (status == 4)
            {
                [self.statusLabel setText:@"退款成功"];
            }
        }
            break;
        case 5:
        {
            [self.titleLabel setText:@"充值"];
            [self.moneyLabel setText:[NSString stringWithFormat:@"+%.2f", money]];
        }
            break;
        case 6:
        {
            [self.titleLabel setText:@"订单退款"];
            [self.moneyLabel setText:[NSString stringWithFormat:@"+%.2f", money]];
        }
            break;
        case 7:
        {
            [self.titleLabel setText:@"提现退款"];
            [self.moneyLabel setText:[NSString stringWithFormat:@"+%.2f", money]];
        }
            break;
        default:
            break;
    }
}

#pragma mark - getter
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel createOneLineLabelWithFont:Font_Middle color:FontColor_Black];
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel
{
    if (!_moneyLabel)
    {
        _moneyLabel = [UILabel createOneLineLabelWithFont:Font_Middle color:FontColor_Black];
    }
    return _moneyLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel)
    {
        _timeLabel = [UILabel createOneLineLabelWithFont:Font_Middle color:FontColor_Dark];
    }
    return _timeLabel;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel)
    {
        _statusLabel = [UILabel createOneLineLabelWithFont:Font_Middle color:FontColor_Dark];
    }
    return _statusLabel;
}

- (UIView *)bottomLineView
{
    if (!_bottomLineView)
    {
        _bottomLineView = [UIView new];
        [_bottomLineView setBackgroundColor:BgColor_SuperLightGray];
    }
    return _bottomLineView;
}

@end
