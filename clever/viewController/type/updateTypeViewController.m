//
//  updateTypeViewController.m
//  clever
//
//  Created by 黄坤 on 16/6/17.
//  Copyright © 2016年 黄坤. All rights reserved.
//

#import "updateTypeViewController.h"
#import "DatabaseManager.h"
#import "LXAlertView.h"

@interface updateTypeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *typeNmaeText;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong ,nonatomic)DatabaseManager *dbManger;
@property (strong ,nonatomic) NSArray *imageList;
@property (strong ,nonatomic) NSString *imageName;

@end

@implementation updateTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.dbManger=[DatabaseManager sharedDBManager];

    NSLog(@"%@",_theType);
    self.typeNmaeText.text=_theType.billTypeName;
    self.imageView.image=_theType.billImage;
    self.imageList=[[NSArray alloc]init];
    self.collectionView.backgroundColor=[UIColor whiteColor];
self.imageList=@[@"01.png",@"02.png",@"03.png",@"04.png",@"05.png",@"11.png",@"12.png",@"13.png",@"14.png",@"15.png",@"16.png",@"17.png",@"18.png",@"19.png",@"20.png",@"21.png",@"22.png",@"23.png",@"24.png",@"25.png",@"26.png",@"27.png",@"28.png",@"29.png",@"30.png",@"31.png",@"32.png",@"33.png",@"34.png",@"35.png",@"36.png",@"37.png",@"38.png",@"39.png",@"40.png",@"41.png"];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)blackBut:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];//返回方法
}

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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"updateTypeCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *imageView=[cell viewWithTag:101];
    imageView.image=[UIImage imageNamed:(self.imageList[indexPath.row])];
    
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
    
    self.imageView.image=[UIImage imageNamed:self.imageList[indexPath.row]];
    self.imageName=[NSString stringWithFormat:@"%@",self.imageList[indexPath.row]];

}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    
}
- (IBAction)saveDateBut:(UIBarButtonItem *)sender {
    if (self.typeNmaeText.text.length==0) {
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"修改提示" message:@"请输入类别名，类别名不得为🈳️！" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            NSLog(@"%ld",clickIndex);
            if (clickIndex==1) {
            }
        }];
        alert.animationStyle=LXASAnimationTopShake ;
        [alert showLXAlertView];
    }
    else
    {
    if (self.typeNmaeText.text.length>=6) {
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"修改提示" message:@"类别名不得超过5个字！" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            NSLog(@"%ld",clickIndex);
            if (clickIndex==1) {
            }
        }];
        alert.animationStyle=LXASAnimationTopShake ;
        [alert showLXAlertView];
    }
    else
    {
        if (self.imageName==nil) {
            _theType.billImageFillName=_theType.billImageFillName;
        }
        else
        {
            _theType.billImageFillName=self.imageName;
        }
    _theType.billTypeName=self.typeNmaeText.text;
    NSLog(@"%@-%@-%@-%@",_theType.billTypeId,_theType.billImageFillName,_theType.billTypeName,@(_theType.billIsincome));
        [self.dbManger upDataBillType:_theType];
    [self dismissViewControllerAnimated:YES completion:nil];
    }
    }
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
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
