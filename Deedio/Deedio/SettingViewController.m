//
//  SettingViewController.m
//  Deedio
//
//  Created by dev on 6/1/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "SettingViewController.h"
#import "SearchViewController.h"
#import "DonateViewController.h"
#import "PaymentInfoViewController.h"
#import "MyGlobalData.h"
#import "HttpApi.h"
#import "LoginViewController.h"
#import "TermsViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
    [self.txtFirstName setDelegate:self];
    [self.txtLastName setDelegate:self];
    [self.txtEmail setDelegate:self];
    [self.txtCurrentPW setDelegate:self];
    [self.txtNewPW setDelegate:self];
    [self.txtConfirmNewPW setDelegate:self];
    [self.txtMobileNumber setDelegate:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LogOut) name:@"logout" object:nil];
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

-(void)LogOut{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"loginidentity"];
    [self.navigationController pushViewController:controller animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)initViews{
    
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
    
    if([self.txtCurrentPW respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txtCurrentPW.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Current Password" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.txtNewPW respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txtNewPW.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.txtConfirmNewPW respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txtConfirmNewPW.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm New Password" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.txtMobileNumber respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txtMobileNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Mobile Number" attributes:@{NSForegroundColorAttributeName: color}];
    }

    [_txtFirstName setText:[MyGlobalData sharedData].userFirstName];
    [_txtLastName setText:[MyGlobalData sharedData].userLastName];
    [_txtEmail setText:[MyGlobalData sharedData].userEmail];
    [_txtMobileNumber setText:[MyGlobalData sharedData].userPhone];
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
    [UIView beginAnimations: @"moveDown" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3f];
    [self.view setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [UIView commitAnimations];
    return YES;
}
-(void) resignKeyboard
{
    [UIView beginAnimations: @"moveDown" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3f];
    [self.view setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [UIView commitAnimations];
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtCurrentPW resignFirstResponder];
    [self.txtNewPW resignFirstResponder];
    [self.txtConfirmNewPW resignFirstResponder];
    [self.txtMobileNumber resignFirstResponder];
}



//actions
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)menuClicked:(id)sender {
    [UIView beginAnimations:@"slideLeft" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:(id)self];
    
    [self.menuView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [UIView commitAnimations];

}

- (IBAction)updateClicked:(id)sender {
    [self resignKeyboard];
    _isValid1 = NO;
    [self checkAllValue];
    if(_isValid1){
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        [self.view addSubview:spinner];
        [spinner startAnimating];
        NSString *userName = [NSString stringWithFormat:@"%@%@", self.txtFirstName.text, self.txtLastName.text];
//        NSString *oldpw = [[MyGlobalData sharedData] md5:_txtCurrentPW.text];
//        NSString *newpw = [[MyGlobalData sharedData] md5:_txtNewPW.text];
        [[HttpApi sharedInstance] UpdateWithFirstName:self.txtFirstName.text LastName:self.txtLastName.text UserName:userName Email:self.txtEmail.text Mobile:self.txtMobileNumber.text OldPasswork:_txtCurrentPW.text NewPassword:_txtNewPW.text Complete:^(NSString *responseObject){
            NSDictionary *dicResponse = (NSDictionary *)responseObject;
            NSString *status = [dicResponse objectForKey:@"msg"];
            if([status isEqualToString:@"Success"]){
                NSString *userid = [dicResponse objectForKey:@"user_id"];
                [[MyGlobalData sharedData] setUserFirstName:_txtFirstName.text UserLastName:_txtLastName.text UserPassword:_txtNewPW.text UserEmail:_txtEmail.text UserPhoneNumber:_txtMobileNumber.text UserID:userid];
                NSString *hash = [dicResponse objectForKey:@"hash"];
                [[MyGlobalData sharedData] setDeviceToken:hash];
                [spinner stopAnimating];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"Update Success!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                SearchViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"searchViewControllerIdentity"];
//                [self.navigationController pushViewController:controller animated:YES];
                
//                [self leftmenuClicked:nil];
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

- (IBAction)leftmenuClicked:(id)sender {
    [UIView beginAnimations:@"slideRight" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:(id)self];
    
    [self.menuView setCenter:CGPointMake(self.view.frame.size.width*3/2, self.view.frame.size.height/2)];
    [UIView commitAnimations];

}
- (IBAction)rightmenuClicked:(id)sender {
}
- (IBAction)searchmenuClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"searchViewControllerIdentity"];
    [self.navigationController pushViewController:controller animated:YES];
    [self leftmenuClicked:nil];
}
- (IBAction)donatemenuClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DonateViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"donateViewControllerIdentity"];
    [self.navigationController pushViewController:controller animated:YES];
    [self leftmenuClicked:nil];
}
- (IBAction)accountmenuClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PaymentInfoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PaymentViewControllerIdentity"];
    controller.initLogin = NO;
    [self.navigationController pushViewController:controller animated:YES];
    [self leftmenuClicked:nil];
}
- (IBAction)profilemenuClicked:(id)sender {
    [self leftmenuClicked:nil];
}

- (IBAction)logoutClicked:(id)sender {
    [self LogOut];
}


- (IBAction)termsClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TermsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"termsidentity"];
    controller.index = 0;
    [self.navigationController pushViewController:controller animated:YES];
    [self leftmenuClicked:nil];
}
- (IBAction)policyClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TermsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"termsidentity"];
    controller.index = 1;
    [self.navigationController pushViewController:controller animated:YES];
    [self leftmenuClicked:nil];
}

- (IBAction)backgroundClicked:(id)sender {
    [self resignKeyboard];
    [[MyGlobalData sharedData] resetTimer];
}


-(void)checkAllValue{
    if(![_txtNewPW.text isEqualToString:_txtConfirmNewPW.text]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"Password is not match!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
//    if(![self NSStringIsValidEmail:_txtEmail.text]){
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"Email format is invalid!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [_txtEmail becomeFirstResponder];
//        [alert show];
//        return;
//    }
    if(![self validatePhone1:_txtMobileNumber.text]){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"Mobile Number format is invalid!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [_txtMobileNumber becomeFirstResponder];
        [alert show];
        return;
    }
    _isValid1 = YES;
}

- (BOOL)validatePhone1:(NSString *)phoneNumber
{
    //    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSString *phoneRegex = @"^[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
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
