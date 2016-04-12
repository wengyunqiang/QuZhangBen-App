//
//  RegisterViewController.m
//  趣账本
//
//  Created by wengYQ on 15/12/14.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"
@interface RegisterViewController ()
@property (nonatomic,strong) RegisterView *registerView;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDefaultNavigationBar];
    [self.navigationItem setTitle:@"注册"];
    _registerView = [[RegisterView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_registerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
