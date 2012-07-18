//
//  RollItViewController.m
//  Shelby.tv
//
//  Created by Arthur Ariel Sabintsev on 7/9/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "RollItViewController.h"
#import "AsynchronousFreeloader.h"
#import "NewRollCell.h"
#import "ExistingRollCell.h"
#import "CoreDataUtility.h"

@interface RollItViewController ()

@property (strong, nonatomic) Frame *frame;
@property (strong, nonatomic) NSArray *myRolls;

- (void)addCustomBackButton;
- (void)customizeView;
- (void)populateView;
- (void)fetchMyRolls;

@end

@implementation RollItViewController
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize nicknameLabel = _nicknameLabel;
@synthesize videoNameLabel = _videoNameLabel;
@synthesize tableView = _tableView;
@synthesize frame = _frame;
@synthesize myRolls = _myRolls;

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
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self customizeView];
    [self populateView];
    [self fetchMyRolls];
}

#pragma mark - Private Methods
- (void)customizeView
{
    
    // Add Custom Back Button
    [self addCustomBackButton];
    
    // Customize view and tableView background and appearance 
    self.view.backgroundColor = ColorConstants_BackgroundColor;
    self.tableView.backgroundColor = ColorConstants_BackgroundColor;
    self.tableView.separatorColor = [UIColor clearColor];
    
    // Change title to Share
    [self.navigationItem setTitle:@"Roll"];
    
    // Customize UILabels (all of which are IBOutlets)
    [self.nicknameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.nicknameLabel.font.pointSize]];
    [self.nicknameLabel setTextColor:ColorConstants_GrayTextColor];
    
    [self.videoNameLabel setFont:[UIFont fontWithName:@"Ubuntu-Bold" size:self.videoNameLabel.font.pointSize]];
    [self.videoNameLabel setTextColor:[UIColor whiteColor]];
      
}

- (void)populateView
{
    // Thumbnail
    [AsynchronousFreeloader loadImageFromLink:self.frame.video.thumbnailURL forImageView:self.thumbnailImageView withPlaceholderView:nil];
    
    // Labels
    self.nicknameLabel.text = self.frame.creator.nickname;
    self.videoNameLabel.text = self.frame.video.title;
    
}

- (void)fetchMyRolls
{
    self.myRolls = [CoreDataUtility fetchMyRolls];
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

#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 1.0f, 310.0f, 21.0f)];
    label.backgroundColor = [UIColor clearColor];
    label.text = ( 0 == section ) ? @"Create a new roll" : @"Add to existing rolls";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Ubuntu-Bold" size:15.0f];
    
    UIView *view = [[UIView alloc] initWithFrame:tableView.tableHeaderView.frame];
    view.backgroundColor = ColorConstants_BackgroundColor;
    [view addSubview:label];
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ( 0 == section ) ? 1 : [self.myRolls count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ( 1 == indexPath.section ) {
    
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExistingRollCell" owner:self options:nil];
        ExistingRollCell *cell = (ExistingRollCell*)[nib objectAtIndex:0];
        
        Roll *roll = [self.myRolls objectAtIndex:indexPath.row];
        
        [AsynchronousFreeloader loadImageFromLink:roll.thumbnailURL forImageView:cell.userImageView withPlaceholderView:nil];
        cell.nicknameLabel.text = roll.creatorNickname;
        cell.privacyLabel.text = ( roll.isPublic ) ? @"Public" : @"Private";
        
        return cell;

    } else {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewRollCell" owner:self options:nil];
        NewRollCell *cell = (NewRollCell*)[nib objectAtIndex:0];
        
        return cell;
               
    }
        
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53.0f;
}

#pragma mark - Interface Orientation Methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
