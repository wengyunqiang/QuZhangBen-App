//
//  UserCenterViewController.m
//  趣账本
//
//  Created by wengYQ on 15/12/25.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserModel.h"
#import "userCenterCell.h"
#import "UserCenterAvatarCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IMCPickerView.h"
#import "ChangeNameController.h"
#import "IMCNetAPIManager.h"
#import "LoginOutButtonCell.h"
@interface UserCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UserModel *rootModel;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *keysArray;
@property (nonatomic,strong) NSMutableArray *valuesArray;
@property (nonatomic,strong) IMCPickerView *pickerDateView;
@property (nonatomic,strong) IMCPickerView *pickerGenderView;
@property (nonatomic,strong) ChangeNameController *ChangeNameVC;
@end

@implementation UserCenterViewController

- (instancetype)initWithRootUser:(UserModel *)rootUser{
    if (self == [super init]) {
        _rootModel = rootUser;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([userCenterCell class]) bundle:nil] forCellReuseIdentifier:@"userCenterCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserCenterAvatarCell class]) bundle:nil] forCellReuseIdentifier:@"UserCenterAvatarCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LoginOutButtonCell class]) bundle:nil] forCellReuseIdentifier:@"LoginOutButtonCell"];
    _keysArray = [[NSMutableArray alloc]initWithObjects:@"昵称",@"性别",@"生日",@"帐号",@"用户ID", nil];
    _valuesArray = [[NSMutableArray alloc]initWithObjects:_rootModel.userName,_rootModel.sex,_rootModel.birthday,_rootModel.userAccount,_rootModel.userID, nil];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *identifier = @"UserCenterAvatarCell";
        UserCenterAvatarCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
        
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_rootModel.avatarURL]];
        cell.rootUser = _rootModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if(indexPath.row > 0 && indexPath.row < 5){
        static NSString *identifier = @"userCenterCell";
        userCenterCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
        cell.KeyLb.text = _keysArray[indexPath.row - 1];
        cell.ValueLb.text = _valuesArray[indexPath.row - 1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
           cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
        }
        return cell;
    }else{
        static NSString *identifier = @"LoginOutButtonCell";
        LoginOutButtonCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }
    if (indexPath.row == 5) {
        return 63;
    }
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        userCenterCell *cell = (userCenterCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (_pickerGenderView == nil) {
            MCSelf(weakSelf);
            _pickerGenderView = [[IMCPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 240, self.view.frame.size.width, 240) content:@[@"男",@"女"] type:IMCPickerViewTypePickerView title:@"选择性别" selecedBlock:^(NSString *selectedItem) {
                NSDictionary *sexParam = @{@"propertyName" : @"sex",
                                           @"propertyValue": selectedItem,
                                           @"userID"       : weakSelf.rootModel.userID
                                           };
                [[IMCNetAPIManager share] RequestUserProperty:sexParam andBlock:^(Response *response) {
                    if (response.isSuccess) {
                        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                        [cell.ValueLb setText:selectedItem];
                    }else{
                         [SVProgressHUD showInfoWithStatus:@"网络有点不给力哦，请重新尝试修改"];
                    }
                }];
            }];
        }
        [_pickerGenderView showInNavigationController:self.navigationController];
    }
    
    if (indexPath.row == 3) {
        userCenterCell *cell = (userCenterCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (_pickerDateView == nil) {
                 MCSelf(weakSelf);
            _pickerDateView = [[IMCPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 240, self.view.frame.size.width, 240) content:nil type:IMCPickerViewTypeDatePicker title:@"选择生日" selecedBlock:^(NSString *selectedItem) {
                NSDictionary *birthdayParam = @{@"propertyName" : @"birthday",
                                           @"propertyValue": selectedItem,
                                           @"userID"       : weakSelf.rootModel.userID
                                           };
                [[IMCNetAPIManager share] RequestUserProperty:birthdayParam andBlock:^(Response *response) {
                    if (response.isSuccess) {
                        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                        [cell.ValueLb setText:selectedItem];
                    }else{
                        [SVProgressHUD showInfoWithStatus:@"网络有点不给力哦，请重新尝试修改"];
                    }
                }];

            }];
        }
        [_pickerDateView showInNavigationController:self.navigationController];
    }
    if (indexPath.row == 1) {
         userCenterCell *cell = (userCenterCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (_ChangeNameVC == nil) {
            MCSelf(weakSelf);
            _ChangeNameVC = [[ChangeNameController alloc]init];
            _ChangeNameVC.RootUser = _rootModel;
            _ChangeNameVC.saveBlock = ^{
                weakSelf.userName = weakSelf.ChangeNameVC.name;
                cell.ValueLb.text = weakSelf.ChangeNameVC.name;
                weakSelf.changeUserNameBlock();
            };
        }
        [self.navigationController pushViewController:_ChangeNameVC animated:YES];
    }
}
@end
