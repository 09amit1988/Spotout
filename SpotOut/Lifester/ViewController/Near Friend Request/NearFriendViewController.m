//
//  NearFriendViewController.m
//  Lifester
//
//  Created by Nikunj on 12/30/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import "NearFriendViewController.h"
#import "NewProfileMainCell.h"
#import "Settings.h"
#import "Settings_IPhone5.h"


#define degreesToRadians(x)(M_PI*x/180.0)

@interface NearFriendViewController ()

@end

@implementation NearFriendViewController


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
//    self.mapView.delegate = nil;
//	self.mapView = nil;
}


- (void)dealloc
{
    [super dealloc];
//    mapView.delegate = nil;
//	[mapView release];
}

#pragma mark - View Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [AppDelegate titleLabelWithTitle:@"Nearby"];
    
    DYRateView *rateview = [[DYRateView alloc] initWithFrame:CGRectMake(93, 70, 150, 25) fullStar:[UIImage imageNamed:@"StarFull-25.png"] emptyStar:[UIImage imageNamed:@"StarEmpty-25.png"]];
    rateview.editable = NO;
    rateview.rate = 3;
    [annotationDetailView addSubview:rateview];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    [self.tabBarController.navigationController setNavigationBarHidden:YES animated:NO];
    
    //    imvActivityImage.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"ImgUrl"]];
    imvActivityImage.contentMode = UIViewContentModeScaleAspectFill;
    [imvActivityImage setClipsToBounds: YES];
    [[imvActivityImage layer] setMasksToBounds:YES];
    [[imvActivityImage layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[imvActivityImage layer] setBorderWidth:0.0];
    [[imvActivityImage layer] setCornerRadius:imvActivityImage.frame.size.width/2.0];
}

#pragma mark - UIButton Methods


- (IBAction)btnSideBarMenuAction:(id)sender
{
    [self.menuContainerViewController toggleRightSideMenuCompletion:^{
    }];
}

- (IBAction)btnSettingAction:(id)sender
{
    //[self.menuContainerViewController toggleRightSideMenuCompletion:^{
        if (IS_IPHONE_5) {
            Settings_IPhone5 *viewController = [[Settings_IPhone5 alloc] initWithNibName:@"Settings_IPhone5" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            Settings *viewController = [[Settings alloc] initWithNibName:@"Settings" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
    //}];
}

#pragma mark - Custom Metohds




@end
