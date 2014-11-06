//
//  SentMessageTableViewCell.h
//  SendABird
//
//  Created by Taylor Ledingham on 2014-11-06.
//  Copyright (c) 2014 sendabird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SentMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *receivedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;
@property (weak, nonatomic) IBOutlet UIImageView *birdImageView;

@end
