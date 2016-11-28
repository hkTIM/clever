//
//  waterBillViewController.m
//  clever
//
//  Created by 黄坤 on 16/6/3.
//  Copyright © 2016年 黄坤. All rights reserved.
//

#import "waterBillViewController.h"
#import "bill.h"
#import "billType.h"
#import "DatabaseManager.h"

@interface waterBillViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) DatabaseManager *dbManger;
@property (weak, nonatomic) IBOutlet UITableView *billTableView;
@property (nonatomic, strong) NSMutableDictionary *resultsDic;
@property (strong ,nonatomic) NSMutableArray *resultsArray;


@property (copy,nonatomic)NSIndexPath *selectIndexPath;//tableview的行号



@property (assign,nonatomic)BOOL isOpen;
@end

@implementation waterBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManger=[DatabaseManager sharedDBManager];
    self.allkeys=[self.dbManger selectBillofmonth];
    NSLog(@"time:%@",_allkeys);
   self.resultsDic = [NSMutableDictionary dictionary];
    for (int i=0; i<_allkeys.count; i++) {
       NSMutableArray *list=[self.dbManger readBillMonth:_allkeys[i]];
        [self.resultsDic setObject:list forKey:_allkeys[i]];
        NSLog(@"%@",_resultsDic);
    }

   

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


#pragma  mark -- table view Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
       return self.allkeys.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.isOpen==YES&&self.selectIndexPath.section==section) {
        return _resultsArray.count+1;
    }
       return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *monthID = @"waterbillCell";
    static NSString *billID = @"waterbillListCell";

    UITableViewCell *cell;
    if (indexPath.row==0) {
     cell = [tableView dequeueReusableCellWithIdentifier:monthID forIndexPath:indexPath];
        if (!self.allkeys||self.allkeys.count==0)
        {
            return cell;
        }
        NSString *key = self.allkeys[indexPath.section];
        NSMutableArray *results = self.resultsDic[key];
        float a=[self.dbManger moneyByincome:results];
        float b=[self.dbManger moneyByspending:results];
        float c=a-b;
        NSString *str=[NSString stringWithFormat:@"%.2f",a];
        NSString *str1=[NSString stringWithFormat:@"%.2f",b];
        NSString *str2=[NSString stringWithFormat:@"%.2f",c];
        UILabel *monthLable=(UILabel *)[cell viewWithTag:1];
        monthLable.text=key;
        UILabel *isIncome=(UILabel *)[cell viewWithTag:2];
        isIncome.text=str;
        UILabel *spend=(UILabel *)[cell viewWithTag:3];
        spend.text=str1;
        UILabel *balace=(UILabel *)[cell viewWithTag:4];
        balace.text=str2;
     }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:billID forIndexPath:indexPath];

            bill *bill = _resultsArray[indexPath.row-1];
            billType *type;
            type=[self.dbManger readBillType:bill.billTypeId];
            NSLog(@"%@",type);
            UIImageView *imageView=(UIImageView *)[cell viewWithTag:101];
            imageView.image=type.billImage;
            UILabel *nameLable=(UILabel *)[cell viewWithTag:102];
            nameLable.text=type.billTypeName;
            UITextField *textField=(UITextField *)[cell viewWithTag:103];
            textField.text=bill.billNote;
            UITextField *AmountField=(UITextField *)[cell viewWithTag:104];
            if (type.billIsincome==0)
            {
                NSString *str = [NSString stringWithFormat:@"-%.2f",bill.billAmount];
                AmountField.text=str;
            }
            else
            {
                NSString *str = [NSString stringWithFormat:@"%.2f",bill.billAmount];
                AmountField.text=str;
            }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isOpen) {
        if (indexPath.section==self.selectIndexPath.section) {
            if (indexPath.row==0) {
                self.isOpen=NO;

            }else{
                //处理跳转到bill详情
            }
        }else{
            self.selectIndexPath=indexPath;
            self.resultsArray=[self.dbManger readBillMonth:_allkeys[indexPath.section]];
            self.isOpen=YES;
        }
    }else{
        self.selectIndexPath=indexPath;
        self.resultsArray=[self.dbManger readBillMonth:_allkeys[indexPath.section]];
        self.isOpen=YES;
    }
    [tableView reloadData];


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
