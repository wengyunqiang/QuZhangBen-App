//
//  LoginOutButtonCell.m
//  趣账本
//
//  Created by wengYQ on 16/1/4.
//  Copyright © 2016年 cn.wengyq. All rights reserved.
//

#import "LoginOutButtonCell.h"
#import "LoginViewController.h"
#import <FMDB.h>
@interface LoginOutButtonCell()
@property (nonatomic,strong) LoginViewController *LoginVC;
@end
@implementation LoginOutButtonCell

- (void)awakeFromNib {
    self.LoginOutBtn.layer.cornerRadius = 5;
    self.LoginOutBtn.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)ClickOutBtn:(id)sender {
    
    [self clearDB];
    
    UINavigationController *rootNav = [self imc_navigationController];
    if (_LoginVC == nil) {
        _LoginVC = MCInitViewControllerFromStoryboard(@"Main",@"LoginViewController");
        _LoginVC.navigationItem.hidesBackButton = YES;
    }
    [rootNav pushViewController:_LoginVC animated:YES];
    
}

-(void)clearDB{
    NSString *DocPath = PATH_OF_DOCUMENT;
    NSString * path = [DocPath stringByAppendingPathComponent:@"user.sqlite"];
    FMDatabase * db = [FMDatabase databaseWithPath:path];
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
@end
