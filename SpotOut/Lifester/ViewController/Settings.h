//
//  Settings.h
//  Lifester
//
//  Created by App Developer on 05/03/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "FbGraph.h"
#import <FacebookSDK/FacebookSDK.h>

@class TabView;

@interface Settings : UIViewController < UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate > {
    
    AppDelegate *appDelegateObj;
    IBOutlet UIButton *facebookBtn,*SoundBtn;
    FbGraph *fbGraph;
    int flag;
    IBOutlet UIView *backgroundView;
    IBOutlet UIScrollView *scroller;
    IBOutlet UIView *innerView,*SubView;
    IBOutlet UILabel *Head1,*Head2,*Head3,*Head4,*FacebookLbl,*BadgeLbl,*AlertLbl,*PushSoundLbl,*SoundLbl,*PostLbl,*LikesLbl,*InvitaionsLbl,*FrReqLbl,*ChatLbl,*SoundNameLbl;
    IBOutlet UIButton *BadgeBtn,*AlertBtn,*PushSoundBtn,*PostBtn,*LikesBtn,*InvitationBtn,*RequestBtn,*ChatBtn;
    
    IBOutlet UITableView *SoundTable;
    NSArray *SoundNameArr;
    UIButton *PlayBtn;
    NSIndexPath *lastIndexPath;
    int BtnTag,push_badge,push_alert,push_sound,push_posts,push_likes,push_invitations,push_requests,push_chats;
    NSString *sound_name;
    
    IBOutlet UIButton *SaveBtn1,*SaveBtn2;
}
@property(retain) NSIndexPath* lastIndexPath;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (nonatomic, retain) IBOutlet UITableView *SoundTable;
@property (nonatomic, retain) FbGraph *fbGraph;

// -(void)FaceBookBtncall;
-(IBAction)FaceBookBtnTapped:(id)sender;
-(IBAction)BackBtnCall:(id)sender;
-(IBAction)LogoutBtnCall:(id)sender;
-(IBAction)SoundBtnCall:(id)sender;


-(void)addWebService;

@end
