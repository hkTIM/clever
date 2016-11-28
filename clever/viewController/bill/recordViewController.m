//
//  recordViewController.m
//  clever
//
//  Created by 黄坤 on 16/5/20.
//  Copyright © 2016年 黄坤. All rights reserved.
//

#import "recordViewController.h"
#import "billType.h"
#import "bill.h"
#import "DatabaseManager.h"
#import "UIView+RoundedCorner.h"
#import "SZCalendarPicker.h"
#import "RKAlertView.h"
#import "LXAlertView.h"

@interface recordViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *typeName;
@property (weak, nonatomic) IBOutlet UITextField *billAmount;
@property (weak, nonatomic) IBOutlet UICollectionView *typeCollectionView;
@property (strong ,nonatomic)billType *theType;
@property (strong ,nonatomic)bill *theBill;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (strong ,nonatomic)DatabaseManager *dbManger;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *noteLab;

@property (strong,nonatomic) NSArray *imageList;

@property(assign,nonatomic)BOOL isIncome;


@property (strong ,nonatomic) NSString *noteString;
@property (strong ,nonatomic) NSString *day;
@property (strong ,nonatomic) NSString *date;


//keyboard
@property (weak, nonatomic) IBOutlet UIButton *one;//1
@property (weak, nonatomic) IBOutlet UIButton *two;//2
@property (weak, nonatomic) IBOutlet UIButton *three;//3
@property (weak, nonatomic) IBOutlet UIButton *four;//4
@property (weak, nonatomic) IBOutlet UIButton *five;//5
@property (weak, nonatomic) IBOutlet UIButton *six;//6
@property (weak, nonatomic) IBOutlet UIButton *seven;//7
@property (weak, nonatomic) IBOutlet UIButton *eight;//8
@property (weak, nonatomic) IBOutlet UIButton *nine;//9
@property (weak, nonatomic) IBOutlet UIButton *dot;//点号
@property (weak, nonatomic) IBOutlet UIButton *zero;//0
@property (weak, nonatomic) IBOutlet UIButton *delete;
@property (weak, nonatomic) IBOutlet UIButton *save;
@property (strong ,nonatomic) NSString *result;
@property  (nonatomic,assign)  BOOL isUseInEnteringANumber;





@end

@implementation recordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.typeCollectionView.delegate=self;
    self.typeCollectionView.dataSource=self;
    
    _theType=[[billType alloc]init];
    self.dbManger=[DatabaseManager sharedDBManager];

    self.typeCollectionView.backgroundColor = [UIColor clearColor];//CollectionView背景颜色
    [self setCornerRadius:self.timeLab];//设置label圆角
    [self setCornerRadius:self.noteLab];//设置label圆角

    self.imageList=[[DatabaseManager sharedDBManager]readBillTypeList:self.isIncome];
    NSLog(@"%i",self.isIncome);

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self balanceSegmented:self.segment];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    NSDateFormatter  *dateTime=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"M-d"];
    [dateTime setDateFormat:@"YYYY-MM-dd"];
    self.date=[dateformatter stringFromDate:senddate];
    NSString *timenow=[dateTime stringFromDate:senddate];
    self.timeLab.text=self.date;
    self.day=timenow;
    
}

#pragma mark - 设置圆角
- (void)setCornerRadius:(id)view{
    [view jm_setCornerRadius:8 withBorderColor:[UIColor orangeColor] borderWidth:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark--关闭跳转页面操作
- (IBAction)return:(UIBarButtonItem *)sender {
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
            self.theType=self.imageList[0];
            self.typeImage.image=[UIImage imageNamed:self.theType.billImageFillName];
            self.typeName.text=self.theType.billTypeName;
            [self.typeCollectionView reloadData];
            break;
        case 1:
            self.isIncome=0;
            self.imageList=[self.dbManger readBillTypeList:self.isIncome];
            NSLog(@"%i",self.isIncome);
            self.theType=self.imageList[0];
            self.typeImage.image=[UIImage imageNamed:self.theType.billImageFillName];
            self.typeName.text=self.theType.billTypeName;
            [self.typeCollectionView reloadData];
            break;
            
        default:
            break;
    }
}
- (IBAction)timeBut:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.layer.cornerRadius = 10;
    calendarPicker.layer.masksToBounds = YES;
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(25, 100, self.view.frame.size.width-50, 352);
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        weakSelf.timeLab.text = [NSString stringWithFormat:@"%ld-%ld",month,(long)day];
        if (month<10) {
            if (day<10) {
                self.day=[NSString stringWithFormat:@"%ld-0%ld-0%ld",year,month,(long)day];
            }
            else
            {
                 self.day=[NSString stringWithFormat:@"%ld-0%ld-%ld",year,month,(long)day];
            }
        }
        else
        {
            if (day<10) {
                self.day=[NSString stringWithFormat:@"%ld-%ld-0%ld",year,month,(long)day];
            }
            else
            {
                self.day=[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,(long)day];
            }

        }
    
    };
}
- (IBAction)noteBut:(UIButton *)sender {
    [RKAlertView showAlertPlainTextWithTitle:@"备注" message:@"请输入备注（可以选择取消不用备注）" cancelTitle:@"取消" confirmTitle:@"确认" alertViewStyle:UIAlertViewStylePlainTextInput confrimBlock:^(UIAlertView *alertView)
     {
        NSLog(@"确认了输入：%@",[alertView textFieldAtIndex:0].text);
        self.noteString=[alertView textFieldAtIndex:0].text;
        NSLog(@"%@",self.noteString);
    } cancelBlock:^{
        NSLog(@"取消了");
    }];

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
    UIImageView *imageView=[cell viewWithTag:1];
    UILabel *label=[cell viewWithTag:2];
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
    
    self.theType=self.imageList[indexPath.row];
    self.typeImage.image=[UIImage imageNamed:self.theType.billImageFillName];
    self.typeName.text=self.theType.billTypeName;

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

#pragma mark---keyboard Action

- (IBAction)deleteBut:(UIButton *)sender {

    self.dot.enabled=YES;
    [self enabledIsYes];
    _isUseInEnteringANumber=NO;

    
    NSMutableString *a=[NSMutableString stringWithFormat:@"%@",self.result];
    
    long length = a.length-1 ;
    if (length >= 0) {
        [a deleteCharactersInRange:NSMakeRange(length, 1)];//只删除一个
    }
    self.result=[NSString stringWithFormat:@"%@",a];
    self.billAmount.text=_result;
}
- (IBAction)saveBut:(UIButton *)sender {
    if (self.billAmount.text.length==0) {
        LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告⚠️" message:@"请输入金额，金额不得为🈳️！" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
            NSLog(@"%ld",clickIndex);
            if (clickIndex==1) {
            }
        }];
        alert.animationStyle=LXASAnimationNO  ;
        [alert showLXAlertView];
    }
    else
    {
        if (self.billAmount.text.length>=8) {
            LXAlertView *alert=[[LXAlertView alloc] initWithTitle:@"警告⚠️" message:@"输入金额超出范围！" cancelBtnTitle:@"取消" otherBtnTitle:@"确定" clickIndexBlock:^(NSInteger clickIndex) {
                NSLog(@"%ld",clickIndex);
                if (clickIndex==1) {
                }
            }];
            alert.animationStyle=LXASAnimationNO  ;
            [alert showLXAlertView];
        }
        else
        {
        _theBill=[[bill alloc]init];
        _theBill.billTypeId=_theType.billTypeId;
        _theBill.billAmount=[_billAmount.text floatValue];
        _theBill.billNote=_noteString;
        _theBill.billDate=_day;
        NSLog(@"%@-%f-%@-%@-",_theBill.billTypeId,_theBill.billAmount,_theBill.billNote,_theBill.billDate);
        [self.dbManger addBillList:_theBill];
        [self dismissViewControllerAnimated:YES completion:nil];//返回方法
     }
    }
}
- (IBAction)digitPressed:(UIButton *)sender {
    NSLog(@"%li",sender.tag);
    NSInteger i=sender.tag;
    NSString *digit;
    if (i==11) {
        digit=@".";
        NSLog(@"%@",digit);
    }else
    {
       digit=[NSString stringWithFormat:@"%ld",i];
    }
    if (_isUseInEnteringANumber) {
        
        if ([digit isEqualToString:@"."]) {
            self.dot.enabled=NO;//关闭.
            [self enabledIsYes];
        }
        
        self.result = [self.result stringByAppendingString:digit];
        
    }
    else if(!_isUseInEnteringANumber){
        
        if ([digit isEqualToString:@"."]) {
            
            self.result=[NSString stringWithFormat:@"0%@",digit];
            self.dot.enabled=NO;
            
        }
        else{
            
            self.result= digit;
        }
        _isUseInEnteringANumber = YES;
    }

    self.billAmount.text=_result;
    
}
-(void)enabledIsNo{
    self.zero.enabled=NO;
    self.one.enabled=NO;
    self.two.enabled=NO;
    self.three.enabled=NO;
    self.four.enabled=NO;
    self.five.enabled=NO;
    self.six.enabled=NO;
    self.seven.enabled=NO;
    self.nine.enabled=NO;
}
-(void)enabledIsYes{
    self.zero.enabled=YES;
    self.one.enabled=YES;
    self.two.enabled=YES;
    self.three.enabled=YES;
    self.four.enabled=YES;
    self.five.enabled=YES;
    self.six.enabled=YES;
    self.seven.enabled=YES;
    self.nine.enabled=YES;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    UIViewController *vc=segue.destinationViewController;
// 
//    }
//
//
//}


@end
