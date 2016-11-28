//
//  billType.h
//  clever
//
//  Created by 黄磊 on 16/5/13.
//  Copyright © 2016年 黄坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface billType : NSObject
@property (nonatomic,copy) NSString *billTypeId;///<账单类别id
//@property (nonatomic, copy) NSString *typeFatherId;///<账单类别父类id
@property (nonatomic, copy) NSString *billTypeName;///<账单类别名
@property (nonatomic, copy) NSString *billImageFillName;///<账单类别图标名
@property (nonatomic,assign) BOOL billIsincome;///<收支

@property (nonatomic ,strong, readonly) UIImage *billImage;


@end
