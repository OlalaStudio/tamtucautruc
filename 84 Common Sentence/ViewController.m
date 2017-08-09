//
//  ViewController.m
//  84 Common Sentence
//
//  Created by NguyenThanhLuan on 30/05/2017.
//  Copyright © 2017 Olala. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController{
    TLSettingViewController *settingView;
    TLPageViewController    *selectedviewcontroller;
    
    BOOL isShowSwipe;
    NSArray *selectedArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //load banner ads
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeFullBanner];
    }
    else{
        _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    }
    
    [_adBannerView setAdUnitID:@"ca-app-pub-4039533744360639/3951124903"];
    [_adBannerView setDelegate:self];
    [_adBannerView setRootViewController:self];
    
    [_sentenceTable setDelegate:self];
    [_sentenceTable setDataSource:self];
    [_sentenceTable setAllowsSelection:NO];
    [_sentenceTable setAllowsMultipleSelection:NO];
    [_sentenceTable registerNib:[UINib nibWithNibName:@"TLDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"idCellDetail"];
    
    listSentence = [[NSMutableArray alloc] initWithCapacity:0];
    
    isShowSwipe = NO;
}

-(void)initDatabase{
    
    TDatabaseManager *dbManager = [TDatabaseManager sharedInstance];
    
    if([dbManager open:@"84cautruc_data.db"]){
        
        NSString *query = @"SELECT * FROM cautruc";
        
        // Get the results.
        listSentence = [NSMutableArray arrayWithArray:[dbManager loadDataFromDB:query]];
        
        [dbManager close];
    }
    
    [_sentenceTable reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self initDatabase];
    
    [self runRateApp];
    
    GADRequest *request = [GADRequest request];
//    request.testDevices = @[kGADSimulatorID,@"aea500effe80e30d5b9edfd352b1602d"];
    [_adBannerView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return _adBannerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return _adBannerView.frame.size.height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listSentence count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TLDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellDetail"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    NSArray *item    = [listSentence objectAtIndex:indexPath.row];
    NSString *title  = @"";
    NSString *catID  = @"";
    NSString *translate = @"";
    NSString *example = @"";
    NSString *exampletranslate = @"";
    
    catID = [item objectAtIndex:0];
    title = [item objectAtIndex:1];
    translate = [item objectAtIndex:2];
    example = [item objectAtIndex:3];
    exampletranslate = [item objectAtIndex:4];
    
    [cell setDisplayTitle:translate];
    [cell setDisplayDetail:title];
    [cell setDisplayExample:example];
    [cell setDisplayExampleTranslate:exampletranslate];
    [cell setCategoryID:[catID integerValue]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped accessory button");
}

#pragma mark - Popup View
-(TLPageViewController*)viewControllerAtIndex:(NSInteger)index
{
    TLPageViewController *pageviewcontroller = [[TLPageViewController alloc] initWithNibName:@"TLPageViewController" bundle:nil];
    [pageviewcontroller setDelegate:self];
    pageviewcontroller.index = index;
    
    NSArray *data  = [listSentence objectAtIndex:index];

    [pageviewcontroller setTitle:[data objectAtIndex:2]];
    [pageviewcontroller setSpell:[data objectAtIndex:1]];
    [pageviewcontroller setVidu:[data objectAtIndex:3]];
    
    [pageviewcontroller.view setFrame:[[self view] frame]];
    
    return pageviewcontroller;
}

-(void)nextpage{
    
}

-(void)closepage{
    
}

-(void)speak:(NSString*)audio{
    
}

#pragma mark - Setting Delegate
- (IBAction)settingAction:(id)sender {
    settingView = (TLSettingViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"idSetting"];
    
    [settingView setDelegate:self];
    [settingView.view setFrame:[[self view] frame]];
    
    [self addChildViewController:settingView];
    [[self view] addSubview:[settingView view]];
    
    settingView.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    settingView.view.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        settingView.view.alpha = 1;
        settingView.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

-(void)confirmSetting{
    NSLog(@"Confirm setting");
    
    [UIView animateWithDuration:0.2 animations:^{
        settingView.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        settingView.view.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [[settingView view] removeFromSuperview];
    }];
}

- (IBAction)selectPhrase:(id)sender{
    
    if (isShowSwipe) {
        [sender setTitle:@"Select"];
        isShowSwipe = NO;
        
        selectedArr = [_sentenceTable indexPathsForSelectedRows];
        
        if (selectedArr) {
            [self createNotification];
        }
        
        [_sentenceTable setEditing:NO animated:YES];
        [_sentenceTable setAllowsSelection:NO];
        [_sentenceTable setAllowsMultipleSelection:NO];
        [_sentenceTable setAllowsSelectionDuringEditing:NO];
        [_sentenceTable setAllowsMultipleSelectionDuringEditing:NO];
    }
    else{
        isShowSwipe = YES;
        [sender setTitle:@"Done"];
        
        [self showAlertGuideNotification];
        
        [_sentenceTable setEditing:YES animated:YES];
        [_sentenceTable setAllowsSelection:YES];
        [_sentenceTable setAllowsMultipleSelection:YES];
        [_sentenceTable setAllowsSelectionDuringEditing:YES];
        [_sentenceTable setAllowsMultipleSelectionDuringEditing:YES];
    }
    
    [_sentenceTable reloadData];
}

- (IBAction)addPhrase:(id)sender{
    TLAddViewController *addController = (TLAddViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"idAdd"];
    
    [self.navigationController pushViewController:addController animated:YES];
}

#pragma mark - Notification
-(void)createNotification{
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSDate *currentDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitHour  | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:currentDate];
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    
    NSInteger timePeriod = [self getNotificationTimePeriod];
    BOOL isEnableNotice = [[[NSUserDefaults standardUserDefaults] valueForKey:TL_ENABLE_NOTICE] boolValue];
    
    
    if (isEnableNotice) {
        NSInteger count = ((22 - hour)*60 - minute)/timePeriod;
        
        for (int i=0; i < count; i++) {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            
            NSInteger index = [selectedArr count];
            NSIndexPath *selectedindexpath = [selectedArr objectAtIndex:i%index];
            NSArray *item  = [listSentence  objectAtIndex:selectedindexpath.row];
            
            NSString *strBody = [item objectAtIndex:1];
            strBody = [strBody stringByAppendingString:[NSString stringWithFormat:@"(%@)",[item objectAtIndex:2]]];
            strBody = [strBody stringByAppendingString:@"\n"];
            strBody = [strBody stringByAppendingString:[item objectAtIndex:3]];
            strBody = [strBody stringByAppendingString:@"\n"];
            strBody = [strBody stringByAppendingString:[item objectAtIndex:4]];
            
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:i*timePeriod*60];
            notification.alertBody = strBody;
            notification.timeZone = [NSTimeZone localTimeZone];
            notification.applicationIconBadgeNumber = 1;
            notification.soundName = UILocalNotificationDefaultSoundName;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}

-(NSInteger)getNotificationTimePeriod{
    NSInteger timePeriod = [[[NSUserDefaults standardUserDefaults] valueForKey:TL_TIMEPERIOD_NOTICE] integerValue];
    
    switch (timePeriod) {
        case 0:
            return 5;
            break;
        case 1:
            return 10;
            break;
        case 2:
            return 15;
            break;
        case 3:
            return 30;
            break;
        case 4:
            return 60;
            break;
        default:
            return 5;
            break;
    }
    
    return 5;
}

-(void)showAlertGuideNotification{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:TL_SHOW_GUIDE]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"Select sentences to send notification for learning" delegate:self cancelButtonTitle:@"Don't show again" otherButtonTitles:@"Got it", nil];
        
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) { //got it
        
    }
    else if (buttonIndex == 0){ //dont show again
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:TL_SHOW_GUIDE];
    }
    
}

#pragma mark - Setting
-(void)runRateApp
{
    //1190545147
    [Appirater setAppId:@"1241590937"];    // Change for your "Your APP ID"
    [Appirater setDaysUntilPrompt:2];     // Days from first entered the app until prompt
    [Appirater setUsesUntilPrompt:12];     // Number of uses until prompt
    [Appirater setTimeBeforeReminding:2]; // Days until reminding if the user taps "remind me"
    //[Appirater setDebug:YES];           // If you set this to YES it will display all the time
    
    //... Perhaps do stuff
    
    [Appirater appLaunched:YES];
}

@end
