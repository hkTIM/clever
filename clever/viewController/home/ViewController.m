//
//  ViewController.m
//  clever
//
//  Created by 黄坤 on 16/5/4.
//  Copyright © 2016年 黄坤. All rights reserved.
//

#import "ViewController.h"
#import "DatabaseManager.h"
#import "billType.h"
#import "bill.h"
#import "TestViewController.h"
#import "WHC_GestureUnlockScreenVC.h"
@interface ViewController ()
<
UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate
>

@property (strong,nonatomic) DatabaseManager *dbManger;
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;///<收入金额
@property (weak, nonatomic) IBOutlet UILabel *spendingLab;///<支出金额
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;///<结余金额
@property (weak, nonatomic) IBOutlet UILabel *monthIncomeLab;///<x月收入
@property (weak, nonatomic) IBOutlet UILabel *monthBalanceLab;///<x月结余
@property (weak, nonatomic) IBOutlet UILabel *monthSpendingLab;///<x月支出

@property (weak, nonatomic) IBOutlet UITableView *billTableView;///<账单列表
@property (strong,nonatomic) NSString *nweMonth;
@property (strong,nonatomic) NSString *nweYear;

@property (strong,nonatomic) NSString *date;
@property (strong,nonatomic) NSMutableArray *billList;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.navigationController.navigationBar.hidden = YES;
        self.dbManger=[DatabaseManager sharedDBManager];
        self.allkeys = [NSArray array];
    
    self.billTableView.delegate=self;
    self.billTableView.dataSource=self;
    //获取当前系统年份，月份
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    NSDateFormatter  *date=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"M"];
    [date setDateFormat:@"YY"];
    self.nweMonth=[dateformatter stringFromDate:senddate];
    self.nweYear=[date stringFromDate:senddate];
    NSLog(@"locationString:%@",self.nweMonth);
    self.monthIncomeLab.text=[NSString stringWithFormat:@"%@月收入",_nweMonth];
    self.monthSpendingLab.text=[NSString stringWithFormat:@"%@月支出",_nweMonth];
    self.monthBalanceLab.text=[NSString stringWithFormat:@"%@月结余",_nweMonth];

    // Do any additional setup after loading the view, typically from a nib.

    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.hidden = YES;
    NSDictionary *dic = [self.dbManger queryTimeNotDuplicateData];
    self.dataDic = dic;
    self.allkeys = [self sortArray:dic.allKeys ascending:NO];

    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateTime=[[NSDateFormatter alloc] init];
    [dateTime setDateFormat:@"YYYY-MM-dd"];
    self.date=[dateTime stringFromDate:senddate];
    self.billList=[self.dbManger readBillListOfType:_date];
    [self calculateMonthsMoney];
    [self.billTableView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)calculateMonthsMoney
{
    float a=[self.dbManger moneyByincome:_billList];
    float b=[self.dbManger moneyByspending:_billList];
    float c=a-b;
    NSString *str=[NSString stringWithFormat:@"%.2f",a];
    NSString *str1=[NSString stringWithFormat:@"%.2f",b];
    NSString *str2=[NSString stringWithFormat:@"%.2f",c];
    self.incomeLab.text=str;
    self.spendingLab.text=str1;
    self.balanceLab.text=str2;

}
#pragma mark - 排序
- (NSArray *)sortArray:(NSArray *)array ascending:(BOOL)ascending{
    //比较操作
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch
    | NSNumericSearch
    | NSWidthInsensitiveSearch
    | NSForcedOrderingSearch;
    NSLocale *currentLocale = [NSLocale currentLocale];
    
    NSArray *finderSortArray = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSRange string1Range = NSMakeRange(0, [obj2 length]);
        //ascending ? 生序:降序
        return ascending?[obj1 compare:obj2 options:comparisonOptions range:string1Range locale:currentLocale]:[obj2 compare:obj1 options:comparisonOptions range:string1Range locale:currentLocale];
    }];
    return finderSortArray;
    
}
#pragma mark--ActionSheet实现类别管理页面跳转
- (IBAction)typeBut:(UIButton *)sender {
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"管理" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"类别管理",nil];
    [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"类别管理"]) {
        UIViewController *spotVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"typemange"];
        spotVC.modalTransitionStyle=UIModalTransitionStyleCoverVertical;//present方式
        [self presentViewController:spotVC animated:YES completion:nil];
    }
}
#pragma  mark--跳转页面至添加账单页面
- (IBAction)recordBut:(UIButton *)sender {
    UIViewController *spotVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"recordView"];
    spotVC.modalTransitionStyle=UIModalTransitionStyleCoverVertical;//present方式
    [self presentViewController:spotVC animated:YES completion:nil];
   
}

#pragma  mark -- table view Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return self.billMangers.count;
    return self.allkeys.count;
//    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.allkeys[section];
    NSArray *results = self.dataDic[key];
    return results.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"billCell" forIndexPath:indexPath];
    if (!self.allkeys||self.allkeys.count==0)
    {
        return cell;
    }
    NSString *key = self.allkeys[indexPath.section];
    NSArray *results = self.dataDic[key];
    bill *bill = results[indexPath.row];
    NSLog(@"%@",results);
    billType *Type=[self.dbManger readBillType:bill.billTypeId];
    NSLog(@"%@",Type);
    UIImageView *imageView=(UIImageView *)[cell viewWithTag:101];
    imageView.image=Type.billImage;
    UILabel *nameLable=(UILabel *)[cell viewWithTag:102];
    nameLable.text=Type.billTypeName;
    UITextField *textField=(UITextField *)[cell viewWithTag:103];
    textField.text=bill.billNote;
    UITextField *AmountField=(UITextField *)[cell viewWithTag:104];
    if (Type.billIsincome==0) {
        NSString *str = [NSString stringWithFormat:@"-%.2f",bill.billAmount];
        AmountField.text=str;
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"%.2f",bill.billAmount];
        AmountField.text=str;
    }
       return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   return self.allkeys[section];
}
//tableView 滑动动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.layer.transform=CATransform3DMakeScale(0.2, 0.2, 1);
    
    [UIView animateWithDuration:1 animations:^{
        cell.layer.transform=CATransform3DIdentity;
    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc=segue.destinationViewController;
    if (
    [segue.identifier isEqualToString:@"table2list"])
    {
        NSIndexPath * indexPath = [self.billTableView indexPathForCell:sender];
        NSString *key = self.allkeys[indexPath.section];
        NSArray *results = self.dataDic[key];
        bill *bill = results[indexPath.row];
        [vc setValue:bill forKey:@"theBill"];
    }

}


@end
