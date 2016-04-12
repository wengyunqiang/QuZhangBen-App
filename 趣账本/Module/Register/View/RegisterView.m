//
//  RegisterView.m
//  趣账本
//
//  Created by wengYQ on 15/12/14.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "RegisterView.h"
#import "AvatarCell.h"
#import "UserCell.h"
typedef NSData* (^ImageDataBlock)(void);
@interface RegisterView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *userTableView;
@property (nonatomic,copy) ImageDataBlock imageDataBlock;
@end
@implementation RegisterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        _userTableView = [[UITableView alloc] initWithFrame:self.bounds];
        [self addSubview:_userTableView];
        _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _userTableView.dataSource=self;
        _userTableView.delegate = self;
        [_userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AvatarCell class]) bundle:nil] forCellReuseIdentifier:@"AvatarCell"];
        [_userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserCell class]) bundle:nil] forCellReuseIdentifier:@"UserCell"];
        [self bk_whenTapped:^{
            [self endEditing:YES];
        }];
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *identifier = @"AvatarCell";
        AvatarCell *cell = [_userTableView dequeueReusableCellWithIdentifier:identifier];
        cell.tapBlock = ^{
            [self endEditing:YES];
        };
        self.imageDataBlock = cell.imageDataBlock;
        return cell;
    }else {
        static NSString *identifier = @"UserCell";
        UserCell *cell = [_userTableView dequeueReusableCellWithIdentifier:identifier];
        cell.imageDataBlock = self.imageDataBlock;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 73;
    }
    return 282;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 30;
}

@end
