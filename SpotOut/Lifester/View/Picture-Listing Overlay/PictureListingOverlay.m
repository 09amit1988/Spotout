//
//  PictureListingOverlay.m
//  Lifester
//


#import <QuartzCore/QuartzCore.h>
#import "PictureListingOverlay.h"
#import "AsyncImageView.h"
#import "IconDownloader.h"

@implementation PictureListingOverlay

@synthesize scrollView;
@synthesize lblPictureCount;
@synthesize bottomView;
@synthesize arrPictures;
@synthesize currentIndex;

+ (void)showAlert:(NSMutableArray*)arrPicture delegate:(id)sender withTag:(NSInteger)iTag currentIndex:(NSInteger)index
{
    UIViewController *controller = [[UIViewController alloc] initWithNibName:@"PictureListingOverlay" bundle:[NSBundle mainBundle]];
    PictureListingOverlay *alert = (PictureListingOverlay *)controller.view;
    alert.arrPictures = [arrPicture mutableCopy];
    alert.currentIndex = index+1;
    
    
    float xOrigin = 0.0;
    for (int i = 0; i < [alert.arrPictures count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, 0, 320, 200)];
        [IconDownloader loadImageFromLink:[alert.arrPictures objectAtIndex:i] forImageView:imageView withPlaceholder:nil andContentMode:UIViewContentModeScaleAspectFill];
        //imageView.imageURL = [NSURL URLWithString:[alert.arrPictures objectAtIndex:i]];
        imageView.tag = i+100;
        [alert.scrollView addSubview:imageView];
        
        xOrigin += 320;
    }
    alert.scrollView.contentSize = CGSizeMake(xOrigin, 200);
    [alert.scrollView setPagingEnabled:YES];
    alert.scrollView.showsHorizontalScrollIndicator = NO;
    alert.scrollView.showsVerticalScrollIndicator = NO;
    
    alert.lblPictureCount.text = [NSString stringWithFormat:@"%d/%d", alert.currentIndex, alert.arrPictures.count];
    
    if (IS_IPHONE_5) {
        alert.bottomView.frame = CGRectMake(alert.bottomView.frame.origin.x, 514, alert.bottomView.frame.size.width, alert.bottomView.frame.size.height);
        alert.scrollView.frame = CGRectMake(alert.scrollView.frame.origin.x, 180, alert.scrollView.frame.size.width, alert.scrollView.frame.size.height);
    } else {
        alert.bottomView.frame = CGRectMake(alert.bottomView.frame.origin.x, 470, alert.bottomView.frame.size.width, alert.bottomView.frame.size.height);
        alert.scrollView.frame = CGRectMake(alert.scrollView.frame.origin.x, 160, alert.scrollView.frame.size.width, alert.scrollView.frame.size.height);
    }
    
    alert.lblPictureCount.text = [NSString stringWithFormat:@"%d/%d", alert.currentIndex, alert.arrPictures.count];
    CGRect rect = CGRectMake(0, alert.scrollView.frame.origin.y, alert.scrollView.frame.size.width*alert.currentIndex, alert.scrollView.frame.size.height);
    [alert.scrollView scrollRectToVisible:rect animated:NO];
    
    
    alert.delegate = sender;
	[alert show];
	[controller release];
}

#pragma mark - Action Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 1) {
        NSInteger index = self.currentIndex+100;
        UIImageView *imageView = (UIImageView*)[self.scrollView viewWithTag:index];
        UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);

    }
}


- (IBAction)btnSavePictureInCameraRollAction:(id)sender
{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:appname delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:@"Save to Camera Roll",nil];
    [action showInView:[UIApplication sharedApplication].keyWindow];
    [action release];
}

- (IBAction)dismissOverlayAction:(id)sender
{
    [self dismissWithSuccess:YES animated:YES childView:self];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.currentIndex = page;
    
    lblPictureCount.text = [NSString stringWithFormat:@"%d/%d", self.currentIndex+1, arrPictures.count];
}

#pragma mark - Baseclass methods

- (void)dialogWillAppear {
	[super dialogWillAppear];
}

- (void)dialogWillDisappear {
	[super dialogWillDisappear];
}

- (void)dealloc {
	self.arrPictures = nil;
    [super dealloc];
}


@end
