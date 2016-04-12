//
//  EssaysCell.h
//  趣账本
//
//  Created by wengYQ on 15/12/24.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EssayModel.h"
typedef void (^selectContentView)(void);
@interface EssaysCell : UITableViewCell
@property (nonatomic,strong) EssayModel *essayModel;
@property (nonatomic,copy) selectContentView clickBlock;
@end
