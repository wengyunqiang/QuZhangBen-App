//
//  EssaysCell.m
//  趣账本
//
//  Created by wengYQ on 15/12/24.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "EssaysCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface EssaysCell()
@property (weak, nonatomic) IBOutlet UILabel *TimeLb;
@property (weak, nonatomic) IBOutlet UIView *ContentView0;
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *essayLb;
@property (weak, nonatomic) IBOutlet UILabel *TitleLb;


@end

@implementation EssaysCell

- (void)awakeFromNib {
    _ContentView0.layer.borderWidth = 1;
    _ContentView0.layer.borderColor = [UIColor colorWithWhite:0.903 alpha:1.000].CGColor;
    _ContentView0.layer.cornerRadius = 5;
    _ContentView0.clipsToBounds = YES;
    
    _TimeLb.layer.cornerRadius = 5;
    _TimeLb.clipsToBounds = YES;
    
    MCSelf(weakSelf);
    [_ContentView0 bk_whenTapped:^{
        if (weakSelf.clickBlock) {
            weakSelf.clickBlock();
        }
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setEssayModel:(EssayModel *)essayModel{
    if (_essayModel != essayModel) {
        _essayModel = essayModel;
    }
    _TimeLb.text = _essayModel.createTime;
    _TitleLb.text = _essayModel.title;
    _essayLb.text = _essayModel.essay;
    [_pictureView sd_setImageWithURL:[NSURL URLWithString:_essayModel.imagePath]];
}

@end
