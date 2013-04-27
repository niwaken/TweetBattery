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

@end
