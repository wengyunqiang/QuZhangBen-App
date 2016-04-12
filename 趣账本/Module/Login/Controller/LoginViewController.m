//
//  LoginViewController.m
//  趣账本
//
//  Created by wengYQ on 15/12/14.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "LoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "IMCNetAPIManager.h"
#import "UserModel.h"
#import "AddRecordViewController.h"
#import "RegisterViewController.h"
#import "ChangePassWordVC.h"
#import <FMDB.h>

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
- (IBAction)ClickLoginBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *UserAccountTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (nonatomic,strong) AddRecordViewController *AddRecodeVC;
@property (nonatomic,strong) RegisterViewController *ResterVC;
@property (nonatomic,strong) ChangePassWordVC *ChangePwdVC;
@property (nonatomic,strong) UserModel *rootUser;
@property (nonatomic,strong) NSString *dbPath;
- (IBAction)ClickRegisterBtn:(id)sender;
- (IBAction)ClickForgetBtn:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"登录"];
    UIImage *image = [UIImage imc_imageWithColor:[UIColor colorWithRed:0.051 green:0.692 blue:0.805 alpha:1.000]];
    [_LoginBtn setBackgroundImage:image forState:UIControlStateNormal];
    [_LoginBtn.layer setCornerRadius:5];
    _LoginBtn.clipsToBounds = YES;
 //   [self checkCorrectness:_UserAccountTextField PasswordTextField:_PasswordTextField];
    
//FMDB
    NSString *DocPath = PATH_OF_DOCUMENT;
    NSString * path = [DocPath stringByAppendingPathComponent:@"user.sqlite"];
    self.dbPath = path;
    [self createTable];
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = @"select * from user";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            
        NSString  *UserAccount = [rs stringForColumn:@"UserAccount"];
        NSString *pass = [rs stringForColumn:@"password"];
            
            DLog(@"-------UserAccount------\n%@\n----------password-------\n%@",UserAccount,pass);
            
            
        if (UserAccount) {
            _UserAccountTextField.text = UserAccount;
            
            }
        }
        [db close];
    }
    
}

#pragma mark - 该界面的各个按钮点击方法
/**
 *  登录按钮点击方法
 */
- (IBAction)ClickLoginBtn:(id)sender {
   [self.view endEditing:YES];
    NSString *userAccount = _UserAccountTextField.text;
    //NSString *password = [_PasswordTextField.text imc_md5String];
    NSString *password = _PasswordTextField.text;
    
    if([userAccount isEqualToString:@""] || [password isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"帐号或密码不能为空"];
    }
    else{
        password = [password imc_md5String];
    NSDictionary *param = @{
                            @"userAccount" : userAccount,
                            };
    MCSelf(weakSelf);
    [[IMCNetAPIManager share] requestUserWithAccount:nil GetParams:param  andBlock:^(Response *response) {
        if (response.isSuccess) {
            NSError *error = Nil;
           weakSelf.rootUser = [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:response.data error:&error];
            if ([password isEqualToString:weakSelf.rootUser.password]) {
                //密码正确，进入下一个控制器
                DLog(@"密码正确，进入下一个界面");
                DLog(@"----------rootUser---------\n%@",weakSelf.rootUser);
                weakSelf.AddRecodeVC = [[AddRecordViewController alloc]initWithRootUser:weakSelf.rootUser];
                
                //FMDB 先清空原来的数据，再插入新的数据
                [self clearDB];
                
                FMDatabase * db = [FMDatabase databaseWithPath:weakSelf.dbPath];
                if ([db open]) {
                    NSString * sql = @"insert into user (UserAccount, password) values(?, ?) ";
                    NSString * UserAccount = weakSelf.rootUser.userAccount;
                    BOOL res = [db executeUpdate:sql, UserAccount, weakSelf.rootUser.password];
                    if (!res) {
                        DLog(@"error to insert data");
                    } else {
                        DLog(@"success to insert data");
                    }
                    [db close];
                }
                
                [self.navigationController pushViewController:weakSelf.AddRecodeVC animated:YES];
                
                [SVProgressHUD dismiss];
            }else{
                //密码不正确，显示提醒
                [SVProgressHUD showErrorWithStatus:@"密码错误"];
            }
        }
        else{
            if (response.code == 202) {
                //帐号不存在
                [SVProgressHUD showErrorWithStatus:@"该帐号不存在"];
            }
            
            if (response.code == 50000) {
                //网络错误
                [SVProgressHUD showInfoWithStatus:@"网络好像有点不给力，请重新再试"];
            }
        }
    }];
    }
}

/**
 *  快速注册按钮点击方法
 */
- (IBAction)ClickRegisterBtn:(id)sender {
    if (_ResterVC == nil) {
    _ResterVC = MCInitViewControllerFromStoryboard(@"Main", @"RegisterViewController");
    }
   [self.view endEditing:YES];
    [self.navigationController pushViewController:_ResterVC animated:YES];
}

/**
 *  点击忘记密码按钮方法
 */
- (IBAction)ClickForgetBtn:(id)sender {
   [self.view endEditing:YES];
    if (_ChangePwdVC == nil) {
        _ChangePwdVC = MCInitViewControllerFromStoryboard(@"Main", @"ChangePassWordVC");
    }
    [self.view endEditing:YES];
    [self.navigationController pushViewController:_ChangePwdVC animated:YES];
    
}

// 触摸背景，关闭键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    UIView *view = (UIView *)[touch view];
    if (view == self.view) {
        [self.view endEditing:YES];
    }
}

//#pragma mark - 帐号密码校验方法
//- (void) checkCorrectness:(UITextField *)userTextField PasswordTextField:(UITextField *)passwordTextField{
//    
//    RAC(_LoginBtn, enabled) = [RACSignal combineLatest:@[userTextField.rac_textSignal,
//                                                                passwordTextField.rac_textSignal]
//                                                       reduce:^(NSString *account, NSString *password){
//                                                           return @([account stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 5 &&
//                                                           [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 5);
//                                                       }];
//}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _UserAccountTextField) {
        [_PasswordTextField becomeFirstResponder];
    }
    return YES;
}


#pragma mark - FMDB

- (void) createTable{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == NO) {
        // create it
        FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            NSString * sql = @"CREATE TABLE 'user' ('UserAccount' VARCHAR(64), 'password' VARCHAR(64))";
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                DLog(@"error when creating db table");
            } else {
                DLog(@"success to creating db table");
            }
            [db close];
        } else {
            DLog(@"error when open db");
        }
    }else{
        if (![self isTableOK:@"user"]) {
            FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
            if ([db open]) {
                NSString * sql = @"CREATE TABLE 'user' ('UserAccount' VARCHAR(64), 'password' VARCHAR(64))";
                BOOL res = [db executeUpdate:sql];
                if (!res) {
                    DLog(@"error when creating db table");
                } else {
                    DLog(@"success to creating db table");
                }
                [db close];
            } else {
                DLog(@"error when open db");
            }
 
        }
    }
}

- (void)clearDB{
    FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString * sql = @"delete from user";
        BOOL res = [db executeUpdate:sql];
        if (!res) {
            DLog(@"error to delete db data");
        } else {
            DLog(@"success to delete db data");
        }
        [db close];
    }
}

// 判断是否存在表
- (BOOL) isTableOK:(NSString *)tableName
{   FMDatabase * db = [FMDatabase databaseWithPath:self.dbPath];
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

@end
