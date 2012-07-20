//
//  AddContactTableViewCell.h
//  CustomTable
//
//  Created by Arthur Sabintsev on 11/30/11.
//  Copyright (c) 2011 Fueled. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddContactTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *pictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;

@end