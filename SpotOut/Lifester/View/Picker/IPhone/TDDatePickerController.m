//
//  TDDatePickerController.m
//
//  Created by Nathan  Reed on 30/09/10.
//  Copyright 2010 Nathan Reed. All rights reserved.
//

#import "TDDatePickerController.h"


@implementation TDDatePickerController
@synthesize picker, delegate,pickerData,pickedStr;

-(void)viewDidLoad {
    [super viewDidLoad];
    
    pickedStr=[pickerData objectAtIndex:0];
    picker.backgroundColor = [UIColor whiteColor];
    
	for (UIView* subview in picker.subviews) {
		subview.frame = picker.bounds;
	}
    
    [CancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [CancelBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-regular" size:14.0]];
    [SaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SaveBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-regular" size:14.0]];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Actions

-(IBAction)saveDateEdit:(id)sender {
	if([self.delegate respondsToSelector:@selector(datePickerSetDate:)]) {
		[self.delegate datePickerSetDate:self];
	}
}

-(IBAction)clearDateEdit:(id)sender {
	if([self.delegate respondsToSelector:@selector(datePickerClearDate:)]) {
		[self.delegate datePickerClearDate:self];
	}
}

-(IBAction)cancelDateEdit:(id)sender {
	if([self.delegate respondsToSelector:@selector(datePickerCancel:)]) {
		[self.delegate datePickerCancel:self];
	} else {
		// just dismiss the view automatically?
	}
}

#pragma mark -
#pragma mark Memory Management


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];

	self.picker = nil;
	self.delegate = nil;
}

- (void)dealloc {
	self.picker = nil;
	self.delegate = nil;

    [super dealloc];
}

#pragma Mark UIPickerViewDelegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerData count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [pickerData objectAtIndex:row];
}

#pragma Mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    pickedStr=[pickerData objectAtIndex:row];
}

@end


