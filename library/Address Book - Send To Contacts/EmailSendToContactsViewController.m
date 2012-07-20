//
//  EmailSendToContactsViewController.m
//  Picsee
//
//  Created by Arthur Sabintsev on 11/29/11.
//  Copyright (c) 2011 Fueled. All rights reserved.
//

#import "EmailSendToContactsViewController.h"
#import "AddContactTableViewCell.h"
#import "RemoveContactTableViewCell.h"
#import "StaticDeclarations.h"
#import "NewRollViewController.h"

@interface EmailSendToContactsViewController ()

@property (strong, nonatomic) NSMutableArray *peopleArray;                                  // Array of Dictionaries organized by Address Book Contacts
@property (strong, nonatomic) NSMutableArray *sortedEmailArray;                             // Array of Dictionaries organized by Email Address
@property (strong, nonatomic) NSMutableArray *filteredResultsArray;                         // Array of Dictionaries presented upon Search Query
@property (strong, nonatomic) NSMutableArray *chosenPeopleArray;                            // Array of Dictionaries who will receive postcard

- (void)allocatePrivateMemory;                                                              // Allocate Private Memory
- (void)customizeView;                                                                      // Customize view and tableView
- (void)arrayPopulator;                                                                     // Populate peopleArray and sortedEmailArray
- (void)filterContentForSearchText:(NSString*)searchText;                                   // Filters results array when searching
- (void)plusButtonTapped:(id)sender event:(id)event;                                        // Plus Button Accessory View Tapped
- (void)minusButtonTapped:(id)sender event:(id)event;                                       // Minus Button Accessory View Tapped
- (void)plusButtonActionForIndexPath:(NSIndexPath*)indexPath;                               // Add selected user to chosenPeopleArray
- (void)minusButtonActionForIndexPath:(NSIndexPath*)indexPath;                              // Remove selected user from chosenPeopleArray

- (void)addCustomBackButton;
- (void)addCustomDoneButton;

@end

@implementation EmailSendToContactsViewController
@synthesize peopleArray = _peopleArray;
@synthesize sortedEmailArray = _sortedEmailArray;
@synthesize filteredResultsArray = _filteredResultsArray;
@synthesize chosenPeopleArray = _chosenPeopleArray;
@synthesize tableView = _tableView;
@synthesize arrowImageView = _arrowImageView;

#pragma mark - Initialization Method
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
         withParentVC:(NewRollViewController *)viewController
{
    if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
    
        self.chosenPeopleArray = viewController.chosenPeopleArray;
    
    }
    
    return self;
    
}

#pragma mark - Memory Allocation Methods
- (void)allocatePrivateMemory
{
    self.peopleArray = [NSMutableArray array];
    self.sortedEmailArray = [NSMutableArray array];
    self.filteredResultsArray = [NSMutableArray array];
}

#pragma mark - View Lifecycle Methods
- (void)dealloc
{
    //    self.backButton = nil;
    //    self.sendButton = nil;
    //    self.tableView = nil;
    //    self.arrowImageView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self allocatePrivateMemory];
    [self customizeView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self arrayPopulator];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.filteredResultsArray removeAllObjects];
}

#pragma mark - Private Methods
- (void)customizeView
{
    self.view.backgroundColor = ColorConstants_BackgroundColor;
    self.tableView.backgroundColor = ColorConstants_BackgroundColor;
    self.tableView.separatorColor = [UIColor clearColor];
    self.title = @"Select Contacts";
    
    [self addCustomDoneButton];
    [self addCustomBackButton];
}

- (void)arrayPopulator
{

    // Contact Dictionary and Array Setup    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for (CFIndex i = 0; i < CFArrayGetCount(people); i++) {
        
        NSMutableDictionary *userDictionary = [NSMutableDictionary dictionary];
        
        // Get Full Name
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        ABMultiValueRef firstName = ABRecordCopyValue(person, kABPersonSortByFirstName);
        ABMultiValueRef lastName = ABRecordCopyValue(person, kABPersonSortByLastName);
        
        NSString *fullName;
        
        if (firstName != nil && lastName != nil) {
            fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        } else if (lastName == nil) {
            fullName = [NSString stringWithFormat:@"%@", firstName];
        } else if (firstName == nil) {
            fullName = [NSString stringWithFormat:@"%@", lastName];
        } else {
            fullName = nil;
        }
                   
        
        // Get Image
        UIImage *photo = ( ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail) != nil ) 
                        ? [UIImage imageWithData:(__bridge NSData *) ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail)]
                        : [UIImage imageNamed:@"searchContactsAvatar"];
        
        // Get Email Address(es) 
        NSMutableArray *emailsArray = [[NSMutableArray alloc] initWithCapacity:CFArrayGetCount(people)];
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        
        for (CFIndex j=0; j < ABMultiValueGetCount(emails); j++) {
            [emailsArray addObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(emails, j)];
        }
        
        // Add Name, Image, and Email to Dictionary
        [userDictionary setValue:fullName forKey:@"name"];
        [userDictionary setValue:emailsArray forKey:@"emails"];
        [userDictionary setValue:photo forKey:@"photo"];
        
        // Release Objects
        if (firstName) {
            CFRelease(firstName);
        }
        if (lastName) {
            CFRelease(lastName);
        }
        if (emails) {
            CFRelease(emails);
        }
        
        // Populate Array of Dictionaries, organized by contact
        [self.peopleArray addObject:userDictionary];
        
    }
    
    // Release Remaning CFObjects
    CFRelease(people);
    CFRelease(addressBook);
    
    
    // Reorganize Dictionary in terms of Email
    for (int i = 0; i < [self.peopleArray count]; i++) {
        
        NSDictionary *peopleDictionary = [self.peopleArray objectAtIndex:i];
        NSMutableArray *emailsArray = [peopleDictionary valueForKey:@"emails"];
        
        for (int j = 0; j < [emailsArray count]; j++) {
            
            NSMutableDictionary *emailDictionary = [[NSMutableDictionary alloc] init];
            
            [emailDictionary setValue:[emailsArray objectAtIndex:j] forKey:@"email"];
            [emailDictionary setValue:[peopleDictionary valueForKey:@"name"] forKey:@"name"];
            [emailDictionary setValue:[peopleDictionary valueForKey:@"photo"] forKey:@"photo"];
            [self.sortedEmailArray addObject:emailDictionary];

        }
        
    }

}


- (void)filterContentForSearchText:(NSString*)searchText 
{
    
    // Clear Filtered Array
	[self.filteredResultsArray removeAllObjects];
    
	// Search sortedEmailArray for the query;
    for (NSDictionary *dictionary in self.sortedEmailArray) {
        
        NSString *name = [dictionary valueForKey:@"name"];
        
        NSComparisonResult resultForName = [name compare:searchText 
                                                 options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) 
                                                   range:NSMakeRange(0, [searchText length])];
        
        if (resultForName == NSOrderedSame) {
            [self.filteredResultsArray addObject:dictionary];
        }
        
    }
    
    
}

#pragma mark - TableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    
	return (tableView == self.searchDisplayController.searchResultsTableView) 
    ? [self.filteredResultsArray count] 
    : [self.chosenPeopleArray count];
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) { /// If front-most tableView is due to search performed by user
        
        tableView.backgroundColor = ColorConstants_BackgroundColor;
        tableView.separatorColor = [UIColor clearColor];
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AddContactTableViewCell" owner:nil options:nil];
        AddContactTableViewCell *cell = [topLevelObjects objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dictionary = [self.filteredResultsArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = [dictionary valueForKey:@"name"];
        cell.emailLabel.text = [dictionary valueForKey:@"email"];
        cell.pictureView.frame = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
        cell.pictureView.image = [dictionary valueForKey:@"photo"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, 29.0f, 30.0f);
        [button setImage:[UIImage imageNamed:@"plusButtonAccessoryView"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(plusButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = button;
        
        return cell;
        
    } else { 
        
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RemoveContactTableViewCell" owner:nil options:nil];
        RemoveContactTableViewCell *cell = [topLevelObjects objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (0 == [self.chosenPeopleArray count]) { /// If 0 contacts chosen
            
            self.arrowImageView.hidden = NO;
            tableView.hidden = YES;
            
        
        } else { /// If 1 or more contacts chosen
            
            self.arrowImageView.hidden = YES;
            tableView.hidden = NO;
            
            NSDictionary *dictionary = [self.chosenPeopleArray objectAtIndex:indexPath.row];
            cell.nameLabel.text = [dictionary valueForKey:@"name"];
            cell.emailLabel.text = [dictionary valueForKey:@"email"];
            cell.pictureView.frame = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
            cell.pictureView.image = [dictionary valueForKey:@"photo"];
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0.0f, 0.0f, 29.0f, 30.0f);
            [button setImage:[UIImage imageNamed:@"minusButtonAccessoryView"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(minusButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = button;
            
        }
        
        return cell;
    }
    
}

#pragma mark - UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    return YES;
}

#pragma mark - Accessory Button Event Handling Methods
- (void)plusButtonTapped:(id)sender event:(id)event
{
 
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.searchDisplayController.searchResultsTableView];
    NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForRowAtPoint:currentTouchPosition];
    [self plusButtonActionForIndexPath:indexPath];

    
}

- (void)minusButtonTapped:(id)sender event:(id)event
{
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    [self minusButtonActionForIndexPath:indexPath];
    
}

- (void)plusButtonActionForIndexPath:(NSIndexPath*)indexPath
{
    
    [self.chosenPeopleArray addObject:[self.filteredResultsArray objectAtIndex:indexPath.row]];
    [self.tableView reloadData];
    [self.searchDisplayController setActive:NO animated:YES];
    
}


- (void)minusButtonActionForIndexPath:(NSIndexPath*)indexPath
{
    
    [self.chosenPeopleArray removeObjectAtIndex:indexPath.row];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];  
    [self.tableView endUpdates];
    
    if ( 0 == [self.chosenPeopleArray count] ) {
        
        self.arrowImageView.hidden = NO;
        self.tableView.hidden = YES;
        
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - Action Methods
- (void)addCustomDoneButton
{
    UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                       target:self.navigationController
                                                                                       action:@selector(popViewControllerAnimated:)];
    [self.navigationItem setRightBarButtonItem:doneBarButtonItem];
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

#pragma mark - Interface Rotation Methods
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end