//
//  CommentViewController.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 7/9/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentCell.h"

@interface CommentViewController ()

@property (strong, nonatomic) Frame *frame;
@property (strong, nonatomic) NSMutableArray *arrayOfMessages;
@property (strong, nonatomic) NSMutableArray *arrayOfBullshitMessages;

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
@synthesize arrayOfMessages = _arrayOfMessages;
@synthesize arrayOfBullshitMessages = _arrayOfBullshitMessages;

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
    
    
    self.arrayOfMessages = [NSMutableArray array];
    self.arrayOfBullshitMessages = [NSMutableArray array];
    
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
    [self.nicknameLabel setTextColor:ColorConstants_GrayTextColor];
    
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
    
    NSString *createdAt = @"just now";
    [message setValue:createdAt forKey:CoreDataMessagesCreatedAt];
    
    NSString *nickname = [SocialFacade sharedInstance].shelbyNickname;
    [message setValue:nickname forKey:CoreDataMessagesNickname];
    
    NSDate *timestamp = [NSDate date];
    [message setValue:timestamp forKey:CoreDataMessagesTimestamp];
    
    NSString *text = self.textField.text;
    [message setValue:text forKey:CoreDataMessagesText];
    
    NSString *userImage = [SocialFacade sharedInstance].shelbyUserImage;
    [message setValue:userImage forKey:CoreDataMessagesUserImage];

    
    [self.arrayOfBullshitMessages addObject:message];

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
    
    // Refresh UITableView
    [self.tableView reloadData];
    
    // Perform API Request
    NSString *messageString = [self.textField.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *requestString = [NSString stringWithFormat:APIRequest_PostMessage, self.frame.conversation.conversationID, messageString, [SocialFacade sharedInstance].shelbyToken];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    [request setHTTPMethod:@"POST"];
    ShelbyAPIClient *client = [[ShelbyAPIClient alloc] init];
    [client performRequest:request ofType:APIRequestType_PostMessage];
    
    // Clean up
    self.textField.text = @"";
    [self.sendButton setEnabled:NO];
    
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
    
    [self.arrayOfMessages removeAllObjects];
    [self.arrayOfMessages addObjectsFromArray:[CoreDataUtility fetchAllMessagesFromConversation:self.frame.conversation]];
    if ( [self.arrayOfBullshitMessages count] ) [self.arrayOfMessages addObject:[self.arrayOfBullshitMessages lastObject]];
    
    return ( [self.arrayOfMessages count] ) ? [self.arrayOfMessages count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( [self.arrayOfMessages count] ) { // Check if messages exist
        
        Messages *message = [self.arrayOfMessages objectAtIndex:indexPath.row];
        
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
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"Ubuntu-Bold" size:15.0f];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate Methods
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