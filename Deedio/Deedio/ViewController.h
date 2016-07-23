//
//  ViewController.h
//  Deedio
//
//  Created by dev on 5/31/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNumber;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property bool isValid;
@end

