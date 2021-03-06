//
//  CCWalletViewController.m
//  esportking
//
//  Created by jaycechen on 2018/2/28.
//  Copyright © 2018年 wan353. All rights reserved.
//

#import "CCWalletViewController.h"
#import "CCMoneyViewController.h"
#import "CCPageContainerViewController.h"
#import "CCCommitButton.h"
#import "CCGetBalanceRequest.h"
#import "CCGainMoneyViewController.h"

@interface CCWalletViewController ()<CCRequestDelegate>

@property (assign, nonatomic) CGFloat balance;
@property (strong, nonatomic) CCGetBalanceRequest *request;

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *moneyLabel;
@property (strong, nonatomic) UILabel *tipsLabel;
@property (strong, nonatomic) UILabel *alertLabel;
@property (strong, nonatomic) CCCommitButton *getMoneyButton;

@end

@implementation CCWalletViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configTopbar];
    [self configContent];
    [self refreshBalance];
}

- (void)configTopbar
{
    [self addTopPopBackButton];
    [self addTopbarTitle:@"钱包"];
    UIButton *rightBtn = [UIButton new];
    [rightBtn setTitle:@"收支记录" forState:UIControlStateNormal];
    [rightBtn setTitleColor:FontColor_Black forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(onClickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.topbarView layoutRightControls:@[rightBtn] spacing:nil];
}

- (void)configContent
{
    [self setContentWithTopOffset:LMStatusBarHeight+LMTopBarHeight bottomOffset:LMLayoutAreaBottomHeight];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.tipsLabel];
    [self.contentView addSubview:self.alertLabel];
    [self.contentView addSubview:self.getMoneyButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(CCPXToPoint(64));
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(CCPXToPoint(32));
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(CCPXToPoint(48));
    }];
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.getMoneyButton.mas_top).offset(-CCPXToPoint(32));
    }];
    [self.getMoneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(CCPXToPoint(96));
    }];
}

#pragma mark - action
- (void)onClickRightButton:(UIButton *)button
{
    CCMoneyViewController *vc0 = [[CCMoneyViewController alloc] initWithMoneyType:MONEYTYPE_ALL];
    CCMoneyViewController *vc1 = [[CCMoneyViewController alloc] initWithMoneyType:MONEYTYPE_OUT];
    CCMoneyViewController *vc2 = [[CCMoneyViewController alloc] initWithMoneyType:MONEYTYPE_IN];
    
    CCPageContainerViewController *pageVC = [[CCPageContainerViewController alloc] initWithVCs:@[vc0, vc1, vc2] subTitles:@[@"全部", @"支出记录", @"提现记录"] andTitle:@"收支记录"];
    [self.navigationController pushViewController:pageVC animated:YES];
}

- (void)onClickGetMoneyButton:(UIButton *)button
{
    if (self.balance < 100)
    {
        [self showToast:@"金额小于100元无法提现"];
        return;
    }
    CCGainMoneyViewController *vc = [[CCGainMoneyViewController alloc] initWithMoney:self.balance];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CCRequestDelegate
- (void)onRequestSuccess:(NSDictionary *)dict sender:(id)sender
{
    if (sender != self.request)
    {
        return;
    }
    self.balance = self.request.balance;
    self.request = nil;
    [self refreshBalanceUI];
}

- (void)onRequestFailed:(NSInteger)errorCode errorMsg:(NSString *)msg sender:(id)sender
{
    if (sender != self.request)
    {
        return;
    }
    [self showToast:msg];
    self.request = nil;
}

#pragma mark - private
- (void)refreshBalance
{
    self.request = [CCGetBalanceRequest new];
    [self.request startGetRequestWithDelegate:self];
}

- (void)refreshBalanceUI
{
    [self.moneyLabel setText:[NSString stringWithFormat:@"%.2f", self.balance]];
    if (self.balance > 100)
    {
        [self.getMoneyButton setEnabled:YES];
    }
    else
    {
        [self.getMoneyButton setEnabled:NO];
    }
}

#pragma mark - getter
- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel createOneLineLabelWithFont:Font_Big color:FontColor_Black];
        [_titleLabel setText:@"余额（元）"];
    }
    return _titleLabel;
}

- (UILabel *)moneyLabel
{
    if (!_moneyLabel)
    {
        _moneyLabel = [UILabel createOneLineLabelWithFont:Font_Great color:FontColor_Red];
    }
    return _moneyLabel;
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel)
    {
        _tipsLabel = [UILabel createOneLineLabelWithFont:Font_Middle color:FontColor_Yellow];
        [_tipsLabel setText:@"马上充值到余额，用于平台消费"];
    }
    return _tipsLabel;
}

- (UILabel *)alertLabel
{
    if (!_alertLabel)
    {
        _alertLabel = [UILabel createOneLineLabelWithFont:Font_Small color:FontColor_Gray];
        [_alertLabel setText:@"每次提现最低100元"];
    }
    return _alertLabel;
}

- (CCCommitButton *)getMoneyButton
{
    if (!_getMoneyButton)
    {
        _getMoneyButton = [CCCommitButton new];
        [_getMoneyButton setTitle:@"马上提现" forState:UIControlStateNormal];
        _getMoneyButton.enableTitleColor = FontColor_White;
        _getMoneyButton.enabled = NO;
        [_getMoneyButton addTarget:self action:@selector(onClickGetMoneyButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getMoneyButton;
}

@end
