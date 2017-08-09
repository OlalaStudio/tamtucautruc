//
//  TLAddViewController.h
//  84 Common Sentence
//
//  Created by NguyenThanhLuan on 02/06/2017.
//  Copyright © 2017 Olala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDatabaseManager.h"

@interface TLAddViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtSentence;
@property (weak, nonatomic) IBOutlet UITextField *txtHint;
@property (weak, nonatomic) IBOutlet UITextField *txtExample;
@property (weak, nonatomic) IBOutlet UITextField *txtTranslate;

@end
