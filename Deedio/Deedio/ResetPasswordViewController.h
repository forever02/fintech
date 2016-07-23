//
//  ResetPasswordViewController.h
//  Deedio
//
//  Created by dev on 6/30/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
//resetpasswordIdentity
@interface ResetPasswordViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userEmail;

@property (weak, nonatomic) IBOutlet UITextField *txtNewPW;

@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPW;

@property (weak, nonatomic) NSString *sEmail;

@end
