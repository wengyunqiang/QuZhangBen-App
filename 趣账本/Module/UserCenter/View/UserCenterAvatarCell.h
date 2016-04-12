//
//  UserCenterAvatarCell.h
//  趣账本
//
//  Created by wengYQ on 15/12/26.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
@interface UserCenterAvatarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (nonatomic,strong) UserModel *rootUser;
@end
