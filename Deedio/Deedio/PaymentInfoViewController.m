//
//  PaymentInfoViewController.m
//  Deedio
//
//  Created by dev on 6/1/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "PaymentInfoViewController.h"
#import "SearchViewController.h"
#import "SettingViewController.h"
#import "DonateViewController.h"
#import "MyGlobalData.h"
#import "LoginViewController.h"
#import "CreditCardType.h"
#import "TermsViewController.h"


@interface PaymentInfoViewController ()

#define FLOAT_COLOR_VALUE(n) (n)/255.0

#define kCreditCardLength 16
#define kCreditCardLengthPlusSpaces (kCreditCardLength + 3)
#define kExpirationLength 4
#define kExpirationLengthPlusSlash  kExpirationLength + 1
#define kCVV2Length 4
#define kZipLength 5
#define kCVVMaskLength (kCVV2Length -2)

#define kCreditCardObscureLength (kCreditCardLength - 4)

#define kSpace @" "
#define kSlash @"/"

#define kCardNumberErrorAlert 1001
#define kCardExpirationErrorAlert 1002

#define INFORMATION_MESSAGE @"The application utilizes the Authorize.Net SDK avaliable on GitHub under the username AuthorizeNet. Authorize.Net is a wholly owned subsidiary of Visa."
#define PAYMENT_SUCCESSFUL @"Your transaction of $0.01 has been processed successfully."


@end

@implementation PaymentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews1];
    [self.txt1 setDelegate:self];
    [self.txt2 setDelegate:self];
    [self.txt3 setDelegate:self];
    [self.txt4 setDelegate:self];
//    self.creditCardBuf = @"";
//    self.expirationBuf = @"";
//    self.cvvBuf = @"";
//    self.zipBuf = @"";
    if(_initLogin){
        [_bttback setHidden:YES];
    }else{
        [_bttback setHidden:NO];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LogOut) name:@"logout" object:nil];
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    //    numberToolbar.barStyle = UIStatusBarStyleLightContent;//UIBarStyleBlackTranslucent;
    [numberToolbar setTintColor:[UIColor grayColor]];
    numberToolbar.items = @[
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    _txt1.inputAccessoryView = numberToolbar;
    _txt2.inputAccessoryView = numberToolbar;
    _txt3.inputAccessoryView = numberToolbar;
    _txt4.inputAccessoryView = numberToolbar;
}

-(void)cancelNumberPad{
    [_txt1 resignFirstResponder];
    _txt1.text = @"";
    [_txt2 resignFirstResponder];
    _txt2.text = @"";
    [_txt3 resignFirstResponder];
    _txt3.text = @"";
    [_txt4 resignFirstResponder];
    _txt4.text = @"";
}

-(void)doneWithNumberPad{
    
    [_txt1 resignFirstResponder];
    [_txt2 resignFirstResponder];
    [_txt3 resignFirstResponder];
    [_txt4 resignFirstResponder];
}

-(void)LogOut{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"loginidentity"];
    [self.navigationController pushViewController:controller animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initViews1{
        self.creditCardBuf = @"";
        self.expirationBuf = @"";
        self.cvvBuf = @"";
        self.zipBuf = @"";
    _cardselected = 1;
    [_bttBank setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bttCard setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIColor *color = [UIColor colorWithRed:162 green:161 blue:184 alpha:0.5];
    if([self.txt1 respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txt1.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Card Number" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.txt2 respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txt2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Expiration Date" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.txt3 respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txt3.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"CVV" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.txt4 respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txt4.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Zip Code" attributes:@{NSForegroundColorAttributeName: color}];
    }
    if([MyGlobalData sharedData].carnNumber != nil && [MyGlobalData sharedData].carnNumber.length > 0){
        self.creditCardBuf = [MyGlobalData sharedData].carnNumber;
        [self formatValue:self.txt1];
//        [self.txt1 setText:[MyGlobalData sharedData].carnNumber];
    }else{
        [self.txt1 setText:@""];
    }
    if([MyGlobalData sharedData].expirationDate != nil && [MyGlobalData sharedData].expirationDate.length > 0){
        self.expirationBuf = [MyGlobalData sharedData].expirationDate;
        [self formatValue:self.txt2];
//        [self.txt2 setText:[MyGlobalData sharedData].expirationDate];
    }else{
        [self.txt2 setText:@""];
    }
    if([MyGlobalData sharedData].cvv != nil && [MyGlobalData sharedData].cvv.length > 0){
        self.cvvBuf = [MyGlobalData sharedData].cvv;
        [self formatValue:self.txt3];
    }else{
        [self.txt3 setText:@""];
    }
    if([MyGlobalData sharedData].zipCode != nil && [MyGlobalData sharedData].zipCode.length > 0){
        self.zipBuf = [MyGlobalData sharedData].zipCode;
        [self.txt4 setText:self.zipBuf];
    }else{
        [self.txt4 setText:@""];
    }
    [self.txt3 setKeyboardType:UIKeyboardTypeNumberPad];
    [self.txt4 setKeyboardType:UIKeyboardTypeNumberPad];
}

-(void)initViews2{
    _cardselected = 2;
    [_bttCard setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bttBank setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIColor *color = [UIColor colorWithRed:162 green:161 blue:184 alpha:0.5];
    if([self.txt1 respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txt1.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Routing Number" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.txt2 respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txt2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Account Number" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.txt3 respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txt3.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Account Type" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.txt4 respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txt4.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Account Nickname" attributes:@{NSForegroundColorAttributeName: color}];
    }
    [self.txt3 setKeyboardType:UIKeyboardTypeDefault];
    [self.txt4 setKeyboardType:UIKeyboardTypeDefault];
    if([MyGlobalData sharedData].routingNumber != nil && [MyGlobalData sharedData].routingNumber.length > 0){
        [self.txt1 setText:[MyGlobalData sharedData].routingNumber];
    }else{
        [self.txt1 setText:@""];
    }
    if([MyGlobalData sharedData].accountNumber != nil && [MyGlobalData sharedData].accountNumber.length > 0){
        [self.txt2 setText:[MyGlobalData sharedData].accountNumber];
    }else{
        [self.txt2 setText:@""];
    }
    if([MyGlobalData sharedData].accountType != nil && [MyGlobalData sharedData].accountType.length > 0){
        [self.txt3 setText:[MyGlobalData sharedData].accountType];
    }else{
        [self.txt3 setText:@""];
    }
    if([MyGlobalData sharedData].accountNickname != nil && [MyGlobalData sharedData].accountNickname.length > 0){
        [self.txt4 setText:[MyGlobalData sharedData].accountNickname];
    }else{
        [self.txt4 setText:@""];
    }
}
- (IBAction)backgroundClicekd:(id)sender {
    [self resignKeyboard];
    [[MyGlobalData sharedData] resetTimer];
}

//textField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    float delta = 0;
    if(textField.frame.origin.y + _txtfieldView.frame.origin.y + 50> self.view.frame.size.height/2){
        delta = textField.frame.origin.y + _txtfieldView.frame.origin.y + 50 - self.view.frame.size.height/2;
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
    [self.txt1 resignFirstResponder];
    [self.txt2 resignFirstResponder];
    [self.txt3 resignFirstResponder];
    [self.txt4 resignFirstResponder];
    if(self.txt1.text.length > 0 && self.txt2.text.length > 0 && self.txt3.text.length > 0 && self.txt4.text.length > 0){
        if(_cardselected == 1){
//            [[MyGlobalData sharedData] setCardWithNumber:_txt1.text expireDate:_txt2.text cvv:_txt3.text zip:_txt4.text];
        }else{
            [[MyGlobalData sharedData] setBankWithNumber:_txt1.text account:_txt2.text type:_txt3.text nickname:_txt4.text];
        }
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //credit card number
    if(_cardselected == 1){
        if (textField == self.txt1) {
            if ([string length] > 0) { //NOT A BACK SPACE Add it
                
                if ([self isMaxLength:textField])
                    return NO;
                
                self.creditCardBuf  = [NSString stringWithFormat:@"%@%@", self.creditCardBuf, string];
            } else {
                
                //Back Space do manual backspace
                if ([self.creditCardBuf length] > 1) {
                    self.creditCardBuf = [self.creditCardBuf substringWithRange:NSMakeRange(0, [self.creditCardBuf length] - 1)];
                } else {
                    self.creditCardBuf = @"";
                }
            }
            [self formatValue:textField];
            [self validateCreditCardValue];
        } else if (textField == self.txt2) {//expire date
            if ([string length] > 0) { //NOT A BACK SPACE Add it
                
                if ([self isMaxLength:textField])
                    return NO;
                
                self.expirationBuf  = [NSString stringWithFormat:@"%@%@", self.expirationBuf, string];
            } else {
                
                //Back Space do manual backspace
                if ([self.expirationBuf length] > 1) {
                    self.expirationBuf = [self.expirationBuf substringWithRange:NSMakeRange(0, [self.expirationBuf length] - 1)];
                    [self formatValue:textField];
                } else {
                    self.expirationBuf = @"";
                }
            }
            
            [self formatValue:textField];
            
        } else if (textField == self.txt3) {//cvv textfield
            if ([string length] > 0) {
                
                if ([self isMaxLength:textField])
                    return NO;
                self.cvvBuf = [NSString stringWithFormat:@"%@%@", self.cvvBuf, string];
            }else {
                
                //Back Space do manual backspace
                if ([self.txt3.text length] > 1) {
                    self.cvvBuf = [self.txt3.text substringWithRange:NSMakeRange(0, [self.txt3.text length] - 1)];
                } else {
                    self.cvvBuf = @"";
                }
            }
            [self formatValue:textField];
//            self.txt3.text = self.cvvBuf;
        } else if (textField == self.txt4) {//zip textfield
            if ([string length] > 0) {
                
                if ([self isMaxLength:textField])
                    return NO;
                
                self.zipBuf = [NSString stringWithFormat:@"%@%@", self.txt4.text, string];
            }else {
                
                //Back Space do manual backspace
                if ([self.txt4.text length] > 1) {
                    self.zipBuf = [self.txt4.text substringWithRange:NSMakeRange(0, [self.txt4.text length] - 1)];
                } else {
                    self.zipBuf = @"";
                }
            }
            self.txt4.text = self.zipBuf;
        }
    }else{
        if([string length] > 0){
            textField.text = [NSString stringWithFormat:@"%@%@", textField.text, string];
        }else{
            if([textField.text length] > 1){
                textField.text = [textField.text substringWithRange:NSMakeRange(0, [textField.text length] - 1)];
            }else{
                textField.text = @"";
            }
        }
    }
    return NO;
}

- (void) formatValue:(UITextField *)textField {
    NSMutableString *value = [NSMutableString string];
    
    if (textField == self.txt1 ) {
        NSInteger length = [self.creditCardBuf length];
        
        for (int i = 0; i < length; i++) {
            
            // Reveal only the last character.
            if (length <= kCreditCardObscureLength) {
                
                if (i == (length - 1)) {
                    [value appendString:[self.creditCardBuf substringWithRange:NSMakeRange(i,1)]];
                } else {
                    [value appendString:@"●"];
                }
            }
            // Reveal the last 4 characters
            else {
                
                if (i < kCreditCardObscureLength) {
                    [value appendString:@"●"];
                } else {
                    [value appendString:[self.creditCardBuf substringWithRange:NSMakeRange(i,1)]];
                }
            }
            
            //After 4 characters add a space
            if ((i +1) % 4 == 0 &&
                ([value length] < kCreditCardLengthPlusSpaces)) {
                [value appendString:kSpace];
            }
        }
        textField.text = value;
    }
    if (textField == self.txt2) {
        for (int i = 0; i < [self.expirationBuf length]; i++) {
            [value appendString:[self.expirationBuf substringWithRange:NSMakeRange(i,1)]];
            
            // After two characters append a slash.
            if ((i + 1) % 2 == 0 &&
                ([value length] < kExpirationLengthPlusSlash)) {
                [value appendString:kSlash];
            }
        }
        textField.text = value;
    }
    if (textField == self.txt3) {
        NSInteger length = [self.cvvBuf length];
        for(int i = 0; i < length; i++) {
            if ( length <= kCVVMaskLength) {
                if (i == (length - 1)) {
                    [value appendString:[self.cvvBuf substringWithRange:NSMakeRange(i,1)]];
                }else{
                    [value appendString:@"●"];
                }
            }
            else{
                if (i < kCVVMaskLength) {
                    [value appendString:@"●"];
                } else {
                    [value appendString:[self.cvvBuf substringWithRange:NSMakeRange(i,1)]];
                }
            }
        }
        textField.text = value;
    }
}


- (void) validateCreditCardValue {
    NSString *ccNum = self.creditCardBuf;
    
    // Use the Authorize.Net SDK to validate credit card number
    if (![CreditCardType isValidCreditCardNumber:ccNum]) {
        self.txt1.textColor = [UIColor redColor];
    } else {
        self.txt1.textColor = [UIColor colorWithRed:FLOAT_COLOR_VALUE(98) green:FLOAT_COLOR_VALUE(169) blue:FLOAT_COLOR_VALUE(40) alpha:1];
    }
}
- (BOOL) isMaxLength:(UITextField *)textField {
    
    if (textField == self.txt1 && [textField.text length] >= kCreditCardLengthPlusSpaces) {
        return YES;
    }
    else if (textField == self.txt2 && [textField.text length] >= kExpirationLengthPlusSlash) {
        return YES;
    }
    else if (textField == self.txt3 && [textField.text length] >= kCVV2Length) {
        return YES;
    }
    else if (textField == self.txt4 && [textField.text length] >= kZipLength) {
        return YES;
    }
    return NO;
}

-(BOOL)checkCardInfo{
    
    if (![self.creditCardBuf length]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"A card number is required to continue.", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert setTag:kCardNumberErrorAlert];
        [alert show];
        
        return false;
    }
    
    
    if (![CreditCardType isValidCreditCardNumber:self.creditCardBuf]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Please enter a valid card number.", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert setTag:kCardNumberErrorAlert];
        [alert show];
        
        return false;
    }
    
    if (![self.txt2.text length]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"An expiration date is required to continue.", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert setTag:kCardExpirationErrorAlert];
        [alert show];
        
        return false;
    }
    
    if ([self.expirationBuf length] != EXPIRATION_DATE_LENGTH) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Please enter a valid expiration date.", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert setTag:kCardExpirationErrorAlert];
        [alert show];
        
        return false;
    } else {
        // Validate
        NSArray *components = [[self.txt2 text] componentsSeparatedByString:@"/"];
        NSString *month = [components objectAtIndex:0];
        NSString *year = [components objectAtIndex:1];
        
        // Check to see if month is correct
        if ([month intValue] == 0 || [month intValue] > 12) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:NSLocalizedString(@"Please enter a valid expiration date.", @"")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                  otherButtonTitles:nil];
            [alert setTag:kCardExpirationErrorAlert];
            [alert show];
            
            return false;
        }
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDate *currentDate = [NSDate date];
        
        // Convert date object to desired output format
        [dateFormat setDateFormat:@"M/yyyy"];
        NSString *currentDateString = [dateFormat stringFromDate:currentDate];
        components = [currentDateString componentsSeparatedByString:@"/"];
        NSString *currentMonth = [components objectAtIndex:0];
        NSString *currentYear = [[components objectAtIndex:1] substringFromIndex:2];
        
        
        
        // Check if we are correct
        if ([year intValue] == [currentYear intValue]) {
            if ([month intValue] < [currentMonth intValue]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:NSLocalizedString(@"Please enter a valid expiration date.", @"")
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                      otherButtonTitles:nil];
                [alert setTag:kCardExpirationErrorAlert];
                [alert show];
                
                return false;
            }
        } else if ([year intValue] < [currentYear intValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:NSLocalizedString(@"Please enter a valid expiration date.", @"")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                  otherButtonTitles:nil];
            [alert setTag:kCardExpirationErrorAlert];
            [alert show];
            
            return false;
        }
    }
    if([_txt3.text length] != kCVV2Length){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Please enter a valid CVV number.", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
//        [alert setTag:kCardExpirationErrorAlert];
        [alert show];
        
        return false;
    }
    
    if([_txt4.text length] != kZipLength){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Please enter a valid ZIP number.", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
//        [alert setTag:kCardExpirationErrorAlert];
        [alert show];
        
        return false;
    }
    [self saveCardInfo];
    return true;
}
-(void)saveCardInfo{
    [[MyGlobalData sharedData] setCardWithNumber:self.creditCardBuf expireDate:self.expirationBuf cvv:self.cvvBuf zip:self.zipBuf];
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
- (IBAction)cardClicked:(id)sender {
    [self initViews1];
}

- (IBAction)bankClicked:(id)sender {
    [self initViews2];
}

- (IBAction)nextClicked:(id)sender {
    if(_cardselected == 1){
        if([self checkCardInfo]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SearchViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"searchViewControllerIdentity"];
            [self.navigationController pushViewController:controller animated:YES];
            [self leftmenuClicked:nil];
        }
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SearchViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"searchViewControllerIdentity"];
        [self.navigationController pushViewController:controller animated:YES];
        [self leftmenuClicked:nil];        
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
    [self leftmenuClicked:nil];
}

- (IBAction)profilemenuClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"settingViewControllerIdentity"];
    [self.navigationController pushViewController:controller animated:YES];
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

//PaymentViewControllerIdentity

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
