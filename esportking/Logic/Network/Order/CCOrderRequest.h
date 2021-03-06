//
//  CCOrderRequest.h
//  esportking
//
//  Created by jaycechen on 2018/2/28.
//  Copyright © 2018年 wan353. All rights reserved.
//

#import "CCBaseRequest.h"
#import "CCOrderModel.h"

@interface CCOrderRequest : CCBaseRequest

@property (assign, nonatomic) ORDERSOURCE type;
@property (assign, nonatomic) uint64_t gameID;
@property (assign, nonatomic) uint64_t pageNum;
@property (assign, nonatomic) uint64_t pageSize;
@property (assign, nonatomic) uint32_t status;  // 0:所有 2:进行中，默认为0

// resp
@property (strong, nonatomic) NSArray<CCOrderModel *> *orderList;

@end
