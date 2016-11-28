//
//  TestViewController.m
//  clever
//
//  Created by 黄坤 on 16/6/17.
//  Copyright © 2016年 黄坤. All rights reserved.
//

#import "TestViewController.h"
#import "billType.h"
#import "DatabaseManager.h"
@interface TestViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (strong ,nonatomic)DatabaseManager *dbManger;
@property (strong ,nonatomic)billType *theType;
@property (strong,nonatomic) NSArray *imageList;
@property(assign,nonatomic)BOOL isIncome;
@property (weak, nonatomic) IBOutlet UIButton *addTypeBut;



@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.CollectionView.delegate=self;
    self.CollectionView.dataSource=self;
    
    _theType=[[billType alloc]init];
    self.dbManger=[DatabaseManager sharedDBManager];
    
    self.CollectionView.backgroundColor = [UIColor clearColor];//CollectionView背景颜色
    
    self.imageList=[[DatabaseManager sharedDBManager]readBillTypeList:self.isIncome];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
      [self balanceSegmented:self.segment];
}
- (IBAction)returnBlack:(UIBarButtonItem *)sender {
     [self dismissViewControllerAnimated:YES completion:nil];//返回方法
}

#pragma  mark - 收入支出类别选择器
- (IBAction)balanceSegmented:(UISegmentedControl *)sender {
    NSInteger index=sender.selectedSegmentIndex;
    NSLog(@"Index %li", (long)index);
    switch (index) {
        case 0:
            self.isIncome=1;
            self.imageList=[self.dbManger readBillTypeList:self.isIncome];
            NSLog(@"%i",self.isIncome);
            [self.CollectionView reloadData];
            break;
        case 1:
            self.isIncome=0;
            self.imageList=[self.dbManger readBillTypeList:self.isIncome];
            NSLog(@"%i",self.isIncome);
            [self.CollectionView reloadData];
            break;
            
        default:
            break;
    }
}

#pragma mark-- Collection View Data Source
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageList.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"typeCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *imageView=[cell viewWithTag:101];
    UILabel *label=[cell viewWithTag:102];
    billType *type=self.imageList[indexPath.row];
    imageView.image=[UIImage imageNamed:type.billImageFillName];
    label.text=type.billTypeName;
    cell.layer.masksToBounds=YES;
    cell.layer.cornerRadius=10;
    return cell;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //临时改变个颜色，看好，只是临时改变的。如果要永久改变，可以先改数据源，然后在cellForItemAtIndexPath中控制。（和UITableView差不多吧！O(∩_∩)O~）
    cell.backgroundColor = [UIColor lightGrayColor];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc=segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"type2update"])
    {
        NSIndexPath * indexPath = [self.CollectionView indexPathForCell:sender];
         billType *type=self.imageList[indexPath.row];
        [vc setValue:type forKey:@"theType"];
    }

}


@end
