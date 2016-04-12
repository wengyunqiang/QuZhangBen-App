//
//  IMCPickerView.h
//  iMacheng-iOS
//
//  Created by 欧杜书 on 15/10/30.
//  Copyright © 2015年 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, IMCPickerViewType) {
    IMCPickerViewTypeDatePicker,
    IMCPickerViewTypePickerView
};

typedef void (^PickerSelectedValueBlock)(NSString *selectedItem);

@interface IMCPickerView : UIView

// content的类型可以是数组或者字典, 如果选择日期则传入nil, 如果是字典目前最多只能两级, 即pickerView最多只能有两列
- (instancetype)initWithFrame:(CGRect)frame
                      content:(id)content
                         type:(IMCPickerViewType)type
                        title:(NSString *)title
                 selecedBlock:(PickerSelectedValueBlock)block;

- (void)showInNavigationController:(UINavigationController *)navigationController;
- (void)showInView:(UIView *)view;

@end
