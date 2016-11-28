//
//  DatabaseManager.m
//  clever
//
//  Created by 黄磊 on 16/5/13.
//  Copyright © 2016年 黄坤. All rights reserved.
//

#import "DatabaseManager.h"
#import "FMDB.h"

#define dataBasePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) firstObject] stringByAppendingPathComponent:dataBaseName]

#define dataBaseName @"clever.db"
#define KTableOfBillType @"billTypeTable"
#define KTableOfBill @"billTable"

@interface DatabaseManager ()

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation DatabaseManager

+(DatabaseManager *)sharedDBManager
{
    static DatabaseManager *shareDBManager=nil;
    @synchronized (self) {
        if (shareDBManager==nil) {
            shareDBManager=[[DatabaseManager alloc]init];
            [shareDBManager setupTypeTableFromPlist];
        }
    }
    return shareDBManager;
}
-(DatabaseManager *)init
{
    if (self=[super init]) {
        self.database=[FMDatabase databaseWithPath:dataBasePath];
        if ([self.database open]==NO) {
            NSLog(@"打开数据库失败，数据库路径： %@",dataBasePath);
            return nil;
        }
        else{
            NSLog(@"打开数据库成功，数据库路径： %@",dataBasePath);
            
        }
        NSString *sqlStr=[NSString stringWithFormat:@"create table if not exists %@ (billTypeId integer primary key autoincrement,billTypeName text,billImagefillName text,billIsincome bool)",KTableOfBillType];
        if (![self.database executeUpdate:sqlStr]) {
            NSLog(@"建类别表失败啊，SQL语句是：%@",sqlStr);
            return nil;
        }
        NSString *sqlStr1=[NSString stringWithFormat:@"create table if not exists %@ (billId integer primary key autoincrement,billTypeId integer,billNote text,billDate text,billAmount double)",KTableOfBill];
        if (![self.database executeUpdate:sqlStr1]) {
            NSLog(@"建账单失败啊，SQL语句是：%@",sqlStr1);
            return nil;
        }
    }
    return self;

}

-(void)setupTypeTableFromPlist{
    NSString *sqlStr = [NSString stringWithFormat:@"select count(*) from %@",KTableOfBillType];
    NSInteger count = [self.database intForQuery:sqlStr];
    if (count==0) {
       NSString *path = [[NSBundle mainBundle] pathForResource:@"收入" ofType:@"plist" ];
        NSArray *plists = [NSArray arrayWithContentsOfFile:path];
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"支出" ofType:@"plist" ];
        NSArray *plists1 = [NSArray arrayWithContentsOfFile:path1];
        
        for (NSDictionary *typeDict in plists) {
            billType *type=[[billType alloc]init];
            type.billTypeName=typeDict[@"name"];
            type.billImageFillName=typeDict[@"icon"];
            type.billIsincome=1;
            [self addBillType:type];
        }
        for (NSDictionary *typeDict1 in plists1) {
            billType *type1=[[billType alloc]init];
            type1.billTypeName=typeDict1[@"name"];
            type1.billImageFillName=typeDict1[@"icon"];
            type1.billIsincome=0;
            [self addBillType:type1];
        }
    }
    //select count * from billType table
    //if count==0
    //read array from plist
    //for in.... create billtype object from array item
    //call addBillType:aType
    //end of for
    //end if
}

#pragma mark --- 类别数据库接口
//static int a = 0;
-(void)addBillType:(billType*)aType
{
    if (!aType) {
        return;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"insert into %@ (billTypeName,billImagefillName,billIsincome) values (?,?,?)",KTableOfBillType];
    if (![self.database executeUpdate:sqlStr,aType.billTypeName,aType.billImageFillName,@(aType.billIsincome)])
    {
        NSLog(@"添加类别失败，sq语句是：%@",sqlStr);
    }

    
}
-(void)deleteBillType:(billType*)aType//删除类别
{
    if (!aType) {
        return;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"DELETE FROM %@ WHERE billTypeId=%@ ",KTableOfBillType,aType.billTypeId];
    if (![self.database executeUpdate:sqlStr])
    {
        NSLog(@"删除类别失败，sq语句是：%@",sqlStr);
    }

}

-(NSMutableArray *)readBillTypeList:(BOOL )income
{
    NSString *sqlStr=[NSString stringWithFormat:@"select * from %@ where billIsincome=%d",KTableOfBillType,(int)income];
    NSMutableArray *arry=[NSMutableArray array];
    FMResultSet *resultSet=[self.database executeQuery:sqlStr];
    while ([resultSet next]) {
        billType * aType=[billType new];
        aType.billTypeId=[resultSet stringForColumn:@"billTypeId"];
        aType.billTypeName=[resultSet stringForColumn:@"billTypeName"];
        aType.billImageFillName=[resultSet stringForColumn:@"billImagefillName"];
        aType.billIsincome=[resultSet boolForColumn:@"billIsincome"];
        [arry addObject:aType];
        
    }
    return arry;
}
-(billType *)readBillType:(NSString *)billTypeId
{
    NSString *sqlStr=[NSString stringWithFormat:@"select * from %@ where billTypeId=%@",KTableOfBillType,billTypeId];
    FMResultSet *resultSet=[self.database executeQuery:sqlStr];
    billType * aType=[billType new];
    while ([resultSet next]) {
        aType.billTypeId=[resultSet stringForColumn:@"billTypeId"];
        aType.billTypeName=[resultSet stringForColumn:@"billTypeName"];
        aType.billImageFillName=[resultSet stringForColumn:@"billImagefillName"];
        aType.billIsincome=[resultSet boolForColumn:@"billIsincome"];
    }
    return aType;
}

-(void)upDataBillType:(billType*)aType
{
    if (!aType) {
        return;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"update %@ set billTypeName=?,billImagefillName=?,billIsincome=? where billTypeId=%@",KTableOfBillType,aType.billTypeId];
    if (![self.database executeUpdate:sqlStr,aType.billTypeName,aType.billImageFillName,@(aType.billIsincome)]) {
        NSLog(@"修改类别信息出错 SQL语句为%@\n  类别名称是%@",sqlStr,aType.billTypeName);
    }
    
}

#pragma mark --- 账单数据库接口
-(NSMutableArray *)readBillListOfType:(NSString *)date;
{
    NSString *sqlStr = [NSString stringWithFormat:@"select *from %@ where strftime('%%Y-%%m',billDate)==strftime('%%Y-%%m','%@')",KTableOfBill,date];
    NSMutableArray *arry=[NSMutableArray array];
    FMResultSet *resultSet=[self.database executeQuery:sqlStr];
    while ([resultSet next]) {
        bill * abill=[bill new];
        abill.billId=[resultSet stringForColumn:@"billId"];
        abill.billTypeId=[resultSet stringForColumn:@"billTypeId"];
        abill.billNote=[resultSet stringForColumn:@"billNote"];
        abill.billDate=[resultSet stringForColumn:@"billDate"];
        abill.billAmount=[resultSet doubleForColumn:@"billAmount"];
        [arry addObject:abill];
    }
    return arry;
}
-(NSMutableArray *)readBillMonth:(NSString *)month{
    month=[NSString stringWithFormat:@"%@-01",month];
    NSMutableArray *arry=[[NSMutableArray alloc]init];
    NSString *sqlStr = [NSString stringWithFormat:@"select *from %@ where strftime('%%Y-%%m',billDate)==strftime('%%Y-%%m','%@')",KTableOfBill,month];
    FMResultSet *resultSet=[self.database executeQuery:sqlStr];
    while ([resultSet next]) {
        bill * abill=[bill new];
        abill.billId=[resultSet stringForColumn:@"billId"];
        abill.billTypeId=[resultSet stringForColumn:@"billTypeId"];
        abill.billNote=[resultSet stringForColumn:@"billNote"];
        abill.billDate=[resultSet stringForColumn:@"billDate"];
        abill.billAmount=[resultSet doubleForColumn:@"billAmount"];
        [arry addObject:abill];
    }
    return arry;
}
-(NSMutableArray *)selectBillofmonth
{
    NSMutableArray *monthArray=[[NSMutableArray alloc]init];
    NSString *time=@"'%Y-%m'";
    NSString *sqlStr=[NSString stringWithFormat:@"select distinct strftime(%@,billDate) from billTable order by billDate desc",time];
    FMResultSet *resultSet=[self.database executeQuery:sqlStr];
    while ([resultSet next]) {
        NSString *month=[resultSet stringForColumn:@"strftime('%Y-%m',billDate)"];
        NSLog(@"%@",month);
        [monthArray addObject:month];
    }
    return monthArray;

}


-(void)addBillList:(bill *)theclever//添加账单
{
    if (!theclever) {
        return;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"insert into %@ (billTypeId,billNote,billDate,billAmount) values (?,?,?,?)",KTableOfBill];
    NSLog(@"%f",theclever.billAmount);
   if (![self.database executeUpdate:sqlStr,theclever.billTypeId,theclever.billNote,theclever.billDate,@(theclever.billAmount)])
    {
        NSLog(@"添加账单失败，sq语句是：%@",sqlStr);
    }
    
}
-(void)upDataBill :(bill *)theBill//修改账单信息
{
    if (!theBill) {
        return;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"update %@ set billTypeId= ?,billNote=?,billDate=?,billAmount=? where billId=%@",KTableOfBill,theBill.billId];
    if (![self.database executeUpdate:sqlStr,theBill.billTypeId,theBill.billNote,theBill.billDate,@(theBill.billAmount)]) {
        NSLog(@"修改账单信息出错 SQL语句为%@\n  账单时间是%@",sqlStr,theBill.billDate);
    }
}
-(void)deleteBill:(bill *)aBill //删除账单
{
    if (!aBill) {
        return;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"DELETE FROM %@ WHERE billId=%@ ",KTableOfBill,aBill.billId];
    if (![self.database executeUpdate:sqlStr])
    {
        NSLog(@"删除账单失败，sq语句是：%@",sqlStr);
    }
}
#pragma mark--统计金额
/**统计收入的金额**/
-(float)moneyByincome:(NSMutableArray *)array
{
    NSMutableArray *moneyArray=[NSMutableArray new];
    for (bill *thebill in array) {
        billType *thetype=[self readBillType:thebill.billTypeId];
        
        NSString *str=[NSString stringWithFormat:@"select billIsincome from %@ where billTypeId=%@",KTableOfBillType,thetype.billTypeId];
        NSInteger integer=[self.database intForQuery:str];
        if (integer==1) {
            NSString *string=[NSString stringWithFormat:@"%f",thebill.billAmount];
            [moneyArray addObject:string];
        }
    }
    float a=0;
    for (int i=0; i<moneyArray.count; i++) {
        NSString *expend=moneyArray[i];
        a+=expend.floatValue;
    }
    return a;
    
}
/**统计支出的金额**/
-(float)moneyByspending:(NSMutableArray *)array
{
    NSMutableArray *moneyArray=[NSMutableArray new];
    for (bill *thebill in array) {
      billType *thetype=[self readBillType:thebill.billTypeId];
        NSString *str=[NSString stringWithFormat:@"select billIsincome from %@ where billTypeId=%@",KTableOfBillType,thetype.billTypeId];
        NSInteger integer=[self.database intForQuery:str];
        if (integer==0) {
            NSString *string=[NSString stringWithFormat:@"%f",thebill.billAmount];
            [moneyArray addObject:string];
        }
    }
    float a=0;
    for (int i=0; i<moneyArray.count; i++) {
        NSString *expend=moneyArray[i];
        a+=expend.floatValue;
    }
    return a;

}
//读取数据封装成字典
- (NSDictionary *)queryTimeNotDuplicateData{
    NSString *sqlstr=[NSString stringWithFormat:@"select *from %@",KTableOfBill];
    NSMutableArray *dates = [NSMutableArray array];
    NSMutableArray *arry=[NSMutableArray array];
    FMResultSet *resultSet=[self.database executeQuery:sqlstr];
    while ([resultSet next]) {
        bill * abill=[bill new];
        abill.billId=[resultSet stringForColumn:@"billId"];
        abill.billTypeId=[resultSet stringForColumn:@"billTypeId"];
        abill.billNote=[resultSet stringForColumn:@"billNote"];
        abill.billDate=[resultSet stringForColumn:@"billDate"];
        abill.billAmount=[resultSet doubleForColumn:@"billAmount"];
        [arry addObject:abill];
    }
    //1.把全部时间for in 出来加到dates数组中
    for (bill *bill in arry) {
        [dates addObject:bill.billDate];
    }
    //2.把dates数组里面的时间把不重复的筛选出来放到uniqueDates数组中，containsObject（比较）
    NSMutableArray *uniqueDates = [NSMutableArray array];
    for (NSInteger i=0; i<dates.count; i++) {
        if (![uniqueDates containsObject:dates[i]]) {
            [uniqueDates addObject:dates[i]];
            NSLog(@"%@",uniqueDates);
        }
    }
    //3.把时间作为key ，时间对应的对象作为value 保存到resultsDic中
    NSMutableDictionary *resultsDic = [NSMutableDictionary dictionary];
    for (NSString *dateStr in uniqueDates)
    {
        NSLog(@"-----%@----",dateStr);
        NSString *sqlstr1=[NSString stringWithFormat:@"select *from %@ where billDate='%@'",KTableOfBill,dateStr];
        NSMutableArray *arry1=[NSMutableArray array];
        FMResultSet *resul=[_database executeQuery:sqlstr1];
        while ([resul next]) {
            bill * thebill=[[bill alloc]init];
            thebill.billId=[resul stringForColumn:@"billId"];
            thebill.billTypeId=[resul stringForColumn:@"billTypeId"];
            thebill.billNote=[resul stringForColumn:@"billNote"];
            thebill.billDate=[resul stringForColumn:@"billDate"];
            thebill.billAmount=[resul doubleForColumn:@"billAmount"];
            [arry1 addObject:thebill];
            [resultsDic setObject:arry1 forKey:thebill.billDate];
        }
        NSLog(@"%@",resultsDic);
    }
    
    return resultsDic;
}

@end
