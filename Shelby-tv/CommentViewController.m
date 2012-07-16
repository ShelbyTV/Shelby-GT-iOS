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
#import "NSString+TypedefConversion.h"
#import "CommentCell.h"

@interface CommentViewController ()

@property (strong, nonatomic) Frame *frame;

@property (strong, nonatomic) NSArray *arrayOfMessages;

- (void)addCustomBackButton;
- (void)createAPIObservers;
- (void)customizeView;
- (void)populateView;

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


#pragma mark - Action Methods
-(void)sendButtonAction:(id)sender
{
    // Hide keyboard when SEND button is pressed
    if( [self.textField.text isEqualToString:@"\n"] ) [self.textField resignFirstResponder];
    
    // Remove text
    self.textField.text = @"";
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
    if ( message.createdAt.length ) { // Check if at least one message exists
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
        CommentCell *cell = (CommentCell*)[nib objectAtIndex:0];
        
        [AsynchronousFreeloader loadImageFromLink:message.userImageURL forImageView:cell.thumbnailImageView withPlaceholderView:nil];
        [cell.nicknameLabel setText:message.nickname];
        [cell.commentLabel setText:message.text];
        [cell.timestampLabel setText:message.createdAt];
        
            return cell;
        
    } else {
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:CellIdentifier];
        
            return cell;
    }
    
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.textFieldContainerView.frame = CGRectMake(0.0f, 328.0f, self.textFieldContainerView.frame.size.width, self.textFieldContainerView.frame.size.height);
                     }];

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