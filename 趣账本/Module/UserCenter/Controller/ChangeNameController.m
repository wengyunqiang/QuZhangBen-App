//
//  ChangeNameController.m
//  趣账本
//
//  Created by wengYQ on 15/12/26.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "ChangeNameController.h"
#import "IMCNetAPIManager.h"

@interface ChangeNameController ()
@property (nonatomic,strong) UITextField *NameField;
@end

@implementation ChangeNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
    self.navigationItem.title = @"修改昵称";
    UIButton  *saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    NSShadow *shadow    = [[NSShadow alloc] init];
    shadow.shadowColor  = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [saveBtn setTitleShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8] forState:UIControlStateNormal];
    
    NSAttributedString *str= [[NSAttributedString alloc]initWithString:@"保存" attributes:@{
                                                                                         NSForegroundColorAttributeName : [UIColor colorWithRed:0.961 green:1.000 blue:0.984 alpha:1.000],
                                                                                         NSShadowAttributeName : shadow,
                                                                                         NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16.0]}];
    
    [saveBtn setAttributedTitle:str forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithCustomView:saveBtn];
    
    self.navigationItem.rightBarButtonItem = saveItem;
    _NameField = [[UITextField alloc]init];
    [self.view addSubview:_NameField];
    _NameField.backgroundColor = [UIColor whiteColor];
    _NameField.font = [UIFont systemFontOfSize:16];
    [_NameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.view).offset(20);
    }];
    _NameField.text = self.RootUser.userName;
    _NameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_NameField becomeFirstResponder];
}

-(void)save{
    [self.view endEditing:YES];
    MCSelf(weakSelf);
    NSDictionary *nameParam = @{@"propertyName" : @"userName",
                                @"propertyValue": weakSelf.NameField.text,
                                @"userID"       : weakSelf.RootUser.userID
                                };
    [[IMCNetAPIManager share] RequestUserProperty:nameParam andBlock:^(Response *response) {
        if (response.isSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            weakSelf.name = weakSelf.NameField.text;
            weakSelf.saveBlock();
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            [SVProgressHUD showInfoWithStatus:@"修改失败，网络好像有点不给力"];
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
