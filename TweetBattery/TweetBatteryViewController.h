//
//  TweetBatteryViewController.h
//  TweetBattery
//
//  Created by Kenichi Niwa on 2013/04/16.
//  Copyright (c) 2013年 Kenichi Niwa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface TweetBatteryViewController : UIViewController
    @property (strong, nonatomic) IBOutlet UILabel *PercentLabel;
    @property (strong, nonatomic) IBOutlet UILabel *StatusLabel;
    @property (strong, nonatomic) IBOutlet UIButton *TweetButton;
@end
