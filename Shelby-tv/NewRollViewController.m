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

@interface NewRollViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) Frame *frame;
@property (copy, nonatomic) NSString *postedRollTitle;

- (void)createAPIObservers;
- (void)customizeView;
- (void)customizeShareButtonWithTitle:(NSString*)title;
- (void)populateView;
- (void)postCreateRollWasSuccessful;
- (void)postRollFrameWasSuccessful;

@end

@implementation NewRollViewController
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

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    switch ( [self.chosenPeopleArray count] ) {
        case 0:
            
            [self customizeShareButtonWithTitle:@"Share with Contacts"];
            break;
            
        case 1:
            [self customizeShareButtonWithTitle:[NSString stringWithFormat:@"1 Contact"]];
            break;
        
        default:
            [self customizeShareButtonWithTitle:[NSString stringWithFormat:@"%d Contacts", [self.chosenPeopleArray count]]];
            break;
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
    
    [self.rollButton setTitle:@"Roll It" forState:UIControlStateNormal];
    [self.rollButton setTitle:@"Roll It" forState:UIControlStateSelected];
    [self.rollButton setTitle:@"Roll It" forState:UIControlStateHighlighted];
    [self.rollButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rollButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.rollButton.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:17.0f]];
    
}

- (void)customizeShareButtonWithTitle:(NSString *)title
{
    [self.shareButton setTitle:title forState:UIControlStateNormal];
    [self.shareButton setTitle:title forState:UIControlStateSelected];
    [self.shareButton setTitle:title forState:UIControlStateHighlighted];
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.shareButton.titleLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:17.0f]];
}

- (void)populateView
{
    // Thumbnail
    [AsynchronousFreeloader loadImageFromLink:self.frame.video.thumbnailURL forImageView:self.thumbnailImageView withPlaceholderView:nil];
    
    // Labels
    self.nicknameLabel.text = self.frame.creator.nickname;
    self.videoNameLabel.text = self.frame.video.title;
    
}

- (void)postCreateRollWasSuccessful
{

    Roll *roll = [CoreDataUtility fetchRollWithTitle:self.postedRollTitle];
    NSString *rollID = roll.rollID;
    
    NSString *requestString = [NSString stringWithFormat:APIRequest_PostRollFrame, rollID, self.frame.frameID,[SocialFacade sharedInstance].shelbyToken];
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
    
    if ( [self.chosenPeopleArray count] ) {
        
        requestString = [NSString stringWithFormat:@"%@&destination[]=email",requestString];
        
        for ( NSUInteger i = 0; i<[self.chosenPeopleArray count]; i++) {
            
            NSString *recipient = [[self.chosenPeopleArray objectAtIndex:i] valueForKey:@"email"];
            NSString *addressString = [recipient stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            requestString = [NSString stringWithFormat:@"%@&addresses[]=%@", requestString, addressString];
            
        }
            
        NSLog(@"%@", requestString);
        
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    [request setHTTPMethod:@"POST"];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:request ofType:APIRequestType_PostShareRoll];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate addHUDWithMessage:[NSString stringWithFormat:@"Sharing roll, comrade!"]];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - Action Methods
- (IBAction)shareButtonAction:(id)sender
{
    
    if ( [SocialFacade sharedInstance].firstTimeScanningAddressBook ) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Shelby wants to access your Address Book"
                                                            message:@"Will you let her in!?"
                                                           delegate:self
                                                  cancelButtonTitle:@"HELL NAH!"
                                                  otherButtonTitles:@"Let her at it!", nil];
        
        [alertView show];
        
    } else {
     
        if ( ![self chosenPeopleArray] ) self.chosenPeopleArray = [NSMutableArray array];
        
        EmailSendToContactsViewController *emailViewController = [[EmailSendToContactsViewController alloc] initWithNibName:@"EmailSendToContactsViewController" bundle:nil withParentVC:self];
        [self.navigationController pushViewController:emailViewController animated:YES];
        
    }
    
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

#pragma mark - UIAlertViewDelegate Method
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        
        case 0:
            // Do nothing
            break;
        
        case 1:{
            
            // Make sure this popup never appears again
            [[SocialFacade sharedInstance] setFirstTimeScanningAddressBook:NO];
            
            if ( ![self chosenPeopleArray] ) self.chosenPeopleArray = [NSMutableArray array];
            
            EmailSendToContactsViewController *emailViewController = [[EmailSendToContactsViewController alloc] initWithNibName:@"EmailSendToContactsViewController" bundle:nil withParentVC:self];
            [self.navigationController pushViewController:emailViewController animated:YES];
            
        } break;
            
        default:
            break;
    }
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