//
//  TDDatePickerController_IPhone5.h
//  Medicita
//
//  Created by App Developer on 11/12/12.
//  Copyright (c) 2012 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"TDSemiModal.h"

@interface TDDatePickerController_IPhone5 : TDSemiModalViewController<UIPickerViewDelegate,UIPickerViewDataSource> {
	id delegate;
    
    IBOutlet UIButton *CancelBtn,*SaveBtn;
    IBOutlet UIToolbar *toolbar;
}

@property (nonatomic, retain) IBOutlet id delegate;
@property (nonatomic, retain) IBOutlet UIPickerView* picker;
@property (nonatomic, retain) NSMutableArray *pickerData;
@property (nonatomic, retain) NSString *pickedStr;

-(IBAction)saveDateEdit:(id)sender;
-(IBAction)clearDateEdit:(id)sender;
-(IBAction)cancelDateEdit:(id)sender;

@end

@interface NSObject (TDDatePickerController_IPhone5Delegate)
-(void)datePickerSetDate:(TDDatePickerController_IPhone5*)viewController;
-(void)datePickerClearDate:(TDDatePickerController_IPhone5*)viewController;
-(void)datePickerCancel:(TDDatePickerController_IPhone5*)viewController;

@end
