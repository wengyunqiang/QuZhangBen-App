//
//  IMCPickerView.m
//  iMacheng-iOS
//
//  Created by 欧杜书 on 15/10/30.
//  Copyright © 2015年 MaCheng Technology Co.,Ltd. All rights reserved.
//

#import "IMCPickerView.h"
#import "UINavigationController+IMCCommon.h"

typedef NS_ENUM(NSUInteger, PickerContentDataType) {
    PickerContentDataTypeArray,
    PickerContentDataTypeDict,
};

@interface IMCPickerView() <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) UIPickerView *pickerView;
@property (nonatomic, weak) UIDatePicker *datePicker;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *confirmButton;
@property (nonatomic, weak) UIView *toolBar;
@property (nonatomic, weak) UIView *separatorView;
@property (nonatomic, strong) NSDictionary *contentDict;
@property (nonatomic, strong) NSArray *firstComponent;
@property (nonatomic, strong) NSArray *secondComponent;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSMutableString *seletedItem;
@property (nonatomic, copy) PickerSelectedValueBlock block;
@property (nonatomic, assign) PickerContentDataType contentDataType;
@property (nonatomic, assign) IMCPickerViewType pickerType;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation IMCPickerView

- (instancetype)initWithFrame:(CGRect)frame
                      content:(id)content
                         type:(IMCPickerViewType)type
                        title:(NSString *)title
                 selecedBlock:(PickerSelectedValueBlock)block {
    if (self = [super initWithFrame:frame]) {
        if (type == IMCPickerViewTypeDatePicker) {
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            [self addSubview:datePicker];
            NSString *dateStr = @"1900-01-01";
            datePicker.minimumDate = [self.dateFormatter dateFromString:dateStr];
            datePicker.maximumDate = [NSDate date];
            [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
            datePicker.datePickerMode = UIDatePickerModeDate;
            NSString *dateString = [self.dateFormatter stringFromDate:datePicker.maximumDate];
            self.seletedItem = [dateString copy];
            self.datePicker = datePicker;
        } else if (type == IMCPickerViewTypePickerView) {
            UIPickerView *pickerView = [[UIPickerView alloc] init];
            pickerView.dataSource = self;
            pickerView.delegate = self;
            [self addSubview:pickerView];
            self.pickerView = pickerView;
        }
        self.pickerType = type;
        
        if ([content isKindOfClass:[NSArray class]]) {
            self.contentDataType = PickerContentDataTypeArray;
            self.contentArray = content;
            [self.pickerView selectRow:(NSInteger)(self.contentArray.count / 2) inComponent:0 animated:NO];
            self.seletedItem = content[(NSInteger)(self.contentArray.count / 2)];
        } else {
            self.contentDataType = PickerContentDataTypeDict;
            self.contentDict = content;
            self.firstComponent = self.contentDict.allKeys;
            self.secondComponent = self.contentDict.allValues.firstObject;
        }
        
        UIView *toolBar = [[UIView alloc] init];
        [self addSubview:toolBar];
        self.toolBar = toolBar;
        
        UIView *separatorView = [[UIView alloc] init];
        [toolBar addSubview:separatorView];
        self.separatorView = separatorView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = title;
        [toolBar addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UIButton *confirmButton = [[UIButton alloc] init];
        [toolBar addSubview:confirmButton];
        self.confirmButton = confirmButton;
        
        self.backgroundColor = [UIColor imc_colorWithRGBHex:0xFAF9F7];
        self.block = block;
    }
    return self;
}

- (void)confirmButtonClick {
    [self.navigationController hidePopupContentView];
    [self.view hidePopupContentView];
    if (self.block && self.seletedItem.length > 0) {
        self.block(self.seletedItem);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.toolBar.backgroundColor = [UIColor imc_colorWithRGBHex:0xFAF9F7];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(@44);
    }];
    
    self.separatorView.backgroundColor = [UIColor imc_colorWithRGBHex:kColorDetailViewSubTitle];
    self.separatorView.alpha = 0.5f;
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.toolBar);
        make.height.mas_equalTo(@0.5);
    }];
    
    self.titleLabel.center = self.toolBar.center;
    self.titleLabel.textColor = [UIColor imc_colorWithRGBHex:kColorPrimary];
    self.titleLabel.font = [UIFont systemFontOfSize:18.0f weight:1.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.toolBar);
        make.height.equalTo(self.toolBar);
        make.width.mas_equalTo(@200);
    }];
    
    self.confirmButton.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, 80, 44);
    [self.confirmButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.confirmButton.contentMode = UIViewContentModeScaleAspectFit;
    [self.confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.toolBar.mas_right);
        make.height.equalTo(self.toolBar);
        make.width.mas_equalTo(60);
        make.centerY.equalTo(self.toolBar);
    }];
    
    if (self.pickerType == IMCPickerViewTypeDatePicker) {
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.toolBar.mas_bottom);
        }];
    } else if (self.pickerType == IMCPickerViewTypePickerView) {
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.toolBar.mas_bottom);
        }];
    }
}

#pragma mark - pickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.contentDataType == PickerContentDataTypeArray) {
        return 1;
    } else {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    if (self.contentDataType == PickerContentDataTypeArray) {
        return self.contentArray.count;
    } else {
        if (component == 0) {
            return self.firstComponent.count;
        } else {
           return self.secondComponent.count;
        }
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    if (self.contentDataType == PickerContentDataTypeArray) {
        return self.contentArray[row];
    } else {
        if (component == 0) {
            return self.firstComponent[row];
        } else {
            return self.secondComponent[row];
        }
    }
}

#pragma mark - pickerView Delegate
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    if (self.contentDataType == PickerContentDataTypeArray) {
        self.seletedItem = self.contentArray[row];
    } else {
        self.seletedItem = nil;
        if (component == 0) {
            self.secondComponent = self.contentDict[self.firstComponent[row]];
            [self.pickerView reloadComponent:1];
            NSInteger secondSelectedRow = [self.pickerView selectedRowInComponent:1];
            NSString *selectedString = [NSString stringWithFormat:@"%@ %@", self.firstComponent[row], self.secondComponent[secondSelectedRow]];
            self.seletedItem = [selectedString copy];
        } else {
            NSInteger firstSelectedRow = [self.pickerView selectedRowInComponent:0];
            NSString *selectedString = [NSString stringWithFormat:@"%@ %@", self.firstComponent[firstSelectedRow], self.secondComponent[row]];
            self.seletedItem = [selectedString copy];
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 38;
}


- (void)showInNavigationController:(UINavigationController *)navigationController {
    self.navigationController = navigationController;
    [navigationController showPopupContentView:self];
}

- (void)showInView:(UIView *)view {
    self.view = view;
    [view showPopupContentView:self];
}

#pragma mark - date picker events
- (void)datePickerChanged:(UIDatePicker *)datePicker {
    NSString *dateString = [self.dateFormatter stringFromDate:datePicker.date];
    self.seletedItem = [dateString copy];
}

#pragma mark - getters & setters
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _dateFormatter;
}

- (NSMutableString *)seletedItem {
    if (!_seletedItem) {
        _seletedItem = [NSMutableString string];
    }
    return _seletedItem;
}

@end
