//
//  LoginViewController.m
//  Deedio
//
//  Created by dev on 6/1/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "LoginViewController.h"
#import "MyGlobalData.h"
#import "HttpApi.h"
#import "SearchViewController.h"
#import "ViewController.h"
#import "PaymentInfoViewController.h"
#import "AppDelegate.h"
#import "ResetPasswordViewController.h"

@interface LoginViewController (){
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController setNavigationBarHidden: YES animated:YES];
    _isRemember = YES;
    [self initViews];
    [self.txtUserName setDelegate:self];
    [self.txtPassword setDelegate:self];
}
-(void)initViews
{
    UIColor *color = [UIColor colorWithRed:162 green:161 blue:184 alpha:0.5];
    if([self.txtUserName respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txtUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.txtPassword respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([[MyGlobalData sharedData] getRemember] == 1){
        _isRemember = YES;
        [_imgConfirm setImage:[UIImage imageNamed:@"confirm.png"]];
        if(![[MyGlobalData sharedData].userName isEqualToString:@""]){
            [self.txtUserName setText:[MyGlobalData sharedData].userEmail];
        }
        if(![[MyGlobalData sharedData].userPassword isEqualToString:@""]){
//            [self.txtPassword setText:[MyGlobalData sharedData].userPassword];
        }
    }else{
        _isRemember = NO;
        [_imgConfirm setImage:[UIImage imageNamed:@"unconfirm.png"]];
    }
}
-(void)verify{
    if([MyGlobalData sharedData].verify){
        [MyGlobalData sharedData].verify = false;
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        [self.view addSubview:spinner];
        [spinner startAnimating];
        
        [[HttpApi sharedInstance] VerifyWithEmail:[MyGlobalData sharedData].userEmail
                                         Complete:^(NSString *responseObject){
//                                             NSDictionary *dicResponse = (NSDictionary *)responseObject;
//                                             NSString *status = [dicResponse objectForKey:@"msg"];
                                             [spinner stopAnimating];
                                         } Failed:^(NSString *strError) {
                                             [spinner stopAnimating];
                                         }];
        
    }

}
- (IBAction)goBack1:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backgroundClicked:(id)sender {
    [self resignKeyboard];
}
- (IBAction)signupclick:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"signupidentity"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)confirmClicked:(id)sender {
    _isRemember = !_isRemember;
    if(_isRemember){
        [_imgConfirm setImage:[UIImage imageNamed:@"confirm.png"]];
    }else{
        [_imgConfirm setImage:[UIImage imageNamed:@"unconfirm.png"]];
    }
}

- (IBAction)forgetpasswordClicked:(id)sender {
    if(![self NSStringIsValidEmail:_txtUserName.text]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"Email format is invalid!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_txtUserName becomeFirstResponder];
        [alert show];
        return;
    }
    [self sendNewPassword];
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

-(void)sendNewPassword{
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        [self.view addSubview:spinner];
        [spinner startAnimating];
        [[HttpApi sharedInstance] ForgetPasswordWithEmail:_txtUserName.text
                                                 Complete:^(NSString *responsObject){
                                                    [spinner stopAnimating];
                                                     NSDictionary *dicResponse = (NSDictionary *)responsObject;
                                                     NSString *status = [dicResponse objectForKey:@"msg"];
                                                     if([status isEqualToString:@"Success"]){
                                                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"Please check your email!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                         [alert show];
                                                     }else{
                                                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:status delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                         [alert show];
                                                     }
                                                 }Failed:^(NSString *strError){
                                                     [spinner stopAnimating];
                                                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"No network access. please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                     [alert show];
                                                 }];
}

//textField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    float delta = 0;
    if(textField.frame.origin.y > self.view.frame.size.height/2){
        delta = textField.frame.origin.y - self.view.frame.size.height/2;
        [UIView beginAnimations: @"moveUp" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.3f];
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
    [UIView setAnimationDuration: 0.3f];
    [self.view setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [UIView commitAnimations];
    [self.txtUserName resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}
- (IBAction)LoginClick:(id)sender {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:spinner];
    [spinner startAnimating];
//    NSString *pw = [[MyGlobalData sharedData] md5:_txtPassword.text];
    NSString *pw = _txtPassword.text;
    [[HttpApi sharedInstance] LoginWithUserName:_txtUserName.text Password:pw
                                       Complete:^(NSString *responseObject){
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        NSString *status = [dicResponse objectForKey:@"msg"];
        if([status isEqualToString:@"Success"]){
            NSString *hash = [dicResponse objectForKey:@"hash"];
            [[MyGlobalData sharedData] setDeviceToken:hash];
            NSString *userid = [dicResponse objectForKey:@"user_id"];
            NSString *firstname = [dicResponse objectForKey:@"firstname"];
            NSString *lastname = [dicResponse objectForKey:@"lastname"];
//            NSString *username = [dicResponse objectForKey:@"username"];
            NSString *email = [dicResponse objectForKey:@"email"];
            NSString *mobile = [dicResponse objectForKey:@"mobile"];
            if(_isRemember)
                [[MyGlobalData sharedData] setRememver:1];
            else
                [[MyGlobalData sharedData] setRememver:0];
                
            [[MyGlobalData sharedData] setUserFirstName:firstname UserLastName:lastname UserPassword:_txtPassword.text UserEmail:email UserPhoneNumber:mobile UserID:userid];
            [spinner stopAnimating];
            [[MyGlobalData sharedData] startTimer];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if([[MyGlobalData sharedData].carnNumber isEqualToString:@""] && [[MyGlobalData sharedData].accountNumber isEqualToString:@""]){
                PaymentInfoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PaymentViewControllerIdentity"];
                controller.initLogin = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                SearchViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"searchViewControllerIdentity"];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else{
            [spinner stopAnimating];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:status delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    } Failed:^(NSString *strError) {
        [spinner stopAnimating];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"No network access. please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];

    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
