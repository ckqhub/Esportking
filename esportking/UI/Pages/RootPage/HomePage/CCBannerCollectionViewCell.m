//
//  CCBannerCollectionViewCell.m
//  esportking
//
//  Created by CKQ on 2018/2/11.
//  Copyright © 2018年 wan353. All rights reserved.
//

#import "CCBannerCollectionViewCell.h"
#import "NewPagedFlowView.h"
#import "CCGameModel.h"
#import <UIImageView+WebCache.h>

@interface CCBannerCollectionViewCell()<NewPagedFlowViewDataSource, NewPagedFlowViewDelegate>

@property (weak  , nonatomic) id<CCBannerDelegate> delegate;
@property (strong, nonatomic) NSArray<CCGameModel *> *modelList;
@property (strong, nonatomic) NewPagedFlowView *pageFlowView;

@end

@implementation CCBannerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUI];
    }
    return self;
}

- (void)setBannerList:(NSArray<CCGameModel *> *)list andDelegate:(id<CCBannerDelegate>)del
{
    self.delegate = del;
    self.modelList = list;
    [self.pageFlowView reloadData];
}

- (void)setupUI
{
    [self setBackgroundColor:BgColor_Yellow];
    [self.contentView addSubview:self.pageFlowView];
    [self.pageFlowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - NewPagedFlowViewDataSource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView
{
    return [self.modelList count];
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView)
    {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    CCGameModel *model = self.modelList[index];
    [bannerView.mainImageView setImageWithUrl:model.userModel.headUrl placeholder:CCIMG(@"Placeholder_Icon")];
    
    return bannerView;
}

#pragma mark - NewPagedFlowViewDelegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView
{
    return CCBannerItemSize;
}

- (void)didSelectCell:(PGIndexBannerSubiew *)subView withSubViewIndex:(NSInteger)subIndex
{
    [self.delegate didSelectBannerWithModel:self.modelList[subIndex]];
}

#pragma mark - getters
- (NewPagedFlowView *)pageFlowView
{
    if (!_pageFlowView)
    {
        _pageFlowView = [[NewPagedFlowView alloc] init];
        _pageFlowView.dataSource = self;
        _pageFlowView.delegate = self;
        _pageFlowView.isOpenAutoScroll = YES;
        _pageFlowView.minimumPageAlpha = 0.1;
        _pageFlowView.isCarousel = YES;
        _pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    }
    return _pageFlowView;
}

@end