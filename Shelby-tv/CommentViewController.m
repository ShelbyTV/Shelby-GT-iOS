//
//  CommentViewController.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 7/9/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "CommentViewController.h"
#import "AsynchronousFreeloader.h"
#import "CoreDataUtility.h"
#import "SocialFacade.h"
#import "ShelbyAPIClient.h"
#import "NSString+TypedefConversion.h"
#import "CommentCell.h"

@interface CommentViewController ()

@property (strong, nonatomic) Frame *frame;

@property (strong, nonatomic) NSArray *arrayOfMessages;

- (void)addCustomBackButton;
- (void)createAPIObservers;
- (void)customizeView;
- (void)populateView;

- (void)replyButtonAction;
- (void)storeMessageInCoreData;
- (NSString *)getUUID;

@end

@implementation CommentViewController
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize nicknameLabel = _nicknameLabel;
@synthesize videoNameLabel = _videoNameLabel;
@synthesize textFieldContainerView = _textFieldContainerView;
@synthesize textField = _textField;
@synthesize sendButton = _sendButton;
@synthesize tableView = _tableView;
@synthesize arrayOfMessages = arrayOfMessages;

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
    self.textFieldContainerView = nil;
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizeView];
    [self populateView];
}

#pragma mark - Private Methods
- (void)customizeView
{
    self.view.backgroundColor = ColorConstants_BackgroundColor;
    self.tableView.backgroundColor = ColorConstants_BackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self addCustomBackButton];
    [self.navigationItem setTitle:@"Comment"];
    
    [self.nicknameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.nicknameLabel.font.pointSize]];
    [self.nicknameLabel setTextColor:[UIColor whiteColor]];
    
    [self.videoNameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.videoNameLabel.font.pointSize]];
    [self.videoNameLabel setTextColor:[UIColor whiteColor]];

    [self.textFieldContainerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"commentBar"]]];
    
    [self.sendButton setEnabled:NO];
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
    [backBarButton setImage:[UIImage imageNamed:@"navigationButtonBack"] forState:UIControlStateNormal];
    [backBarButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setLeftBarButtonItem:backBarButtonItem];
}

- (void)createAPIObservers
{
    
    NSString *notificationName = [NSString requestTypeToString:APIRequestType_PostShareFrame];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataReturnedFromAPI:)
                                                 name:notificationName
                                               object:nil];
}


- (void)storeMessageInCoreData
{
    
    Messages *message = [NSEntityDescription insertNewObjectForEntityForName:CoreDataEntityMessages inManagedObjectContext:self.frame.managedObjectContext];
    [self.frame.conversation addMessagesObject:message];
    
    // Hold reference to parent conversationID
    [message setValue:self.frame.conversation.conversationID forKey:CoreDataConversationID];
    
    NSString *messageID = [self getUUID];
    [message setValue:messageID forKey:CoreDataMessagesID];
    
    NSString *createdAt = @"Just now";
    [message setValue:createdAt forKey:CoreDataMessagesCreatedAt];
    
    NSString *nickname = [SocialFacade sharedInstance].shelbyNickname;
    [message setValue:nickname forKey:CoreDataMessagesNickname];
    
    [message setValue:@"" forKey:CoreDataMessagesOriginNetwork];
    
    NSDate *timestamp = [NSDate date];
    [message setValue:timestamp forKey:CoreDataMessagesTimestamp];
    
    NSString *text = self.textField.text;
    [message setValue:text forKey:CoreDataMessagesText];
    
    NSString *userImage = [SocialFacade sharedInstance].shelbyUserImage;
    [message setValue:userImage forKey:CoreDataMessagesUserImage];
    
    NSUInteger messageCount = [self.frame.conversation.messageCount intValue];
    messageCount++;
    [self.frame.conversation setValue:[NSNumber numberWithInt:messageCount] forKey:CoreDataConversationMessageCount];

    [CoreDataUtility saveContext:self.frame.managedObjectContext];
}

- (NSString *)getUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string ;
}

#pragma mark - Action Methods
- (IBAction)sendButtonAction:(id)sender
{
    // Hide keyboard when sendButton is pressed
    [self.textField resignFirstResponder];
 
    // Add Comment to Messages in Core Data
    [self storeMessageInCoreData];
    
    // Remove text from textField
    self.textField.text = @"";
    
    // Disable sendButton since the textField is empty
    [self.sendButton setEnabled:NO];
    
    // Refresh UITableView
    [self.tableView reloadData];
    
    // Ping API
    
}

- (void)replyButtonAction
{
    [self.textField becomeFirstResponder];
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.arrayOfMessages = [CoreDataUtility fetchAllMessagesFromConversation:self.frame.conversation];
    
    return ( [self.arrayOfMessages count] ) ? [self.arrayOfMessages count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Messages *message = [self.arrayOfMessages objectAtIndex:indexPath.row];
    
    if ( [self.arrayOfMessages count] ) { // Check if messages exist
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
        CommentCell *cell = (CommentCell*)[nib objectAtIndex:0];
        
        [AsynchronousFreeloader loadImageFromLink:message.userImage forImageView:cell.thumbnailImageView withPlaceholderView:nil];
        [cell.nicknameLabel setText:message.nickname];
        [cell.commentLabel setText:message.text];
        [cell.timestampLabel setText:message.createdAt];
        [cell.replyButton addTarget:self action:@selector(replyButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    } else {
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:CellIdentifier];
        
        cell.textLabel.text = @"Be the first to comment";
        
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ( [self.arrayOfMessages count] ) ? 92.0f : 44.0f;
}

#pragma mark - UITextFieldDelefate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.textFieldContainerView.frame = CGRectMake(0.0f, 157.0f, self.textFieldContainerView.frame.size.width, self.textFieldContainerView.frame.size.height);
                     }];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.textFieldContainerView.frame = CGRectMake(0.0f, 328.0f, self.textFieldContainerView.frame.size.width, self.textFieldContainerView.frame.size.height);
                     }];

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Hide keyboard when SEND button is pressed
    if( [string isEqualToString:@"\n"] ) {
        
        [textField resignFirstResponder];
        [self sendButtonAction:nil];
        
    }
    
    if ( range.location > 0 ) { // Enable sendButton
        
        [self.sendButton setEnabled:YES];
        
    } else { // Disable sendButton
        
        [self.sendButton setEnabled:YES];
    }
    
    return YES;
}

#pragma mark - UIResponder Methods
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Resign Keyboard if any view element is touched that isn't currently a firstResponder UITextField object
    if ( [self.textField isFirstResponder] ) [self.textField resignFirstResponder];
        
}

#pragma mark - Interface Orientation Method
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end