//
//  RootViewController.m
//  TimeToGo
//
//  Created by Jakub Fietkiewicz on 2/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController
@synthesize pickerView, doneButton, dataArray, dateFormatter;


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/
- (void)viewDidLoad {
	self.dataArray = [NSArray arrayWithObjects:@"Start Date", @"End Date", nil];
	
	NSLog(@"DataArray:%@", dataArray);
	
	self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	
	NSLog(@"Date Formatter: %@", self.dateFormatter);
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];//return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"postCellBackground.png"]];
	cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"postCellBackgroundSelected.png"]];

    
	// Configure the cell.
	cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
	//cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];

	

    return cell;
}

-(IBAction)doneAction:(id)sender
{
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect endFrame = self.pickerView.frame;
	endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
	
	// start the slide down after done
	[UIView beginAnimations:nil context:NULL];
	
	[UIView setAnimationDuration:0.3];
	
	// perform post operations after animation complete
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
	
	self.pickerView.frame = endFrame;
	[UIView commitAnimations];
	
	//grow the table back again in vertical to make room for date picker
	CGRect newFrame = self.tableView.frame;
	newFrame.size.height += self.pickerView.frame.size.height;
	self.tableView.frame = newFrame;
	
	// remove the done button in the nav bar
	self.navigationItem.rightBarButtonItem = nil;
	
	// deselect the current table row
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

// upon the selection of a row in the table view slide in the date picker
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
	
	NSLog(@"targetCell detailTextLabel text: %@",targetCell.detailTextLabel.text);
	
	
	
	if(targetCell.detailTextLabel.text==nil)
	{
		NSLog(@"self.pickerView.date: %@",self.pickerView.date);
		self.pickerView.date = [NSDate date];
	}
	else {
		NSLog(@"self.pickerView.date: %@",self.pickerView.date);
		self.pickerView.date = [self.dateFormatter dateFromString:targetCell.detailTextLabel.text];
	}
	
	

	
	
	NSLog(@"self pickerView date: %@", self.pickerView.date);
	
	//check if datepicker is already on the screen
	if(self.pickerView.superview==nil)
	{
		[self.view.window addSubview: self.pickerView];
		
		// size up the picker view to the screen and compute start/end frame origin for the animation
		//
		
		// compute the start frame
		CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
		CGSize pickerSize = [self.pickerView sizeThatFits:CGSizeZero];
		CGRect startRect = CGRectMake(
									  0.0, 
									  screenRect.origin.y + screenRect.size.height, 
									  pickerSize.width, 
									  pickerSize.height);
		self.pickerView.frame = startRect;
		
		// compute the end frame
		CGRect pickerRect = CGRectMake(
									   0.0, 
									   screenRect.origin.y + screenRect.size.height - pickerSize.height, 
									   pickerSize.width, 
									   pickerSize.height);
		
		// start the slide up animation
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		
		// perform post operations after the animation is complete
		[UIView setAnimationDelegate:self];
		
		self.pickerView.frame = pickerRect;
		
		// shrink the table vertical size to make room for the date picker
		CGRect newFrame = self.tableView.frame;
		newFrame.size.height -= self.pickerView.frame.size.height;
		self.tableView.frame = newFrame;
		[UIView commitAnimations];
		
		// add the done button to the nav bar
		self.navigationItem.rightBarButtonItem = self.doneButton;
	}
	
}

// remove date picker after it finisehd sliding
-(void)slideDownDidStop
{
	[self.pickerView removeFromSuperview];
}

// action for outlet to update the cell from a changed
- (IBAction)dateAction:(id)sender
{
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.pickerView.date];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.dataArray = nil;
	self.dateFormatter = nil;
}


- (void)dealloc {
	
	[doneButton release];
	[dataArray release];
	[pickerView release];
	[dateFormatter release];
	
    [super dealloc];
}


@end

