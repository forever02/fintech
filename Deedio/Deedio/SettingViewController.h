//
//  SettingViewController.h
//  Deedio
//
//  Created by dev on 6/1/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrentPW;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPW;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmNewPW;
@property (weak, nonatomic) IBOutlet UITextField *txtMobileNumber;

@property (weak, nonatomic) IBOutlet UIView *menuView;

@property bool isValid1;



//settingViewControllerIdentity
@end
