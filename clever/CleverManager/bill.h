//
//  bill.h
//  clever
//
//  Created by 黄磊 on 16/5/13.
//  Copyright © 2016年 黄坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bill : NSObject
@property (nonatomic, copy) NSString *billId;///<账单id
@property (nonatomic, copy) NSString *billTypeId;///<账单类别id
@property (nonatomic, copy) NSString *billNote;///<账单备注
@property (nonatomic, copy) NSString *billDate;///<账单时间
@property (nonatomic,assign) float billAmount;///<账单金额
@end
