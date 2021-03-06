//
//  CCHomeViewController.m
//  esportking
//
//  Created by CKQ on 2018/2/4.
//  Copyright © 2018年 wan353. All rights reserved.
//

#import "CCHomeViewController.h"
#import "CCLeftViewController.h"
#import "CCUserDetailViewController.h"
#import "CCBeautyViewController.h"
#import "CCSearchViewController.h"
#import "CCNearbyViewController.h"
#import "CCScoreWaitViewController.h"

#import "CCRefreshCollectionView.h"
#import "CCBannerCollectionViewCell.h"
#import "CCNavigationCollectionViewCell.h"
#import "CCGameItemCollectionViewCell.h"

#import "CCHomePageManager.h"
#import "CCAccountService.h"

#import <UIViewController+CWLateralSlide.h>
#import <UIButton+WebCache.h>
#import <MJRefresh.h>

#define kFirstSection   @"first"
#define kSecondSection  @"second"
#define kThirdSection   @"third"

@interface CCHomeViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, CCHomePageDelegate, CCRefreshDelegate, CCBannerDelegate, CCNavigationDelegate>

@property (strong, nonatomic) CCLeftViewController *leftVC;

@property (strong, nonatomic) CCRefreshCollectionView *collectionView;
@property (strong, nonatomic) CCHomePageManager *manager;
@property (strong, nonatomic) UIButton *userButton;
@property (strong, nonatomic) UIButton *searchButton;

@end

@implementation CCHomeViewController

- (instancetype)init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoChangeNotification:) name:CCInfoChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configTopbar];
    [self configContent];
    
    __weak typeof(self)weakSelf = self;
    [self cw_registerShowIntractiveWithEdgeGesture:NO transitionDirectionAutoBlock:^(CWDrawerTransitionDirection direction) {
        //NSLog(@"direction = %ld", direction);
        if (direction == CWDrawerTransitionFromLeft) { // 左侧滑出
            [weakSelf leftSlide];
        }
    }];
    
    [self.collectionView beginHeaderRefreshing];
}

- (void)configTopbar
{
    [self.userButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CCIMG(@"Header_Placeholder").size);
    }];
    [self.topbarView layoutLeftControls:@[self.userButton] spacing:nil];
    [self.topbarView layoutRightControls:@[self.searchButton] spacing:nil];
    [self.topbarView setBackgroundColor:BgColor_Gold];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:CCIMG(@"LOGO")];
    [self.topbarView layoutMidControls:@[imgView] spacing:nil];
}

- (void)configContent
{
    [self setContentWithTopOffset:LMStatusBarHeight+LMTopBarHeight bottomOffset:0];
    
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - Action
- (void)leftSlide
{
    [self cw_showDefaultDrawerViewController:self.leftVC];
}

- (void)onClickUserButton:(id)sender
{
    [self cw_showDefaultDrawerViewController:self.leftVC];
}

- (void)onClickSearchButton:(id)sender
{
    CCSearchViewController *vc = [CCSearchViewController new];
    
    //修改push方向
    CATransition* transition = [CATransition animation];
    transition.type          = kCATransitionMoveIn;//可更改为其他方式
    transition.subtype       = kCATransitionFromTop;//可更改为其他方式
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - CCBannerDelegate
- (void)didSelectBannerWithModel:(CCGameModel *)model
{
    CCUserDetailViewController *vc = [[CCUserDetailViewController alloc] initWithUserID:model.userModel.userID gameID:model.gameID userGameID:model.userGameID];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CCNavigationDelegate
- (void)didSelectNavigationCategory:(CATEGORY)category
{
    switch (category) {
        case CATEGORY_NEARBY:
        {
            CCNearbyViewController *vc = [CCNearbyViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case CATEGORY_CAR:
        {
            [((UITabBarController *)self.parentViewController) setSelectedIndex:1];
        }
            break;
        case CATEGORY_BEAUTY:
        {
            CCBeautyViewController *vc = [CCBeautyViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case CATEGORY_STUDY:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        CCGameModel *model = [_manager getAllNormalList][indexPath.row];
        CCUserDetailViewController *vc = [[CCUserDetailViewController alloc] initWithUserID:model.userModel.userID gameID:model.gameID userGameID:model.userGameID];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 2)
    {
        return [_manager getAllNormalList].count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *rstCell;
    switch (indexPath.section)
    {
        case 0:
        {
            CCBannerCollectionViewCell *cell = (CCBannerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kFirstSection forIndexPath:indexPath];
            [cell setBannerList:[_manager getAllRcmList] andDelegate:self];
            rstCell = cell;
        }
            break;
        case 1:
        {
            CCNavigationCollectionViewCell *cell = (CCNavigationCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kSecondSection forIndexPath:indexPath];
            [cell setDelegate:self];
            rstCell = cell;
        }
            break;
        case 2:
        {
            CCGameItemCollectionViewCell *cell = (CCGameItemCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kThirdSection forIndexPath:indexPath];
            [cell setGameModel:[_manager getAllNormalList][indexPath.row]];
            rstCell = cell;
        }
            break;
        default:
            
            break;
    }
    return rstCell;
}

#pragma mark - CCRefreshDelegate
- (void)onHeaderRefresh
{
    [self.manager startRefreshWithGameID:GAMEID_WANGZHE gender:0];
}

- (void)onFooterRefresh
{
    [self.manager startLoadMoreWithGameID:GAMEID_WANGZHE gender:0];
}

#pragma mark - CCHomePageDelegate
- (void)onRefreshHomePageSuccessWithRcmList:(NSArray<CCGameModel *> *)rcmList normalList:(NSArray<CCGameModel *> *)normalList
{
    [self.collectionView reloadData];
}

- (void)onRefreshHomePageFailed:(NSInteger)code errorMsg:(NSString *)msg
{
    [self showToast:msg];
    [self.collectionView endRefresh];
}

- (void)onLoadMoreHomePageSuccessWithNormalList:(NSArray<CCGameModel *> *)normalList
{
    [self.collectionView reloadData];
}

- (void)onLoadMoreHomePageFailed:(NSInteger)code errorMsg:(NSString *)msg
{
    [self showToast:msg];
    [self.collectionView endRefresh];
}

#pragma mark - CCInfoChangeNotification
- (void)onUserInfoChangeNotification:(NSNotification *)notify
{
    [_userButton sd_setBackgroundImageWithURL:[NSURL URLWithString:CCAccountServiceInstance.headUrl] forState:UIControlStateNormal placeholderImage:_userButton.imageView.image];
}

#pragma mark - getters
- (CCLeftViewController *)leftVC
{
    if (!_leftVC)
    {
        _leftVC = [CCLeftViewController new];
    }
    return _leftVC;
}

- (CCRefreshCollectionView *)collectionView
{
    if (!_collectionView)
    {
        _collectionView = [[CCRefreshCollectionView alloc] init];
        _collectionView.collectionView.dataSource = self;
        _collectionView.collectionView.delegate = self;
        [_collectionView setRefreshDelegate:self];
        [_collectionView.collectionView.mj_header setBackgroundColor:BgColor_Gold];
        [_collectionView.collectionView registerClass:[CCBannerCollectionViewCell class] forCellWithReuseIdentifier:kFirstSection];
        [_collectionView.collectionView registerClass:[CCNavigationCollectionViewCell class] forCellWithReuseIdentifier:kSecondSection];
        [_collectionView.collectionView registerClass:[CCGameItemCollectionViewCell class] forCellWithReuseIdentifier:kThirdSection];
        [_collectionView.collectionLayout setLineSpacing:CCPXToPoint(12)];
        [_collectionView.collectionLayout setRowSpacing:CCPXToPoint(12)];
        [_collectionView.collectionLayout calculateItemSizeWithWidthBlock:^CGSize(NSIndexPath *indexPath) {
            switch (indexPath.section)
            {
                case 0:
                {
                    return CGSizeMake(LM_SCREEN_WIDTH, CCBannerItemSize.height+CCPXToPoint(60));
                }
                    break;
                case 1:
                {
                    return CGSizeMake(LM_SCREEN_WIDTH, CCPXToPoint(176));
                }
                    break;
                case 2:
                {
                    CGFloat width = (LM_SCREEN_WIDTH-CCPXToPoint(86))/2.f;
                    return CGSizeMake(width, width);
                }
                    break;
                default:
                    return CGSizeZero;
                    break;
            }
        } andLeftPaddingBlock:^CGFloat(NSIndexPath *indexPath) {
            if (indexPath.section == 2)
            {
                return CCPXToPoint(37);
            }
            else
            {
                return 0;
            }
        }];
    }
    return _collectionView;
}

- (CCHomePageManager *)manager
{
    if (!_manager)
    {
        _manager = [[CCHomePageManager alloc] initWithPageType:HOMEPAGETYPE_ROOTPAGE Delegate:self];
    }
    return _manager;
}

- (UIButton *)userButton
{
    if (!_userButton)
    {
        _userButton = [UIButton new];
        [_userButton.layer setCornerRadius:CCIMG(@"Header_Placeholder").size.height/2.f];
        [_userButton.layer setMasksToBounds:YES];
        [_userButton sd_setBackgroundImageWithURL:[NSURL URLWithString:CCAccountServiceInstance.headUrl] forState:UIControlStateNormal placeholderImage:CCIMG(@"Header_Placeholder")];
        [_userButton addTarget:self action:@selector(onClickUserButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userButton;
}

- (UIButton *)searchButton
{
    if (!_searchButton)
    {
        _searchButton = [UIButton new];
        [_searchButton setImage:CCIMG(@"Search_Icon") forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(onClickSearchButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

@end
