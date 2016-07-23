//
//  ViewController.m
//  Deedio
//
//  Created by dev on 5/31/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "ViewController.h"
#import "HttpApi.h"
#import "SearchViewController.h"
#import "MyGlobalData.h"
#import "LoginViewController.h"
#import "TermsViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface ViewController ()

@end
const float movementDuration = 0.3f;
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.    
    [self.navigationController setNavigationBarHidden: YES animated:YES];
    [self initViews];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    //    numberToolbar.barStyle = UIStatusBarStyleLightContent;//UIBarStyleBlackTranslucent;
    [numberToolbar setTintColor:[UIColor grayColor]];
    numberToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    _txtMobileNumber.inputAccessoryView = numberToolbar;
}

-(void)cancelNumberPad{
    [_txtMobileNumber resignFirstResponder];
    _txtMobileNumber.text = @"";
}

-(void)doneWithNumberPad{
    //    NSString *numberFromTheKeyboard = _txtDonate.text;
    [_txtMobileNumber resignFirstResponder];
}

-(void)initViews
{
    [self.nextButton setEnabled:YES];
    [self.txtFirstName setDelegate:self];
    [self.txtLastName setDelegate:self];
    [self.txtEmail setDelegate:self];
    [self.txtPassword setDelegate:self];
    [self.txtConfirmPassword setDelegate:self];
    [self.txtMobileNumber setDelegate:self];
    UIColor *color = [UIColor colorWithRed:162 green:161 blue:184 alpha:0.5];
    if([self.txtFirstName respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txtFirstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.txtLastName respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txtLastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.txtEmail respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.txtPassword respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.txtConfirmPassword respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txtConfirmPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.txtMobileNumber respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txtMobileNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Mobile Number" attributes:@{NSForegroundColorAttributeName: color}];
    }
}

//textField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    float delta = 0;
    if(textField.frame.origin.y > self.view.frame.size.height/2){
        delta = textField.frame.origin.y - self.view.frame.size.height/2;
        [UIView beginAnimations: @"moveUp" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        [self.view setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - delta)];
        //    self.view.frame = CGRectOffset(self.inputView.frame, 0, movement);
        [UIView commitAnimations];
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self resignKeyboard];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self resignKeyboard];

    return YES;
}
-(void) resignKeyboard
{
    [UIView beginAnimations: @"moveDown" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    [self.view setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [UIView commitAnimations];
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtConfirmPassword resignFirstResponder];
    [self.txtMobileNumber resignFirstResponder];
}
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
- (BOOL)validatePhone:(NSString *)phoneNumber
{
//    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSString *phoneRegex = @"^[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}
-(BOOL)validatePassword:(NSString *)password
{
    NSString *phoneRegex = @"^[A-Za-z\\._%+-]*[0-9]+[A-Za-z\\._%+-]*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    if(![phoneTest evaluateWithObject:password]){
        return false;
    }
//    phoneRegex = @"^.+@([A-Za-z-]+\\.)+[A-Za-z]{1,100}$";
//    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
//    if(![phoneTest1 evaluateWithObject:password]){
//        return false;
//    }
    if(password.length < 7){
        return false;
    }
    return true;
}
- (IBAction)backgroundClicked:(id)sender {
    [self resignKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewTerms:(id)sender {//termsidentity
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TermsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"termsidentity"];
    controller.index = 0;
    [self.navigationController pushViewController:controller animated:YES];

}

- (IBAction)viewPolicy:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TermsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"termsidentity"];
    controller.index = 1;
    [self.navigationController pushViewController:controller animated:YES];

}


-(void)checkAllValues{
    if(![self validatePassword:_txtPassword.text]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"Password need to have 7 or more characters, containing letters and minimum one number!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(![_txtPassword.text isEqualToString:_txtConfirmPassword.text]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"Password is not match!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(![self NSStringIsValidEmail:_txtEmail.text]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"Email format is invalid!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_txtEmail becomeFirstResponder];
        [alert show];
        return;
    }
    if(![self validatePhone:_txtMobileNumber.text]){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"Mobile Number format is invalid!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_txtMobileNumber becomeFirstResponder];
        [alert show];
        return;
    }
    _isValid = YES;
}
- (IBAction)signClick:(id)sender {
    _isValid = NO;
    [self checkAllValues];
    if(_isValid){
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        [self.view addSubview:spinner];
        [spinner startAnimating];
        NSString *userName = [NSString stringWithFormat:@"%@%@", self.txtFirstName.text, self.txtLastName.text];
        NSString *pw = _txtPassword.text;
//        NSString *pw = [[MyGlobalData sharedData] md5:_txtPassword.text];
        [[HttpApi sharedInstance] SignUpWithFirstName:self.txtFirstName.text LastName:self.txtLastName.text UserName:userName Email:self.txtEmail.text Mobile:self.txtMobileNumber.text Passwork:pw Complete:^(NSString *responseObject){
            NSDictionary *dicResponse = (NSDictionary *)responseObject;
            NSString *status = [dicResponse objectForKey:@"msg"];
            if([status isEqualToString:@"Success"]){
                NSString *userid = [dicResponse objectForKey:@"user_id"];
                [[MyGlobalData sharedData] setUserFirstName:_txtFirstName.text UserLastName:_txtLastName.text UserPassword:_txtPassword.text UserEmail:_txtEmail.text UserPhoneNumber:_txtMobileNumber.text UserID:userid];
                NSString *hash = [dicResponse objectForKey:@"hash"];
                [[MyGlobalData sharedData] setDeviceToken:hash];
                [[MyGlobalData sharedData] initialize];
                [spinner stopAnimating];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"An email has been sent to your email address for verification and account activation." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"loginidentity"];
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                [spinner stopAnimating];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:status delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
        } Failed:^(NSString *strError) {
            [spinner stopAnimating];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"No network access please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
    
}
@end
