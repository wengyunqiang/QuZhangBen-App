//
//  EssayViewController.m
//  趣账本
//
//  Created by wengYQ on 15/12/23.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "EssayViewController.h"
#import "EssaysView.h"
@interface EssayViewController ()
@property (nonatomic,strong) EssaysView *essaysView;
@end

@implementation EssayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"省钱攻略";
    self.view.backgroundColor = [UIColor whiteColor];
    _essaysView = [[EssaysView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_essaysView];
}

@end
