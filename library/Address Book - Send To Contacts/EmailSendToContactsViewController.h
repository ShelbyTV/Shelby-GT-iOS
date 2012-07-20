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

@interface EmailSendToContactsViewController : UIViewController
<

UITableViewDataSource,
UITableViewDelegate,
UISearchBarDelegate,
UISearchDisplayDelegate

>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;

@end
