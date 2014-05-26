//
//  Settings_IPhone5.h
//  Lifester
//
//  Created by App Developer on 19/03/13.
//  Copyright (c) 2013 App Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "ViewController_IPhone5.h"

@class TabView;

@interface Settings_IPhone5 : UIViewController < UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate > {
    
    IBOutlet UIView *backgroundView;
    AppDelegate *appDelegateObj;
    IBOutlet UIButton *facebookBtn;
    FbGraph *fbGraph;
    int flag;
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
}
@property(retain) NSIndexPath* lastIndexPath;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (nonatomic, retain) IBOutlet UITableView *SoundTable;
@property (nonatomic, retain) FbGraph *fbGraph;

// -(void)FaceBookBtncall;
-(IBAction)ChangePassword:(id)sender;
-(IBAction)AboutBtnCall:(id)sender;
-(IBAction)FaceBookBtnTapped:(id)sender;
-(IBAction)SoundBtnCall:(id)sender;
-(IBAction)BackBtnCall:(id)sender;
-(IBAction)LogoutBtnCall:(id)sender;
-(IBAction)BadgeBtnCall:(id)sender;
-(IBAction)AlertBtnCall:(id)sender;
-(IBAction)PushSountBtnCall:(id)sender;
-(IBAction)PostBtnCall:(id)sender;
-(IBAction)LikesBtnCall:(id)sender;
-(IBAction)InvitationBtnCall:(id)sender;
-(IBAction)RequestBtnCall:(id)sender;
-(IBAction)ChatBtnCall:(id)sender;
-(IBAction)Save1BtnCall:(id)sender;
-(IBAction)Save2BtnCall:(id)sender;
-(IBAction)SelectBtnCall:(id)sender;


-(void)addWebService;

@end
