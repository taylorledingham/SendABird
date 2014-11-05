//
//  InboxMessageCell.h
//  SendABird
//
//  Created by Audrey Jun on 2014-11-04.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *senderLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeOfSenderLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateSentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateRecievedLabel;

@end
