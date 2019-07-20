//
//  CustomDatePickerDialog.m
//  zdbios
//
//  Created by skylink on 15/9/15.
//  Copyright (c) 2015年 skylink. All rights reserved.
//

#import "CustomDatePickerDialog.h"

@interface CustomDatePickerDialog ()

@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) DatePickerSelectedCallBack datePickerSelectedCallBack;

@end

@implementation CustomDatePickerDialog

#pragma mark - init method

- (instancetype)initWithDefaultDateString:(NSString *)dateString {

    self = [super init];
    if (self) {
        
        _dateString = dateString;
    }
    
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.sureButton addTarget:self
                        action:@selector(sureButtonAction:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.cancelButton addTarget:self
                          action:@selector(cancelButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat : @"yyyy-MM-dd HH:mm:ss" ];

    NSString *maxdateStr = @"2050-01-01 00:00:00";
//    NSDate *minDate = [dateFormatter dateFromString :mindateStr];
    NSDate *maxDate = [dateFormatter dateFromString :maxdateStr];
    
    //self.datePicker.minimumDate = [NSDate date];
    self.datePicker.maximumDate = maxDate;
    self.datePicker.backgroundColor = [UIColor  whiteColor];
    self.datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    if (_dateString.length) {
        
        NSString *defaultDateString = [NSString stringWithFormat:@"%@ 00:00:00", _dateString];
        NSDate *defaultDate= [dateFormatter dateFromString:defaultDateString];
        if (defaultDate) {
            [self.datePicker setDate:defaultDate animated:NO];
        }
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        _dateString = [dateFormatter stringFromDate:[NSDate date]];
    }
    
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self
                        action:@selector(dateChanged:)
              forControlEvents:UIControlEventValueChanged];
}


#pragma mark - event reponse

-(void)dateChanged:(id)sender{
    
    UIDatePicker *datePicker = (UIDatePicker*)sender;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _dateString = [dateFormatter stringFromDate:datePicker.date];
    
    /*添加你自己响应代码*/
}

- (void)sureButtonAction:(id)sender {
    
    if (_datePickerSelectedCallBack) {
        _datePickerSelectedCallBack(_dateString, NO);
    }
}

- (void)cancelButtonAction:(id)sender {
    
    if (_datePickerSelectedCallBack) {
        _datePickerSelectedCallBack(@"", YES);
    }
}

#pragma mark - public method

- (void)datePickerSelectedCompleteCallBack:(DatePickerSelectedCallBack)callBack {
    
    self.datePickerSelectedCallBack = callBack;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
