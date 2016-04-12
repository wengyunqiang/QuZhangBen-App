//
//  UserCell.m
//  趣账本
//
//  Created by wengYQ on 15/12/14.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "UserCell.h"
#import "IMCNetAPIManager.h"
@interface UserCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *RegisterBtn;
@property (weak, nonatomic) IBOutlet UITextField *UserNameField;

@property (weak, nonatomic) IBOutlet UITextField *UserAccountField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordField;

@property (weak, nonatomic) IBOutlet UITextField *ConfirmField;
@property (nonatomic,strong) UITextField *currentTextField;
@property (nonatomic,assign) CGFloat KeyBoardHeight;

- (IBAction)ClickRegisterBtn:(id)sender;

@end
@implementation UserCell

- (void)awakeFromNib {
    // Initialization code
    UIImage *image = [UIImage imageNamed:@"LoginBackGround.jpg"];
    [_RegisterBtn setBackgroundImage:image forState:UIControlStateNormal];
    [_RegisterBtn.layer setCornerRadius:5];
    _RegisterBtn.clipsToBounds = YES;
    
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
    _UserAccountField.delegate = self;
    _UserNameField.delegate = self;
    _ConfirmField.delegate = self;
    _PasswordField.delegate = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)ClickRegisterBtn:(id)sender {
    [self.contentView endEditing:YES];
   
    BOOL isCorrect =  [_UserNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0 && [_PasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 5 &&[_ConfirmField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length >5 && [_UserAccountField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length >5 ;
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    if (!isCorrect) {
        [SVProgressHUD showErrorWithStatus:@"请检查输入的文本长度是否达标"];
    }else{
         BOOL passwordIsRight = [_PasswordField.text isEqualToString:_ConfirmField.text];
        if (!passwordIsRight) {
            [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致"];
        }
        else{
            if (self.imageDataBlock) {
                 //信息完整符合要求，执行注册操作
                NSData *avatarData     = self.imageDataBlock();
                NSString *userName     = _UserNameField.text;
                NSString *userAccount  = _UserAccountField.text;
                NSString *userPassword = _PasswordField.text;
                userPassword           = [userPassword imc_md5String];
                
                NSDictionary *userParams = @{
                                              @"userName"  :  userName,
                                              @"userAccount" :  userAccount,
                                              @"userPassword" : userPassword,
                                              };
                NSDictionary *ImageParams = @{
                                              @"userAccount" : userAccount,
                                              @"image"       : avatarData
                                              };
            
                MCSelf(weakSelf);
               [[IMCNetAPIManager share]RequestRegisterUser:userParams pathParams:nil andBlock:^(Response *response) {
                   if (response.isSuccess) {
                       //用户帐号校验成功，执行头像上传
                       [[IMCNetAPIManager share] RequestUpLoadAvatar:ImageParams andBlock:^(Response *response) {
                       }];
                       [SVProgressHUD showSuccessWithStatus:@"注册成功!"];
                       [[weakSelf imc_navigationController] popViewControllerAnimated:YES];
                       
                   }else{
                       [SVProgressHUD showErrorWithStatus:@"该帐号已经存在" maskType:SVProgressHUDMaskTypeBlack];
                   }
               }];
            }
            
        }
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _UserNameField) {
        [_UserAccountField becomeFirstResponder];
    }else if (textField == _UserAccountField){
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
    UIViewController *rootVC = [self imc_viewController];
    CGRect rect01 = [textField.superview convertRect:rect toView:rootVC.view];
    CGFloat offset = CGRectGetMaxY(rect01) - (rootVC.view.frame.size.height - _KeyBoardHeight);
    if (offset > 0) {
        [UIView animateWithDuration:0.15 animations:^{
            
            [rootVC.view imc_setY:-offset-10];
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
    UIViewController *rootVC = [self imc_viewController];
    CGRect rect01 = [_currentTextField.superview convertRect:rect toView:rootVC.view];
    CGFloat offset = CGRectGetMaxY(rect01) - (rootVC.view.frame.size.height - _KeyBoardHeight);
    
    if (offset > 0) {
        [UIView animateWithDuration:0.15 animations:^{
            
            [rootVC.view imc_setY:-offset-10];
        }];
    }
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
     UIViewController *rootVC = [self imc_viewController];
    [rootVC.view imc_setY:64];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
