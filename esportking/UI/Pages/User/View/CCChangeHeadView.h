//
//  CCChangeHeadView.h
//  esportking
//
//  Created by jaycechen on 2018/3/12.
//  Copyright © 2018年 wan353. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCBaseViewController.h"

@interface CCChangeHeadView : UIView

@property (weak, nonatomic) CCBaseViewController *parentVC;

- (instancetype)initWithParentVC:(CCBaseViewController *)vc;

@end
