//
//  setUpViewController.m
//  clever
//
//  Created by 黄坤 on 16/6/21.
//  Copyright © 2016年 黄坤. All rights reserved.
//

#import "setUpViewController.h"
#import "WHC_GestureUnlockScreenVC.h"
#import "LXAlertView.h"
@interface setUpViewController ()
{
    WHC_GestureUnlockScreenVC  * vc;
}
@property (weak, nonatomic) IBOutlet UIView *setView;
@property (weak, nonatomic) IBOutlet UISwitch *password;
@property (weak, nonatomic) IBOutlet UISwitch *gesturesSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *numberSwitch;
@property (assign ,nonatomic) BOOL isOpen;
@property (assign ,nonatomic) BOOL passOpen;
@property (strong, nonatomic) NSNumber * passIsSet;
@property (strong, nonatomic) NSNumber * passType;

@end

@implementation setUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    self.passIsSet=[user objectForKey:@"needPassword"];///<是否需要密码
    self.passType=[user objectForKey:@"passType"];///<密码类型
    NSLog(@"%@密码，密码类型是：%d",self.passIsSet.boolValue?@"有":@"无", self.passType.intValue);
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    BOOL isSet=[self.passIsSet boolValue];
    if (isSet==1)
    {
        [self.password setOn:YES];
        [self.setView setHidden:NO];
        if (self.passType.intValue==1)
        {
            [self.numberSwitch setOn:YES];
        }
        if (self.passType.intValue==2)
        {
            [self.gesturesSwitch setOn:YES];
        }
    }else
    {
        [self.setView setHidden:YES];
        [self.password setOn:NO];
    }
    
    NSLog(@"%@密码，密码类型是：%d",self.passIsSet.boolValue?@"有":@"无", self.passType.intValue);
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:self.passIsSet forKey:@"needPassword"];
    [user setObject:self.passType forKey:@"passType"];
    switch (self.passType.intValue) {
        case 0:{
            [self.gesturesSwitch setOn:NO];
            [self.numberSwitch setOn:NO];
            break;
        }
            case 1:
        {
            [self.gesturesSwitch setOn:NO];
            [self.numberSwitch setOn:YES];
            break;
            
        }
            case 2:
        {
            [self.gesturesSwitch setOn:YES];
            [self.numberSwitch setOn:NO];
               break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)needPassword:(UISwitch *)sender {
    self.passOpen=[sender isOn];
    if (self.passOpen)
    {
        [self.setView setHidden:NO];///<打开具体密码界面
    }
    else
    {
        [WHC_GestureUnlockScreenVC removeGesturePasswordWithVC:self];///<关闭并且删除密码
         [self.setView setHidden:YES];
    }
}
- (IBAction)gestures:(UISwitch *)sender {
     self.isOpen=[sender isOn];
    if (_isOpen)
    {
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"密码设置警告⚠️" message:@"请记牢密码，忘记密码后将无法在此打开应用⚠️" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                NSLog(@"%ld",clickIndex);
                if (clickIndex==1) {
                     [WHC_GestureUnlockScreenVC setUnlockScreenWithType:GestureDragType];
                }
            }];
            alert.animationStyle=LXASAnimationTopShake ;
            [alert showLXAlertView];
        [self.gesturesSwitch setOn:NO];
      
    }
    else
    {
        [WHC_GestureUnlockScreenVC removeGesturePasswordWithVC:self];
    }
     [self.setView setHidden:NO];
}
- (IBAction)number:(UISwitch *)sender {
    self.isOpen=[sender isOn];
    if (_isOpen)
    {
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"密码设置警告⚠️" message:@"请记牢密码，忘记密码后将无法在此打开应用⚠️" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            NSLog(@"%ld",clickIndex);
            if (clickIndex==1) {
                [WHC_GestureUnlockScreenVC setUnlockScreenWithType:ClickNumberType];
            }
        }];
        alert.animationStyle=LXASAnimationTopShake ;
        [alert showLXAlertView];
        [self.numberSwitch setOn:NO];
    }
    else
    {
        [WHC_GestureUnlockScreenVC removeGesturePasswordWithVC:self];
    }
 
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
