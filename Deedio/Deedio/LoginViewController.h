//
//  LoginViewController.h
//  Deedio
//
//  Created by dev on 6/1/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imgConfirm;
@property bool isRemember;
-(void)verify;
@end
