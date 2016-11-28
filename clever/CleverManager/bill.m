//
//  bill.m
//  clever
//
//  Created by 黄磊 on 16/5/13.
//  Copyright © 2016年 黄坤. All rights reserved.
//

#import "bill.h"

@implementation bill 
-(NSString *)description{
    return [NSString stringWithFormat:@"billId:%@\n billNote:%@",self.billId,self.billNote];
}


@end
