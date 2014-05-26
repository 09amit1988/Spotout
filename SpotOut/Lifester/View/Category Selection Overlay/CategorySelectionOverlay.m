//
//  CategorySelectionOverlay.m
//  Lifester
//


#import <QuartzCore/QuartzCore.h>
#import "CategorySelectionOverlay.h"
#import "JSON.h"
#import "ASIFormDataRequest.h"
#import "Reachability.h"
#import "ViewController_IPhone5.h"

@implementation CategorySelectionOverlay

@synthesize arrCategory,btnDone,tblCategory,categoryOverlay;
@synthesize viewDoneCategory;

+ (void)showAlert:(NSString*)strHeader delegate:(id)sender withTag:(NSInteger)iTag
{
    UIViewController *controller = [[UIViewController alloc] initWithNibName:@"CategorySelectionOverlay" bundle:[NSBundle mainBundle]];
    CategorySelectionOverlay *alert = (CategorySelectionOverlay *)controller.view;
    
    alert.arrCategory = [[NSMutableArray alloc] init];    
    
    if (IS_IPHONE_5) {
        alert.viewDoneCategory.frame = CGRectMake(alert.viewDoneCategory.frame.origin.x, 504, alert.viewDoneCategory.frame.size.width, alert.viewDoneCategory.frame.size.height);
        
    } else {
        alert.viewDoneCategory.frame = CGRectMake(alert.viewDoneCategory.frame.origin.x, 456, alert.viewDoneCategory.frame.size.width, alert.viewDoneCategory.frame.size.height);
        alert.categoryOverlay.frame = CGRectMake(alert.categoryOverlay.frame.origin.x, 118, alert.categoryOverlay.frame.size.width, alert.categoryOverlay.frame.size.height);
    }
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:appname message:@"No Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertview show];
        [alertview release];
    } else {
        [alert WebServiceCall];
    }

    
    alert.delegate = sender;
	[alert show];
    
    [[alert.viewDoneCategory layer] setCornerRadius:2.5];
    [[alert.categoryOverlay layer] setCornerRadius:2.5];
	[controller release];
}


#pragma mark - Tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.arrCategory count]%3 == 0) {
        return ceil([self.arrCategory count]/3);
    }
    return (int)([self.arrCategory count]/3) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simple=@"Simple";
    PlaceCategoryCell *cell = (PlaceCategoryCell *)[tableView dequeueReusableCellWithIdentifier:simple];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"PlaceCategoryCell" owner:nil options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [[cell.btnCategory1 layer] setCornerRadius:2.5];
    [[cell.btnOverlay1 layer] setCornerRadius:2.5];
    [[cell.btnCategory2 layer] setCornerRadius:2.5];
    [[cell.btnOverlay2 layer] setCornerRadius:2.5];
    [[cell.btnCategory2 layer] setCornerRadius:2.5];
    [[cell.btnOverlay3 layer] setCornerRadius:2.5];
    
    NSMutableDictionary *dictData1 = [NSMutableDictionary dictionaryWithDictionary:[self.arrCategory objectAtIndex:(indexPath.row*3)]];
    cell.lblCategory1.text = [dictData1 objectForKey:@"category_name"];
    cell.btnCategory1.tag = indexPath.row*3;
    [cell.btnCategory1 addTarget:self action:@selector(btnCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnOverlay1.tag = indexPath.row*3;
    [cell.btnOverlay1 addTarget:self action:@selector(btnCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([[dictData1 objectForKey:@"IsSelected"] boolValue]) {
        cell.btnCategory1.selected = YES;
        cell.btnOverlay1.selected = YES;
        [cell.btnOverlay1 setHidden:NO];
    } else {
        cell.btnCategory1.selected = NO;
        cell.btnOverlay1.selected = NO;
        [cell.btnOverlay1 setHidden:YES];
    }
    
    [cell.lblCategory2 setHidden:YES];
    [cell.btnCategory2 setHidden:YES];
    [cell.lblCategory3 setHidden:YES];
    [cell.btnCategory3 setHidden:YES];
    
    if((indexPath.row * 3) + 1 < [self.arrCategory count]) {
        NSMutableDictionary *dictData2 = [NSMutableDictionary dictionaryWithDictionary:[self.arrCategory objectAtIndex:(indexPath.row*3)+1]];
        cell.lblCategory2.text = [dictData2 objectForKey:@"category_name"];
        cell.btnCategory2.tag = (indexPath.row*3)+1;
        [cell.btnCategory2 addTarget:self action:@selector(btnCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnOverlay2.tag = (indexPath.row*3)+1;
        [cell.btnOverlay2 addTarget:self action:@selector(btnCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([[dictData2 objectForKey:@"IsSelected"] boolValue]) {
            cell.btnCategory2.selected = YES;
            cell.btnOverlay2.selected = YES;
            [cell.btnOverlay2 setHidden:NO];
        } else {
            cell.btnCategory2.selected = NO;
            cell.btnOverlay2.selected = NO;
            [cell.btnOverlay2 setHidden:YES];
        }
        
        [cell.lblCategory2 setHidden:NO];
        [cell.btnCategory2 setHidden:NO];
    }
    
    if((indexPath.row * 3) + 2 < [self.arrCategory count]) {
        NSMutableDictionary *dictData3 = [NSMutableDictionary dictionaryWithDictionary:[self.arrCategory objectAtIndex:(indexPath.row*3)+2]];
        cell.lblCategory3.text = [dictData3 objectForKey:@"category_name"];
        cell.btnCategory3.tag = (indexPath.row*3)+2;
        [cell.btnCategory3 addTarget:self action:@selector(btnCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnOverlay3.tag = (indexPath.row*3)+2;
        [cell.btnOverlay3 addTarget:self action:@selector(btnCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([[dictData3 objectForKey:@"IsSelected"] boolValue]) {
            cell.btnCategory3.selected = YES;
            cell.btnOverlay3.selected = YES;
            [cell.btnOverlay3 setHidden:NO];
        } else {
            cell.btnCategory3.selected = NO;
            cell.btnOverlay3.selected = NO;
            [cell.btnOverlay3 setHidden:YES];
        }
        
        [cell.lblCategory3 setHidden:NO];
        [cell.btnCategory3 setHidden:NO];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87.0;
}


#pragma mark - tableview delegate

- (void)btnCategoryAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    NSMutableDictionary *dictData = [NSMutableDictionary dictionaryWithDictionary:[self.arrCategory objectAtIndex:button.tag]];
    if (button.isSelected) {
        [dictData setObject:[NSNumber numberWithBool:NO] forKey:@"IsSelected"];
    } else {
        [dictData setObject:[NSNumber numberWithBool:YES] forKey:@"IsSelected"];
    }
    
    [self.arrCategory replaceObjectAtIndex:button.tag withObject:dictData];
    
    [tblCategory reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Action Method

- (IBAction)btnDoneCategoryAction:(id)sender
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"IsSelected == 1"];
    NSArray *arrFiltered = [self.arrCategory filteredArrayUsingPredicate:predicate];
    if ([arrFiltered count] >= 1 && [arrFiltered count] < 3) {
        [self dismissWithSuccess:YES animated:YES childView:self];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:appname
                                                        message:@"Please select atmost 2 category."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void)dismissOverlayAction
{
    [self dismissWithSuccess:YES animated:YES childView:self];
}

#pragma mark - Baseclass methods

- (void)dialogWillAppear {
	[super dialogWillAppear];
}

- (void)dialogWillDisappear {
	[super dialogWillDisappear];
}

-(void)WebServiceCall
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    int number = (arc4random()%99999999)+1;
    NSString *string = [NSString stringWithFormat:@"%i", number];
    [appDelegate showActivity:self showOrHide:YES];
    
    NSString *strURL = [NSString stringWithFormat:@"%@raws/ws_users.php?rnd=%@",SERVER_URL,string];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strURL]];
    
    [request setPostValue:@"1.0.0" forKey:@"api_version"];
    [request setPostValue:@"get_choice_category_list" forKey:@"todoaction"];
    [request setPostValue:@"json" forKey:@"format"];
    [request setPostValue:appDelegate.userID forKey:@"user_id"];
    [request setPostValue:appDelegate.PassKey forKey:@"pass_key"];
    
    [request setDelegate:self];
    
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString *receivedString = [request responseString];
    
    NSDictionary *responseObject = [receivedString JSONValue];
    NSArray *items = [responseObject objectForKey:@"raws"];
    
    if (appDelegate.LoginFlag==FALSE) {
        [appDelegate showActivity:self showOrHide:NO];
        if (![[[items valueForKey:@"status"] valueForKey:@"fetch_status"] isEqualToString:@"true"]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:appname message:@"No Data Found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        else {
            self.arrCategory = [[NSMutableArray alloc] init];
            
            
            if ([ [items valueForKey:@"dataset"] isKindOfClass:[NSMutableArray class] ]) {
                [self.arrCategory addObjectsFromArray:[items valueForKey:@"dataset"]];
            }
            
            if ([ [items valueForKey:@"dataset"] isKindOfClass:[NSMutableDictionary class]]) {
                [self.arrCategory addObject:[items valueForKey:@"dataset"]];
            }
            NSLog(@"1 === %@", [self.arrCategory objectAtIndex:0]);
            
            [tblCategory reloadData];
        }
    }
    else {
        if (![[[items valueForKey:@"status"] valueForKey:@"login_status"] isEqualToString:@"true"]) {
            
        }
        else {
            if (![[[items valueForKey:@"status"] valueForKey:@"fetch_status"] isEqualToString:@"true"]) {
                
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:appname message:@"No Data Found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
            else {
                self.arrCategory = [[NSMutableArray alloc] init];
                
                
                if ([ [items valueForKey:@"dataset"] isKindOfClass:[NSMutableArray class] ]) {
                    [self.arrCategory addObjectsFromArray:[items valueForKey:@"dataset"]];
                }
                if ([ [items valueForKey:@"dataset"] isKindOfClass:[NSMutableDictionary class]]) {
                    [self.arrCategory addObject:[items valueForKey:@"dataset"]];
                    
                    for (int i = 0; i > [self.arrCategory count]; i++) {
                        NSMutableDictionary *dict = [self.arrCategory objectAtIndex:i];
                        NSString *image = [NSString stringWithFormat:@"%d_small.png", (i+1)];
                        [dict setObject:image forKey:@"CategoryImage"];
                        
                        [self.arrCategory replaceObjectAtIndex:i withObject:dict];
                    }
                }
                //NSLog(@"array === %@", self.arrCategory);
                
                [tblCategory reloadData];
            }
        }
    }
    
    [appDelegate showActivity:self showOrHide:NO];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showActivity:self showOrHide:NO];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Sorry, There is No Network Connection. Please Check The Network Connectivity" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}


- (void)dealloc {
	self.arrCategory = nil;
    [super dealloc];
}


@end
