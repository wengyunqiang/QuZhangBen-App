//
//  EssayDetailController.m
//  趣账本
//
//  Created by wengYQ on 15/12/24.
//  Copyright © 2015年 cn.wengyq. All rights reserved.
//

#import "EssayDetailController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface EssayDetailController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UIImageView *pictureView;
@property (nonatomic,strong) UILabel *textView;
@property (nonatomic,strong)  UILabel *dateLb;
@end

@implementation EssayDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"文章详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _scrollView.contentInset = MCUIScrollViewContentEdgeInsets;
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * 3);
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _titleLb = [[UILabel alloc]init];
    _titleLb.textAlignment = NSTextAlignmentCenter;
    _titleLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];

    [_scrollView addSubview:_titleLb];
    MCSelf(weakSelf);
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.scrollView).offset(20);
        make.width.equalTo(weakSelf.scrollView);
        make.height.mas_equalTo(21);
        make.centerX.equalTo(weakSelf.scrollView);
    }];
    
    _dateLb = [[UILabel alloc]init];
    _dateLb.text = _essayModel.createTime;
    _dateLb.font = [UIFont systemFontOfSize:12];
    //_dateLb.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_dateLb];
    [_dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.scrollView).offset(15);
        make.top.equalTo(weakSelf.titleLb.mas_bottom).offset(20);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(21);
        
    }];
    
    _pictureView = [[UIImageView alloc]init];
    [self.scrollView addSubview:_pictureView];
    [_pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.scrollView).offset(15);
        make.right.equalTo(weakSelf.titleLb).offset(-15);
        make.height.mas_equalTo(200);
        make.top.mas_equalTo(weakSelf.dateLb.mas_bottom).offset(10);
    }];
    _pictureView.layer.cornerRadius = 8;
    _pictureView.layer.borderColor = [UIColor colorWithWhite:0.823 alpha:1.000].CGColor;
    _pictureView.layer.borderWidth = 1;
    _pictureView.clipsToBounds = YES;
    
    
    _textView = [[UILabel alloc]init];
    
    [_scrollView addSubview:_textView];
   
    CGFloat height =  [self heightForString:_essayModel.essay fontSize:17 andWidth:self.view.bounds.size.width - 30];
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, height+512);
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.scrollView).offset(15);
        make.right.equalTo(weakSelf.titleLb).offset(-15);
        make.top.equalTo(weakSelf.pictureView.mas_bottom).offset(10);
        make.height.mas_equalTo(height+120);
    }];
//    _textView.editable = NO;
    //_textView.enabled = NO;
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.text = _essayModel.essay;
    _titleLb.text = _essayModel.title;
    _textView.textColor = [UIColor blackColor];
//设置TextView垂直对齐
    _textView.lineBreakMode = UILineBreakModeWordWrap;
    _textView.numberOfLines = 0;
    _textView.textAlignment = NSTextAlignmentLeft;
//    _textView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    _textView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_pictureView sd_setImageWithURL:[NSURL URLWithString:_essayModel.imagePath]];
    self.scroll2TopBlock = ^{
        [weakSelf scrollToTop:NO];
    };
}

-(void)setEssayModel:(EssayModel *)essayModel{
    if (_essayModel != essayModel) {
        _essayModel = essayModel;
    }
    _dateLb.text = _essayModel.createTime;
    _titleLb.text = _essayModel.title;
    [_pictureView sd_setImageWithURL:[NSURL URLWithString:_essayModel.imagePath]];
    _textView.text = _essayModel.essay;
    CGFloat height = [self heightForString:_essayModel.essay fontSize:17 andWidth:self.view.bounds.size.width - 30];
    
    DLog(@"-------- height --------\n %f",height);
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat height = [self heightForString:_essayModel.essay fontSize:17 andWidth:self.view.bounds.size.width - 30];
if (!(_scrollView.contentSize.height == height + 512)) {
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, height+512);
    [_textView setFrame:CGRectMake(15, 262, (self.view.bounds.size.width - 30), height )];
    }
}


- (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width//根据字符串的的长度来计算UITextView的高度
{
    float height = [[NSString stringWithFormat:@"%@\n ",value] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil] context:nil].size.height;
    
    return height;
}

//滚动到顶部
- (void)scrollToTop:(BOOL)animated {
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:animated];
}


@end
