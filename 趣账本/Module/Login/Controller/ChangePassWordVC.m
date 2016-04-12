//
//  ChangePassWordVC.m
//  趣账本
//
//  Created by wengYQ on 15/12/15.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "ChangePassWordVC.h"
#import "IMCNetAPIManager.h"
@interface ChangePassWordVC()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *NameField;
@property (weak, nonatomic) IBOutlet UITextField *AccountField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordField;
@property (weak, nonatomic) IBOutlet UITextField *ConfirmField;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmBtn;
@property (nonatomic,strong) UITextField *currentTextField;
@property (nonatomic,assign) CGFloat KeyBoardHeight;
- (IBAction)ClickConfirmBtn:(id)sender;

@end
@implementation ChangePassWordVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"更改密码"];
    [self.view bk_whenTapped:^{
        [self.view endEditing:YES];
    }];
    UIImage *image = [UIImage imageNamed:@"LoginBackGround.jpg"];
    [_ConfirmBtn setBackgroundImage:image forState:UIControlStateNormal];
    [_ConfirmBtn.layer setCornerRadius:5];
    _ConfirmBtn.clipsToBounds = YES;
    
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
    /**
     *  设置代理
     */
    
    _NameField.delegate     = self;
    _AccountField.delegate  = self;
    _PasswordField.delegate = self;
    _ConfirmField.delegate  = self;
}


- (IBAction)ClickConfirmBtn:(id)sender {
    [self.view endEditing:YES];
    BOOL isCorrect =  [_NameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0 && [_PasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 5 &&[_ConfirmField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length >5 && [_AccountField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length >5 ;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    if (!isCorrect) {
        [SVProgressHUD showErrorWithStatus:@"请检查输入的文本长度是否达标"];
    }else{
        BOOL passwordIsRight = [_PasswordField.text isEqualToString:_ConfirmField.text];
        if (!passwordIsRight) {
            [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
        }
        else{
            NSString *password = [_PasswordField.text imc_md5String];
            NSDictionary *param = @{
                                    @"userName":_NameField.text,
                                    @"userAccount":_AccountField.text,
                                    @"password" : password
                                    };
            
            [[IMCNetAPIManager share]RequestChangePassWord:param andBlock:^(Response *response) {
                
            }];
        }
    }
    
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _NameField) {
        [_AccountField becomeFirstResponder];
    }else if (textField == _AccountField){
        [_PasswordField becomeFirstResponder];
    }else if (textField == _PasswordField){
        [_ConfirmField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];}
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _currentTextField = textField;
    
    CGRect rect = textField.frame;
    CGFloat offset = CGRectGetMaxY(rect) - (self.view.frame.size.height - _KeyBoardHeight);
    if (offset > 0) {
        [UIView animateWithDuration:0.15 animations:^{
            
            [self.view imc_setY:-offset-10];
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
            
            [self.view imc_setY:-offset-10];
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
@end
