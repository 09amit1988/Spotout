//
//  TDDatePickerController.h
//
//  Created by Nathan  Reed on 30/09/10.
//  Copyright 2010 Nathan Reed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"TDSemiModal.h"

@interface TDDatePickerController : TDSemiModalViewController<UIPickerViewDelegate,UIPickerViewDataSource> {
	id delegate;
    
    IBOutlet UIButton *CancelBtn,*SaveBtn;
}

@property (nonatomic, retain) IBOutlet id delegate;
@property (nonatomic, retain) IBOutlet UIPickerView* picker;
@property (nonatomic, retain) NSMutableArray *pickerData;
@property (nonatomic, retain) NSString *pickedStr;

-(IBAction)saveDateEdit:(id)sender;
-(IBAction)clearDateEdit:(id)sender;
-(IBAction)cancelDateEdit:(id)sender;

@end

@interface NSObject (TDDatePickerControllerDelegate)
-(void)datePickerSetDate:(TDDatePickerController*)viewController;
-(void)datePickerClearDate:(TDDatePickerController*)viewController;
-(void)datePickerCancel:(TDDatePickerController*)viewController;
@end

