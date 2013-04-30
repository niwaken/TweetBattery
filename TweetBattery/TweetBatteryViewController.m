//
//  TweetBatteryViewController.m
//  TweetBattery
//
//  Created by Kenichi Niwa on 2013/04/16.
//  Copyright (c) 2013年 Kenichi Niwa. All rights reserved.
//

#import "TweetBatteryViewController.h"

@interface TweetBatteryViewController ()

@end

@implementation TweetBatteryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // バッテリー状態監視をONにする
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(batteryLevelDidChange:)
                                                 name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    
    // 初回なので表示用に1回呼ぶ
    [self batteryLevelDidChange];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(batteryStateDidChange:)
                                                 name:UIDeviceBatteryStateDidChangeNotification object:nil];

    // 初回なので表示用に1回呼ぶ
    [self batteryStateDidChange];

    // アプリスリープ時からの復帰通知処理を登録
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:@"applicationDidBecomeActive"
                                               object:nil];
    
    
    
}

// 充電ステータス変化時の通知用
- (void) batteryStateDidChange:(NSNotification *)notification
{
    [self batteryStateDidChange];
}

// 充電レベル変化時の通知用
- (void) batteryLevelDidChange:(NSNotification *)notification
{
    [self batteryLevelDidChange];
}

// 充電状態表示用メソッド
- (void) batteryStateDidChange
{
    int state = [UIDevice currentDevice].batteryState;

    switch (state) {
        case UIDeviceBatteryStateUnknown:
            _StatusLabel.text = @"不明";
            break;
        case UIDeviceBatteryStateUnplugged:
            _StatusLabel.text = @"放電中";
            break;
        case UIDeviceBatteryStateCharging:
            _StatusLabel.text = @"充電中";
            break;
        case UIDeviceBatteryStateFull:
            _StatusLabel.text = @"充電済";
            break;
            
            
        default:
            break;
    }
    
}

// 充電度合い表示用メソッド
- (void) batteryLevelDidChange
{
    float batteryLevel = [UIDevice currentDevice].batteryLevel;
    NSNumber* battery = [[NSNumber alloc]initWithFloat:batteryLevel];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    [numberFormatter setMaximumFractionDigits:1];
    
    _PercentLabel.text = [numberFormatter stringFromNumber:battery];    
    
}

// スリープから復帰時のイベント処理
- (void) applicationDidBecomeActive: (NSNotification *) notification
{
    // バッテリ%、充電状態の表示を更新する
    [self batteryStateDidChange];
    [self batteryLevelDidChange];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 呼ばれた時点の時刻を文字列で返すメソッド
- (NSString*)getNowTimeString
{

    NSDate *now = [NSDate date];
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc]init];
    [dtFormatter setDateFormat:@"H時m分"];

    NSString *ret = [[NSString alloc]initWithString:[dtFormatter stringFromDate:now]];

    return ret;
    
}

// つぶやき用文字列作成メソッド
- (NSString*)createTweetString
{
    
    NSMutableString *tweetString = [[NSMutableString alloc]init];
    
    
    [tweetString appendString:[self getNowTimeString]];
    
    [tweetString appendString:@"の残容量は"];
    // 残容量をラベルから現在の%を取得してテキストに
    [tweetString appendString:_PercentLabel.text];
    
    [tweetString appendString:@"、バッテリーの状態は"];
    // 充電中ステータスを付加
    [tweetString appendString:_StatusLabel.text];

    // 改行とハッシュタグ付加
    [tweetString appendString:@"\n #tweetBattery"];

     return tweetString;
    
}

// Twitterに呟きを行うメソッド
- (void)doTweet:(NSString*)tweetString {

    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        NSString *serviceType = SLServiceTypeTwitter;
        SLComposeViewController *composeCtl = [SLComposeViewController composeViewControllerForServiceType:serviceType];
        [composeCtl setInitialText:tweetString];
//        [composeCtl setCompletionHandler:^(SLComposeViewControllerResult result) {
//            if (result == SLComposeViewControllerResultDone) {
//
//            }
//        }];
        [self presentViewController:composeCtl animated:YES completion:nil];
    }
    
}

// TweetButtonを押された時の処理
- (IBAction)pushTweetButton:(id)sender {

    NSMutableString *tweetString = [[NSMutableString alloc]init];
    
    [tweetString appendString:[self createTweetString]];

    [self doTweet:[self createTweetString]];
    // for Debug
//    NSLog(@"%@", tweetString);
    
    
}


@end
