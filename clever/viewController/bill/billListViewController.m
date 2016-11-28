//
//  billListViewController.m
//  clever
//
//  Created by 黄坤 on 16/6/2.
//  Copyright © 2016年 黄坤. All rights reserved.
//

#import "billListViewController.h"
#import "DatabaseManager.h"
#import "billType.h"
#import "UIView+RoundedCorner.h"
#import "LXAlertView.h"

@interface billListViewController ()<UIAlertViewDelegate>
@property (strong,nonatomic) DatabaseManager *dbManger;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UITextField *noteLab;
@property (strong,nonatomic) billType *theType;
@property (weak, nonatomic) IBOutlet UIButton *upData;
@property (weak, nonatomic) IBOutlet UIButton *delete;

@end

@implementation billListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManger=[DatabaseManager sharedDBManager];
    self.navigationController.navigationBar.hidden = NO;
    NSLog(@"%@",self.theBill);
    NSString *str = [NSString stringWithFormat:@"%.2f",_theBill.billAmount];
    self.amountLab.text=str;
    _theType=[self.dbManger readBillType:_theBill.billTypeId];
    if (_theType.billIsincome==0) {
        NSString *str=[NSString stringWithFormat:@"支出->%@",_theType.billTypeName];
        self.typeLab.text=str;
    }
    else
    {
        NSString *str=[NSString stringWithFormat:@"收入->%@",_theType.billTypeName];
        self.typeLab.text=str;

    }
    self.timeLab.text=[NSString stringWithFormat:@"%@",_theBill.billDate];
    self.noteLab.text=_theBill.billNote;
    
    [self setCornerRadius:self.upData];
    [self setCornerRadius:self.delete];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteBut:(UIButton *)sender {
    LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"删除？" message:@"幸苦记得帐就找不回来了哟！" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
        NSLog(@"%ld",clickIndex);
        if (clickIndex==1) {
            [self.dbManger deleteBill:_theBill];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    alert.animationStyle=LXASAnimationLeftShake;
    [alert showLXAlertView];
    
}

#pragma mark - 设置圆角
- (void)setCornerRadius:(id)view{
    [view jm_setCornerRadius:8 withBorderColor:[UIColor orangeColor] borderWidth:0.5];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"list2update"]) {
        [segue.destinationViewController setValue:_theBill forKey:@"theBill"];
    }
}

@end
