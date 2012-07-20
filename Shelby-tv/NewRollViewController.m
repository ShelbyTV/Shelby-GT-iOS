//
//  NewRollViewController.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 7/17/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "NewRollViewController.h"
#import "AsynchronousFreeloader.h"
#import "SocialFacade.h"
#import "ShelbyAPIClient.h"
#import "CoreDataUtility.h"
#import "AppDelegate.h"
#import "NSString+TypedefConversion.h"
#import "EmailSendToContactsViewController.h"

@interface NewRollViewController ()

@property (strong, nonatomic) Frame *frame;
@property (copy, nonatomic) NSString *postedRollTitle;

- (void)addCustomBackButton;
- (void)createAPIObservers;
- (void)customizeView;
- (void)populateView;
- (void)postCreateRollWasSuccessful;
- (void)postRollFrameWasSuccessful;

@end

@implementation NewRollViewController
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize nicknameLabel = _nicknameLabel;
@synthesize videoNameLabel = _videoNameLabel;
@synthesize createNewRollLabel = _createNewRollLabel;
@synthesize rollNameLabel = _rollNameLabel;
@synthesize titleTextField = _titleTextField;
@synthesize privacySwitch = _privacySwitch;
@synthesize shareButton = _shareButton;
@synthesize rollButton = _rollButton;
@synthesize frame = _frame;
@synthesize postedRollTitle = _postedRollTitle;
@synthesize chosenPeopleArray = _chosenPeopleArray;

#pragma mark - Initialization Method
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFrame:(Frame *)frame
{
    if ( self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
        
        self.frame = frame;
        
    }
    
    return self;
}

#pragma mark - View Lifecycle Methods
- (void)viewDidUnload
{
    self.thumbnailImageView = nil;
    self.nicknameLabel = nil;
    self.videoNameLabel = nil;
    self.createNewRollLabel = nil;
    self.rollNameLabel = nil;
    self.titleTextField = nil;
    self.shareButton = nil;
    self.rollButton = nil;
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createAPIObservers];
    [self customizeView];
    [self populateView];
}

#pragma mark - Private Methods
- (void)createAPIObservers
{
    
    NSString *createRollNotification = [NSString requestTypeToString:APIRequestType_PostCreateRoll];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(postCreateRollWasSuccessful)
                                                 name:createRollNotification
                                               object:nil];
    
    NSString *shareRollNotification = [NSString requestTypeToString:APIRequestType_PostRollFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(postRollFrameWasSuccessful)
                                                 name:shareRollNotification
                                               object:nil];

}

- (void)customizeView
{
    
    // Add Custom Back Button
    [self addCustomBackButton];
    
    // Customize view and tableView background and appearance
    self.view.backgroundColor = ColorConstants_BackgroundColor;
    
    // Change title to Share
    [self.navigationItem setTitle:@"Roll"];
    
    // Customize UILabels (all of which are IBOutlets)
    [self.nicknameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.nicknameLabel.font.pointSize]];
    [self.nicknameLabel setTextColor:ColorConstants_GrayTextColor];
    
    [self.videoNameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.videoNameLabel.font.pointSize]];
    [self.videoNameLabel setTextColor:[UIColor whiteColor]];
    
    [self.createNewRollLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.createNewRollLabel.font.pointSize]];
    [self.createNewRollLabel setTextColor:[UIColor whiteColor]];
    
    [self.rollNameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.rollNameLabel.font.pointSize]];
    [self.rollNameLabel setTextColor:[UIColor whiteColor]];
    
    [self.shareButton setTitle:@"Share with Contacts" forState:UIControlStateNormal];
    [self.shareButton setTitle:@"Share with Contacts" forState:UIControlStateSelected];
    [self.shareButton setTitle:@"Share with Contacts" forState:UIControlStateHighlighted];
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.shareButton.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:17.0f]];
    
    [self.rollButton setTitle:@"Roll It" forState:UIControlStateNormal];
    [self.rollButton setTitle:@"Roll It" forState:UIControlStateSelected];
    [self.rollButton setTitle:@"Roll It" forState:UIControlStateHighlighted];
    [self.rollButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rollButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.rollButton.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:17.0f]];
    
}

- (void)populateView
{
    // Thumbnail
    [AsynchronousFreeloader loadImageFromLink:self.frame.video.thumbnailURL forImageView:self.thumbnailImageView withPlaceholderView:nil];
    
    // Labels
    self.nicknameLabel.text = self.frame.creator.nickname;
    self.videoNameLabel.text = self.frame.video.title;
    
}

- (void)addCustomBackButton
{
    UIButton *backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 51, 30)];
    [backBarButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backBarButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:backBarButtonItem];
}

- (void)postCreateRollWasSuccessful
{

    Roll *roll = [CoreDataUtility fetchRollWithTitle:self.postedRollTitle];
    NSString *rollID = roll.rollID;
    NSString *videoURL = [self.frame.video.sourceURL stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSString *requestString = [NSString stringWithFormat:APIRequest_PostRollFrame, rollID, self.frame.frameID, videoURL, [SocialFacade sharedInstance].shelbyToken];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    [request setHTTPMethod:@"POST"];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:request ofType:APIRequestType_PostRollFrame];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate addHUDWithMessage:@"Adding video to roll, broski!"];
    

}

- (void)postRollFrameWasSuccessful
{

    Roll *roll = [CoreDataUtility fetchRollWithTitle:self.postedRollTitle];
    NSString *rollID = roll.rollID;
    NSString *rollTitle = roll.title;

    NSString *requestString = [NSString stringWithFormat:APIRequest_PostShareRoll, rollID, [SocialFacade sharedInstance].shelbyToken];
    NSString *textString = [rollTitle stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    requestString = [NSString stringWithFormat:@"%@&text=%@", requestString, textString];
    
    NSString *emailString = [@"arthur@sabintsev.com" stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    requestString = [NSString stringWithFormat:@"%@&destination[]=email&addresses[]=%@", requestString, emailString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    [request setHTTPMethod:@"POST"];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:request ofType:APIRequestType_PostShareRoll];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate addHUDWithMessage:[NSString stringWithFormat:@"Sharing roll with %d contact(s), comrade!", 1]];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - Action Methods
- (IBAction)shareButtonAction:(id)sender
{
    if ( ![self chosenPeopleArray] ) self.chosenPeopleArray = [NSMutableArray array];
    
    EmailSendToContactsViewController *emailViewController = [[EmailSendToContactsViewController alloc] initWithNibName:@"EmailSendToContactsViewController" bundle:nil withParentVC:self];
    [self.navigationController pushViewController:emailViewController animated:YES];
    
}

- (IBAction)rollButtonAction:(id)sender
{
    
    if ( ![self.titleTextField.text length] ) {

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Missing Roll Title"
                                                            message:@"Please give your roll a title and try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"Dismiss"
                                                   otherButtonTitles:nil, nil];
        [alertView show];
        
    } else {
    
        // Store value
        self.postedRollTitle = self.titleTextField.text;
        
        NSString *titleString = [self.titleTextField.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        BOOL public;
        BOOL collaborative;
        
        if ( [self.privacySwitch isOn] ) { // Private, Collaborative
            
            public = NO;
            collaborative = YES;
            
        } else { // Public, Non-Collaborative
            
            public = YES;
            collaborative = NO;
        
        }
        
        NSString *requestString = [NSString stringWithFormat:APIRequest_PostCreateRoll, titleString, public, collaborative, [SocialFacade sharedInstance].shelbyToken];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
        [request setHTTPMethod:@"POST"];
        ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
        [client performRequest:request ofType:APIRequestType_PostCreateRoll];
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate addHUDWithMessage:@"Creating roll, homeslice!"];
        
    }
    
}

#pragma mark - UITextFieldDelegate Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Hide keyboard when DONE button is pressed
    if( [string isEqualToString:@"\n"] ) {
    
        [textField resignFirstResponder];
        
    }
    
    return YES;
}


#pragma mark - UIResponder Methods
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ( [self.titleTextField isFirstResponder] ) [self.titleTextField resignFirstResponder];
}

#pragma mark - Interface Orientation Methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end