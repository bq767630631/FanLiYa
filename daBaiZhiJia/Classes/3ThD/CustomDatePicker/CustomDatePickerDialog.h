//
//  CustomDatePickerDialog.h
//  zdbios
//
//  Created by skylink on 15/9/15.
//  Copyright (c) 2015年 skylink. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DatePickerSelectedCallBack) (NSString *dateString, BOOL cancel);

@interface CustomDatePickerDialog : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

- (instancetype)initWithDefaultDateString:(NSString *)dateString;

- (void)datePickerSelectedCompleteCallBack:(DatePickerSelectedCallBack)callBack;

@end

