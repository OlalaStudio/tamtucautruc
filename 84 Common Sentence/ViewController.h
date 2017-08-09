//
//  ViewController.h
//  84 Common Sentence
//
//  Created by NguyenThanhLuan on 30/05/2017.
//  Copyright © 2017 Olala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLCommonDefines.h"
#import "Appirater.h"
#import "TLSettingViewController.h"
#import "TLDetailTableViewCell.h"
#import "TLPageViewController.h"
#import "TLAddViewController.h"
#import "TDatabaseManager.h"

@import GoogleMobileAds;

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,TLSettingViewControllerDelegate,GADBannerViewDelegate,TLPageViewControllerDelegate,UIAlertViewDelegate>{
    NSMutableArray      *listSentence;
    GADBannerView       *_adBannerView;
}

@property (weak, nonatomic) IBOutlet UITableView *sentenceTable;

- (IBAction)settingAction:(id)sender;
- (IBAction)selectPhrase:(id)sender;
- (IBAction)addPhrase:(id)sender;

@end

