//
//  DonateViewController.m
//  Deedio
//
//  Created by dev on 6/1/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "DonateViewController.h"
#import "ConfirmPaymentViewController.h"
#import "PaymentInfoViewController.h"
#import "SettingViewController.h"
#import "SearchViewController.h"
#import "MyGlobalData.h"
#import "LoginViewController.h"
#import "TermsViewController.h"

@interface DonateViewController ()
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@end
bool isConfirmed;

@implementation DonateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LogOut) name:@"logout" object:nil];
    [MyGlobalData sharedData].payMode = 0;
    self.txtDonate.delegate = self;
    [self cardClicked:nil];
    isConfirmed = true;
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
//    numberToolbar.barStyle = UIStatusBarStyleLightContent;//UIBarStyleBlackTranslucent;
    [numberToolbar setTintColor:[UIColor grayColor]];
    numberToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    _txtDonate.inputAccessoryView = numberToolbar;
}

-(void)cancelNumberPad{
    [_txtDonate resignFirstResponder];
    _txtDonate.text = @"";
}

-(void)doneWithNumberPad{
//    NSString *numberFromTheKeyboard = _txtDonate.text;
    [_txtDonate resignFirstResponder];
    [self giveClicked:nil];
}
-(void)LogOut{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"loginidentity"];
    [self.navigationController pushViewController:controller animated:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    _strMosque = [MyGlobalData sharedData].donateObj;
    if(_strMosque == nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deedio"
                                                        message:NSLocalizedString(@"Please chose a institution.", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        //        [alert setTag:kCardExpirationErrorAlert];
        [alert show];
        [self searchMenuClicked:nil];
        return;
    }
    [self.txtMosque setText:_strMosque.donateName];
    UIColor *color = [UIColor colorWithRed:162 green:161 blue:184 alpha:0.5];
    if([self.txtDonate respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txtDonate.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"0.00" attributes:@{NSForegroundColorAttributeName: color}];
    }
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
//actions
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cardClicked:(id)sender {
//    UIColor *color1 = [UIColor colorWithRed:217 green:217 blue:217 alpha:1];
//    UIColor *color2 = [UIColor colorWithRed:255 green:78 blue:74 alpha:1];
//    [_bttBank setTintColor:color1];
    //    [_bttBank setTitleColor:[UIColor colorWithRed:217 green:217 blue:217 alpha:1] forState:UIControlStateNormal];
    [_bttBank setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bttCard setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_bttApple setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bttPaypal setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [MyGlobalData sharedData].payMode = 0;
    [_imgBank setImage:[UIImage imageNamed:@"unconfirm.png"]];
    [_imgCard setImage:[UIImage imageNamed:@"confirm.png"]];
    [_imgApple setImage:[UIImage imageNamed:@"unconfirm.png"]];
    [_imgPaypal setImage:[UIImage imageNamed:@"unconfirm.png"]];
}

- (IBAction)bankClicked:(id)sender {
    [_bttCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bttBank setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_bttApple setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bttPaypal setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [MyGlobalData sharedData].payMode = 1;
    [_imgBank setImage:[UIImage imageNamed:@"confirm.png"]];
    [_imgCard setImage:[UIImage imageNamed:@"unconfirm.png"]];
    [_imgApple setImage:[UIImage imageNamed:@"unconfirm.png"]];
    [_imgPaypal setImage:[UIImage imageNamed:@"unconfirm.png"]];
}

- (IBAction)appleClicked:(id)sender {
    [_bttCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bttBank setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bttApple setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_bttPaypal setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [MyGlobalData sharedData].payMode = 2;
    [_imgBank setImage:[UIImage imageNamed:@"unconfirm.png"]];
    [_imgCard setImage:[UIImage imageNamed:@"unconfirm.png"]];
    [_imgApple setImage:[UIImage imageNamed:@"confirm.png"]];
    [_imgPaypal setImage:[UIImage imageNamed:@"unconfirm.png"]];
}
- (IBAction)paypalClicked:(id)sender {
    [_bttCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bttBank setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bttApple setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bttPaypal setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [MyGlobalData sharedData].payMode = 3;
    [_imgBank setImage:[UIImage imageNamed:@"unconfirm.png"]];
    [_imgCard setImage:[UIImage imageNamed:@"unconfirm.png"]];
    [_imgApple setImage:[UIImage imageNamed:@"unconfirm.png"]];
    [_imgPaypal setImage:[UIImage imageNamed:@"confirm.png"]];
}
//textField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    float delta = 0;
    if(textField.frame.origin.y+50 > self.view.frame.size.height/2){
        delta = textField.frame.origin.y+50 - self.view.frame.size.height/2;
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
    [self.txtDonate resignFirstResponder];
}
/*
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}
-(void)keyboardWillShow:(NSNotification *)note{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    [items addObject:[[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(doneButton:)]];
//    [toolbar setItems:items];
}
-(void)keyboardWillShow1:(NSNotification *)note{
    // create custom button
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 163, 106, 53);
    doneButton.adjustsImageWhenHighlighted = NO;
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
//    [doneButton setImage:[UIImage imageNamed:@"doneButtonNormal.png"] forState:UIControlStateNormal];
//    [doneButton setImage:[UIImage imageNamed:@"doneButtonPressed.png"] forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *keyboardView = [[[[[UIApplication sharedApplication] windows] lastObject] subviews] firstObject];
            [doneButton setFrame:CGRectMake(self.view.frame.size.width - 106, self.view.frame.size.height - keyboardView.frame.size.height - 53, 106, 53)];
//            [doneButton setFrame:CGRectMake(0, keyboardView.frame.size.height - 53, 106, 53)];
//            [keyboardView addSubview:doneButton];
            [self.view addSubview:doneButton];
//            [keyboardView bringSubviewToFront:doneButton];
            
            [UIView animateWithDuration:[[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]-.02
                                  delay:.0
                                options:[[note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]
                             animations:^{
//                                 self.view.frame = CGRectOffset(self.view.frame, 0, 0);
                             } completion:nil];
        });
    }else {
        // locate keyboard view
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
            UIView* keyboard;
            for(int i=0; i<[tempWindow.subviews count]; i++) {
                keyboard = [tempWindow.subviews objectAtIndex:i];
                // keyboard view found; add the custom button to it
                if([[keyboard description] hasPrefix:@"UIKeyboard"] == YES)
                    [keyboard addSubview:doneButton];
            }
        });
    }
}

-(IBAction)doneButton:(id)sender
{
    [self.txtDonate resignFirstResponder];
}
*/
- (IBAction)confirmClicked:(id)sender {
    isConfirmed = !isConfirmed;
    if(isConfirmed){
        [_imgConfirm setImage:[UIImage imageNamed:@"confirm.png"]];
        [_bttGive setEnabled:YES];
    }else{
        [_imgConfirm setImage:[UIImage imageNamed:@"unconfirm.png"]];
        [_bttGive setEnabled:YES];
    }
}

- (IBAction)giveClicked:(id)sender {
    [self.txtDonate resignFirstResponder];
    if([MyGlobalData sharedData].payMode == 0 && [[MyGlobalData sharedData].carnNumber isEqualToString:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"Please insert Card information!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PaymentInfoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PaymentViewControllerIdentity"];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    if([MyGlobalData sharedData].payMode == 1 && [[MyGlobalData sharedData].carnNumber isEqualToString:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"Please insert Bank information!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PaymentInfoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PaymentViewControllerIdentity"];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    if([self checkDonate]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ConfirmPaymentViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"confirmPaymentViewControllerIdentity"];
        float val = [_txtDonate.text floatValue];
        if(!isConfirmed){
            controller.giveValue = [NSString stringWithFormat:@"%.2f", val];
        }else{
            val = val * 1.0489;
            controller.giveValue = [NSString stringWithFormat:@"%.2f", val];
            
        }
        [self.navigationController pushViewController:controller animated:YES];
    }
}
-(BOOL)checkDonate
{
    NSString *Regex = @"^[0-9\\.]{1,1000}$";
    NSPredicate *donateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    if([donateTest evaluateWithObject:_txtDonate.text]){
        float val = [_txtDonate.text floatValue];
        if(val > 0)
            return YES;
        else{            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"Please insert a valid donation amount" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"Please insert valid donation amount" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
}
- (IBAction)backgroundClicked:(id)sender {
    [self.txtDonate resignFirstResponder];
    [[MyGlobalData sharedData] resetTimer];
}
//MenuAction
- (IBAction)menuClicked:(id)sender {
    [UIView beginAnimations:@"slideLeft" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:(id)self];
    
    [self.menuView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [UIView commitAnimations];
}
- (IBAction)leftgroundClicked:(id)sender {
    [UIView beginAnimations:@"slideRight" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:(id)self];
    
    [self.menuView setCenter:CGPointMake(self.view.frame.size.width*3/2, self.view.frame.size.height/2)];
    [UIView commitAnimations];
    
}
- (IBAction)rightgroundClicked:(id)sender {
}
- (IBAction)searchMenuClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"searchViewControllerIdentity"];
    [self.navigationController pushViewController:controller animated:YES];
    [self leftgroundClicked:nil];
}
- (IBAction)donateMenuClicked:(id)sender {
    [self leftgroundClicked:nil];
}
- (IBAction)accountsMenuClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PaymentInfoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PaymentViewControllerIdentity"];
    controller.initLogin = NO;
    [self.navigationController pushViewController:controller animated:YES];
    [self leftgroundClicked:nil];
}
- (IBAction)profileMenuClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"settingViewControllerIdentity"];
    [self.navigationController pushViewController:controller animated:YES];
    [self leftgroundClicked:nil];
}
- (IBAction)logoutClicked:(id)sender {
    [self LogOut];
}

- (IBAction)termsClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TermsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"termsidentity"];
    controller.index = 0;
    [self.navigationController pushViewController:controller animated:YES];
    [self leftgroundClicked:nil];
}
- (IBAction)policyClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TermsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"termsidentity"];
    controller.index = 1;
    [self.navigationController pushViewController:controller animated:YES];
    [self leftgroundClicked:nil];
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
