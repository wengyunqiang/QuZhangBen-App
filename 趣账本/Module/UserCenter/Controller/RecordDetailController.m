//
//  RecordDetailController.m
//  趣账本
//
//  Created by wengYQ on 15/12/27.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "RecordDetailController.h"
#import "RecordListCell.h"
#import "DetailMoneyCell.h"
#import "IMCNetAPIManager.h"
#import "IMCPickerView.h"
@interface RecordDetailController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *keysArray;
@property (nonatomic,strong) UIButton *confirmBtn;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,strong) UITextField *Field;
@property (nonatomic,strong) UILabel *Label;
@property (nonatomic,strong) IMCPickerView *pickerView;
@end

@implementation RecordDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"明细";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44*3)];
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RecordListCell class]) bundle:nil] forCellReuseIdentifier:@"RecordListCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DetailMoneyCell class]) bundle:nil] forCellReuseIdentifier:@"DetailMoneyCell"];
    _keysArray = [[NSArray alloc]initWithObjects:@"记账金额",@"分类",@"记账时间", nil];
//    _valuesArray = [[NSArray alloc]initWithObjects:@"12",@"交通",@"2015-12-26", nil];
    _confirmBtn = [[UIButton alloc]init];
    [self.view addSubview:_confirmBtn];
    MCSelf(weakSelf);
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableView.mas_bottom).offset(20);
        make.height.mas_equalTo(35);
        make.left.equalTo(weakSelf.view).offset(30);
        make.right.equalTo(weakSelf.view).offset(-30);
    }];
    [_confirmBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = [UIColor whiteColor];
    _confirmBtn.layer.borderWidth = 1;
    _confirmBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    _confirmBtn.layer.cornerRadius = 5;
    _confirmBtn.clipsToBounds = YES;
    [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    _deleteBtn = [[UIButton alloc]init];
    [self.view addSubview:_deleteBtn];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.confirmBtn.mas_bottom).offset(20);
        make.height.mas_equalTo(35);
        make.left.equalTo(weakSelf.view).offset(30);
        make.right.equalTo(weakSelf.view).offset(-30);
    }];
    [_deleteBtn setTitle:@"删除此条" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _deleteBtn.backgroundColor = [UIColor whiteColor];
    _deleteBtn.layer.borderWidth = 1;
    _deleteBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    _deleteBtn.layer.cornerRadius = 5;
    _deleteBtn.clipsToBounds = YES;
    [_deleteBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    
    [_confirmBtn addTarget:self action:@selector(ClickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn addTarget:self action:@selector(ClickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.reloadDataBlock = ^{
        [weakSelf.tableView reloadData];
    };
}


#pragma mark - UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        static NSString *identifier = @"DetailMoneyCell";
        DetailMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[DetailMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.moneyField.text = _valuesArray[indexPath.row];
        cell.moneyField.delegate = self;
        _Field = cell.moneyField;
        return cell;
    }
    
    static NSString *identifier = @"RecordListCell";
    RecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[RecordListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.FeeNameLb.text = _keysArray[indexPath.row];
    
    cell.FeeValueLb.text = _valuesArray[indexPath.row];
    
    if (indexPath.row == 1) {
        _Label = cell.FeeValueLb;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        DetailMoneyCell *cell = (DetailMoneyCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.moneyField becomeFirstResponder];
    }else if (indexPath.row == 1){
        [self.view endEditing:YES];
        RecordListCell *cell = (RecordListCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (_pickerView == nil) {
            _pickerView = [[IMCPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 240, self.view.frame.size.width, 240)  content:@[ @"娱乐" ,@"餐饮",@"服装", @"交通",                                                                                                                                                            @"日用品" ,@"数码",@"话费",@"水电费", @"工资",@"奖金",@"兼职"] type:IMCPickerViewTypePickerView title:@"选择分类" selecedBlock:^(NSString *selectedItem) {
                cell.FeeValueLb.text = selectedItem;
            }];
        }
        [_pickerView showInNavigationController:self.navigationController];
    }else{
        [self.view endEditing:YES];
    }
}

// 触摸背景，关闭键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    UIView *view = (UIView *)[touch view];
    if (view == self.view) {
        [self.view endEditing:YES];
    }
}


#pragma mark -- Button

-(void)ClickConfirmBtn{
    [self.view endEditing:YES];
    NSString *date = self.valuesArray[2];
    
    NSString *money = _Field.text;
    
    NSString *FeeName = _Label.text;
    
    NSString *OldName = self.valuesArray[1];
    
    NSDictionary *param = @{
                            @"date"   : date,
                            @"method" : @"edit",
                            @"FeeName": FeeName,
                            @"FeeValue":money,
                            @"userID" :self.userID,
                            @"oldFeeName":OldName
                            };
    
    MCSelf(weakSelf);
    [[IMCNetAPIManager share]RequestChangeRecord:param andBlock:^(Response *response) {
        weakSelf.finishEditBlock();
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    }];
 
}

-(void)ClickDeleteBtn{
    [self.view endEditing:YES];
    MCSelf(weakSelf);
    UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要删除这条账目吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alterView bk_setHandler:^{
        NSString *date = weakSelf.valuesArray[2];
        
        NSString *FeeName = weakSelf.Label.text;
        
        NSDictionary *param = @{
                                @"date"   : date,
                                @"method" : @"delete",
                                @"FeeName": FeeName,
                                @"userID" :weakSelf.userID
                                };
        
        [[IMCNetAPIManager share]RequestChangeRecord:param andBlock:^(Response *response) {
            weakSelf.finishEditBlock();
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        }];

    } forButtonAtIndex:1];
    [alterView show];
    
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
