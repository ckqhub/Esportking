//
//  CCRefreshCollectionView.m
//  esportking
//
//  Created by CKQ on 2018/2/4.
//  Copyright © 2018年 wan353. All rights reserved.
//

#import "CCRefreshCollectionView.h"
#import <MJRefresh.h>

@implementation CCRefreshCollectionView
{
    __weak id<CCRefreshDelegate> _refreshDelegate;
    MJRefreshHeader *_header;
    MJRefreshFooter *_footer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUI];
        [self setupConstrain];
    }
    return self;
}

- (void)setupUI
{
    [self setBackgroundColor:BgColor_Clear];
    
    _collectionLayout = [[HomeCollectionLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:_collectionLayout];
    [_collectionView setBackgroundColor:BgColor_Clear];
    [self addSubview:_collectionView];
    
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(onHeaderRefresh)];
    _collectionView.mj_header = _header;
    
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(onFooterRefresh)];
    _collectionView.mj_footer = _footer;
}

- (void)setupConstrain
{
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - CCRefreshProtocol
- (void)setRefreshDelegate:(id<CCRefreshDelegate>)delegate
{
    _refreshDelegate = delegate;
}

- (void)enableHeader:(BOOL)enable
{
    _collectionView.mj_header = enable?_header:nil;
}

- (void)enableFooter:(BOOL)enable
{
    _collectionView.mj_footer = enable?_footer:nil;
}

- (void)beginHeaderRefreshing
{
    [_collectionView.mj_header beginRefreshing];
}

- (void)reloadData
{
    [_collectionView reloadData];
    [self endRefresh];
}

- (void)endRefresh
{
    [_collectionView.mj_header endRefreshing];
    [_collectionView.mj_footer endRefreshing];
}

#pragma mark -
- (void)onHeaderRefresh
{
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(onHeaderRefresh)])
    {
        [_refreshDelegate onHeaderRefresh];
    }
}

- (void)onFooterRefresh
{
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(onFooterRefresh)])
    {
        [_refreshDelegate onFooterRefresh];
    }
}

@end