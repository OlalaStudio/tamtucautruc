//
//  TLAddViewController.m
//  84 Common Sentence
//
//  Created by NguyenThanhLuan on 02/06/2017.
//  Copyright © 2017 Olala. All rights reserved.
//

#import "TLAddViewController.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@interface TLAddViewController ()

@end

@implementation TLAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                              style:UIBarButtonItemStylePlain
                                                                                                  target:self
                                                                                                  action:@selector(AddDone:)];
    
    [_txtSentence setDelegate:self];
    [_txtTranslate setDelegate:self];
    [_txtExample setDelegate:self];
    [_txtHint setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_txtSentence resignFirstResponder];
    [_txtHint resignFirstResponder];
    [_txtExample resignFirstResponder];
    [_txtTranslate resignFirstResponder];
    return YES;
}

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender frame].origin.y < kOFFSET_FOR_KEYBOARD)
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)AddDone:(id)sender
{
    if (![[_txtSentence text] isEqualToString:@""] && ![[_txtHint text] isEqualToString:@""]) {
        //insert into cautruc(cautruccau,giaithich,example,example_translate) values('ving+n','dang lam gi do','im doing','toi dang lam')
        [self insertDatabase];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)insertDatabase{
    
    TDatabaseManager *dbManager = [TDatabaseManager sharedInstance];
    
    if([dbManager open:@"84cautruc_data.db"]){
        
        NSString *query = [NSString stringWithFormat:@"insert into cautruc(cautruccau,giaithich,example,example_translate) values('%@','%@','%@','%@')",[_txtSentence text],[_txtHint text],[_txtExample text],[_txtTranslate text]];
        
        // insert database
        [dbManager executeQuery:query];
        
        [dbManager close];
    }
}

@end
