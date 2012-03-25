//
//  RootViewController.h
//  TimeToGo
//
//  Created by Jakub Fietkiewicz on 2/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
@private
	UIDatePicker *pickerView;
	UIBarButtonItem *doneButton;	// this button appears only when the date picker is open
	
	NSArray *dataArray;
	
	NSDateFormatter *dateFormatter;
	
}

@property (nonatomic, retain) IBOutlet UIDatePicker *pickerView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;

- (IBAction)doneAction:(id)sender; // when user is done with button
- (IBAction)dateAction:(id)sender; // when user changes date value

@end
