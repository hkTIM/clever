//
//  DatabaseManager.h
//  clever
//
//  Created by 黄磊 on 16/5/13.
//  Copyright © 2016年 黄坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseAdditions.h"
#import "bill.h"
#import "billType.h"
@interface DatabaseManager : NSObject

+(DatabaseManager *)sharedDBManager;
-(DatabaseManager *)init;

//类别数据库接口
-(void)addBillType:(billType*)aType; ///<添加类别
-(void)deleteBillType:(billType*)aType;///<删除类别
-(NSMutableArray *)readBillTypeList:(BOOL)income;///<跟据类别读取不同类别信息
-(billType *)readBillType:(NSString *)billTypeId;///<跟据类别读取不同类别信息
-(void)upDataBillType:(billType*)aType;///<修改类别信息

//账单数据库接口
-(NSMutableArray *)readBillListOfType:(NSString *)date;///<根据date读取数据
-(NSMutableArray *)readBillMonth:(NSString *)month;
-(void)addBillList:(bill *)theclever;///<添加账单
-(void)upDataBill :(bill *)theBill;///<修改账单信息
-(void)deleteBill:(bill *)aBill ;///<删除账单
-(NSMutableArray *)selectBillofmonth;

//统计金额
-(float)moneyByincome:(NSMutableArray *)array;
-(float)moneyByspending:(NSMutableArray *)array;

///**
// *  查询时间不重复的数据
// */
- (NSDictionary *)queryTimeNotDuplicateData;
@end
