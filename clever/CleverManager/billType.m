//
//  billType.m
//  clever
//
//  Created by 黄磊 on 16/5/13.
//  Copyright © 2016年 黄坤. All rights reserved.
//

#import "billType.h"

@implementation billType
-(id)initWithID:(NSString *)ID andName:(NSString *)Name {
    self=[super init];
    if (self) {
        self.billTypeId=ID;
        self.billTypeName=Name;
    }
    return self;
}
-(UIImage *)billImage
{
    return [UIImage imageNamed:self.billImageFillName];
}
- (NSString *)description {
    return [NSString stringWithFormat:@"typeID= %@,name = %@, filleName = %@,icome = %i,image = %@",self.billTypeId,self.billTypeName,self.billImageFillName,self.billIsincome,self.billImage];
}
@end
