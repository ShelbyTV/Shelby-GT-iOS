//
//  EmailSendToContactsViewController.h
//  Picsee
//
//  Created by Arthur Sabintsev on 11/29/11.
//  Copyright (c) 2011 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>

@class NewRollViewController;
@interface ShareWithContactsViewController : UIViewController
<

UITableViewDataSource,
UITableViewDelegate,
UISearchBarDelegate,
UISearchDisplayDelegate

>

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
         withParentVC:(NewRollViewController*)viewController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
