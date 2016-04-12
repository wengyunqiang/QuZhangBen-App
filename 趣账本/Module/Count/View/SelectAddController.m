//
//  SelectAddController.m
//  趣账本
//
//  Created by wengYQ on 15/12/22.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "SelectAddController.h"
#import "FeeNameCell.h"
#import "UserModel.h"
#import "IMCNetAPIManager.h"
@interface SelectAddController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *FeeNames;
@property (nonatomic, strong) NSMutableDictionary *recodeLog;
@property (nonatomic,strong) NSArray *DBFeeNames;//数据库里对应的名称
@property (nonatomic,assign) CGFloat KeyBoardHeight;
@property (nonatomic,strong) UITextField *currentTextField;
@property (nonatomic,copy) NSString *feeName;
@end

@implementation SelectAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"添加记账"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 160)collectionViewLayout:layout];
    MCSelf(weakSelf);
    
    _FeeNames = [[NSArray alloc]initWithObjects:@"娱乐",@"餐饮",@"服装",@"交通",@"日用品",@"数码",@"话费",@"水电费",@"工资",@"奖金" ,@"兼职",@"红包",nil];
    _DBFeeNames = [[NSArray alloc]initWithObjects:@"playCost",@"eatCost",@"clothesCost",@"trafficCost",@"dailyCost",@"digitalCost",@"phoneCost",@"utilities",@"salary",@"reward",@"partTimeJob",@"luckyMoney", nil];
    
    _collectionView.delegate = self ;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[FeeNameCell class] forCellWithReuseIdentifier:kCCellIdentifierFeeCell];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.scrollEnabled = NO;
    [self.view addSubview:_collectionView];
    UILabel *moneyLb = [[UILabel alloc]init];
    [self.view addSubview:moneyLb];
    UITextField *moneyField = [[UITextField alloc]init];
    [self.view addSubview:moneyField];
    [moneyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(180);
        make.top.equalTo(weakSelf.collectionView.mas_bottom).offset(15);
        make.centerX.equalTo(weakSelf.view);
    }];
    moneyField.delegate = self;
    moneyField.layer.cornerRadius = 5;
    moneyField.backgroundColor = [UIColor colorWithWhite:0.939 alpha:1.000];
    moneyField.keyboardType = UIKeyboardTypeDecimalPad;
    moneyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    moneyField.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:15];
    //moneyField.textAlignment = NSTextAlignmentRight;
    [moneyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.collectionView.mas_bottom).offset(15);
        make.right.equalTo(moneyField.mas_left).offset(-8);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(30);
    }];
    moneyLb.text = @"金额:";
    [moneyLb setFont:[UIFont systemFontOfSize:15]];
    [moneyLb setTextColor:[UIColor orangeColor]];
    
    
    UIButton  *confirmBtn = [[UIButton alloc]init];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(moneyLb);
        make.width.mas_equalTo(50);
        make.left.mas_equalTo(moneyField.mas_right).offset(10);
        make.top.equalTo(moneyField);
    }];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.backgroundColor = [UIColor colorWithRed:0.044 green:0.783 blue:1.000 alpha:1.000];
    [confirmBtn addTarget:self action:@selector(ClickConfirm) forControlEvents:UIControlEventTouchUpInside];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _FeeNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = kCCellIdentifierFeeCell;
    FeeNameCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.FeeName = _FeeNames[indexPath.row];
    NSString *key = [NSString stringWithFormat:@"%li", (long)indexPath.section];
    if (self.recodeLog[key] && [self.recodeLog[key] integerValue] == indexPath.row) {
        cell.isSelected = YES;
    } else {
        cell.isSelected = NO;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(50, 30);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 30, 10, 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 30;
}

- (NSMutableDictionary *)recodeLog{
    if (!_recodeLog) {
        _recodeLog = [[NSMutableDictionary alloc] initWithCapacity:_FeeNames.count];
    }
    return _recodeLog;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [NSString stringWithFormat:@"%li", (long)indexPath.section];
    if (self.recodeLog[key]) {
        FeeNameCell *cell = (FeeNameCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[self.recodeLog[key] integerValue]
                                                                                                                inSection:indexPath.section]];
        cell.isSelected = NO;
    }
    FeeNameCell *cell = (FeeNameCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.isSelected = YES;
    _feeName = _DBFeeNames[indexPath.row];
    [self.recodeLog setValue:[NSNumber numberWithInteger:indexPath.row] forKey:key];
}

// 触摸背景，关闭键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    UIView *view = (UIView *)[touch view];
    if (view == self.view) {
        [self.view endEditing:YES];
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    const char * ch=[string cStringUsingEncoding:NSUTF8StringEncoding];
   	//有了小数点
    if([textField.text rangeOfString:@"."].length==1)
    {
        NSUInteger length=[textField.text rangeOfString:@"."].location;
        
        //小数点后面两位小数 且不能再是小数点
        if([[textField.text substringFromIndex:length] length]>3 || *ch ==46)   //3表示后面小数位的个数。。
            
            return NO;
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    
    CGRect rect = textField.frame;
    CGFloat offset = CGRectGetMaxY(rect) - (self.view.frame.size.height - _KeyBoardHeight);
    if (offset > 0) {
        [UIView animateWithDuration:0.15 animations:^{
            
            [self.view imc_setY:-offset+50];
        }];
    }
}

#pragma mark - 键盘出现和消失的执行方法
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _KeyBoardHeight = keyboardRect.size.height;
    CGRect rect = _currentTextField.frame;
    CGFloat offset = CGRectGetMaxY(rect) - (self.view.frame.size.height - _KeyBoardHeight);
    
    if (offset > 0) {
        [UIView animateWithDuration:0.15 animations:^{
            
            [self.view imc_setY:-offset+50];
        }];
    }
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self.view imc_setY:64];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)ClickConfirm{
    [_currentTextField endEditing:YES];
    NSString *money = _currentTextField.text;
    float m = [money floatValue];
    if (m > 0 && _feeName) {
        //发送网络请求，更新账本
        NSString *date = [self getCurrentTime];
        NSString *userID = self.rootUser.userID;
        NSDictionary *param = @{
                                @"date" :  date,
                                @"userID" : userID,
                                @"FeeName" : _feeName,
                                @"FeeValue" : money
                                };
        MCSelf(weakSelf);
        [[IMCNetAPIManager share] RequestUpLoadRecord:param andBlock:^(Response *response) {
            if (response.isSuccess) {
                weakSelf.currentTextField.text = @"";
                [weakSelf.navigationController popViewControllerAnimated:YES];
                weakSelf.finishAddBlock();
                [SVProgressHUD showImage:nil status:@"添加成功"];
            }
        }];
       
    }else{
        _currentTextField.text = @"";
        [SVProgressHUD showImage:nil status:@"请选择账目并填写金额"];
    
    }
}

#pragma mark --- 获取系统当前时间
-(NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
@end
