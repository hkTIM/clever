//
//  chartViewController.m
//  clever
//
//  Created by 黄坤 on 16/5/18.
//  Copyright © 2016年 黄坤. All rights reserved.
//

#import "chartViewController.h"
#import "DatabaseManager.h"
#import "bill.h"
#import "billType.h"
#import "JHChartHeader.h"
#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height
@interface chartViewController ()

@property (nonatomic,strong) DatabaseManager * manager;
@property (nonatomic, strong) NSArray *monthArray;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *IncomeORspend;

@property (strong ,nonatomic) NSMutableArray *nameList;
@property (strong ,nonatomic) NSMutableArray *moneyList;
@property (assign ,nonatomic) NSInteger i;
@property (strong ,nonatomic) NSMutableArray *list;
@property(assign,nonatomic)BOOL isIncome;

@property (strong,nonatomic) bill *abill;
@property (strong,nonatomic) billType *type;


@end

@implementation chartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.i=0;
    self.isIncome=1;
    self.manager=[DatabaseManager sharedDBManager];
    self.monthArray=[self.manager selectBillofmonth];
    self.nameList=[NSMutableArray array];
    self.moneyList=[NSMutableArray array];
    NSLog(@"month:%@",self.monthArray);
    self.monthLabel.text=self.monthArray[self.i];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    [self giveViewVlue];
    [self showWaveChartUpView];
  
}
#pragma  mark - 收入支出类别选择器
- (IBAction)balanceSegmented:(UISegmentedControl *)sender {
    NSInteger index=sender.selectedSegmentIndex;
    NSLog(@"Index %li", (long)index);
    switch (index) {
        case 0:
            self.isIncome=1;

            [self.nameList removeAllObjects];
            [self.moneyList removeAllObjects];
            [self giveViewVlue];
            [self showWaveChartUpView];
            break;
        case 1:
            self.isIncome=0;
            [self.nameList removeAllObjects];
            [self.moneyList removeAllObjects];
            [self giveViewVlue];
            [self showWaveChartUpView];
            break;
            
        default:
            break;
    }
}
- (IBAction)leftBut:(id)sender {
    self.i--;
    if (self.i<0) {
        self.i=0;
    }
    self.monthLabel.text=self.monthArray[self.i];
    [self.nameList removeAllObjects];
    [self.moneyList removeAllObjects];
    [self giveViewVlue];
    [self showWaveChartUpView];
}
- (IBAction)rightBut:(id)sender {
    self.i++;
    if (self.i>=self.monthArray.count) {
        self.i=0;
    }
    self.monthLabel.text=self.monthArray[self.i];
    [self.nameList removeAllObjects];
    [self.moneyList removeAllObjects];
    [self giveViewVlue];
    [self showWaveChartUpView];
}
-(void)giveViewVlue
{
    self.list=[self.manager readBillMonth:self.monthArray[self.i]];
    NSLog(@"list:%@",self.list);
    for (int i=0;i<self.list.count;i++) {
        _abill=self.list[i];
        _type=[self.manager readBillType:_abill.billTypeId];
        if (self.isIncome==self.type.billIsincome)
        {
            [self.nameList addObject:_type.billTypeName];
            NSString *str=[NSString stringWithFormat:@"%.2f",_abill.billAmount];
            [self.moneyList addObject:str];
        }
    }

    NSLog(@"nameList=%@---moneyList=%@",self.nameList,self.moneyList);
}

#pragma mark ---饼图的实现
- (void)showWaveChartUpView{
    
    
    JHPieChart *pie = [[JHPieChart alloc] initWithFrame:CGRectMake(0, 100, 321, 321)];
    pie.center = CGPointMake(CGRectGetMaxX(self.view.frame)/2, CGRectGetMaxY(self.view.frame)/2);
    //装数据 金额
    pie.valueArr =self.moneyList;
    //装类别名
    pie.descArr = self.nameList;
    
    pie.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pie];
    pie.positionChangeLengthWhenClick = 15;
    [pie showAnimation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
