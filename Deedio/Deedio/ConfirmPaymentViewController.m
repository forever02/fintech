//
//  ConfirmPaymentViewController.m
//  Deedio
//
//  Created by dev on 6/1/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "ConfirmPaymentViewController.h"
#import "ThankyouViewController.h"
#import "PaymentInfoViewController.h"
#import "SettingViewController.h"
#import "DonateViewController.h"
#import "SearchViewController.h"
#import "MyGlobalData.h"
#import "HttpApi.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "NSString+HMAC_MD5.h"
#import "TermsViewController.h"

#define kCreditCardLength 16
#define kCreditCardLengthPlusSpaces (kCreditCardLength + 3)
#define kExpirationLength 4
#define kExpirationLengthPlusSlash  kExpirationLength + 1
#define kCVV2Length 4
#define kZipLength 5

#define kCreditCardObscureLength (kCreditCardLength - 4)

#define kSpace @" "
#define kSlash @"/"

#define kCardNumberErrorAlert 1001
#define kCardExpirationErrorAlert 1002

#define INFORMATION_MESSAGE @"The application utilizes the Authorize.Net SDK avaliable on GitHub under the username AuthorizeNet. Authorize.Net is a wholly owned subsidiary of Visa."
#define PAYMENT_SUCCESSFUL @"Your transaction of $0.01 has been processed successfully."

typedef enum AddressType {
    BILLIING,
    SHIPPING
} ADDRESSTYPE;
#define kPayPalEnvironment PayPalEnvironmentNoNetwork
@interface ConfirmPaymentViewController ()

@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@end
float donatePrice;
@implementation ConfirmPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPaypal];
//    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [AuthNet authNetWithEnvironment:ENV_TEST];
    UIDevice *device = [UIDevice currentDevice];
    _unique= [[device identifierForVendor] UUIDString];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LogOut) name:@"logout" object:nil];
    
    UIColor *color = [UIColor colorWithRed:162 green:161 blue:184 alpha:0.5];
    if([self.autho_username respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.autho_username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Autorize user name" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.autho_password respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.autho_password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: color}];
    }
}
-(void)LogOut{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"loginidentity"];
    [self.navigationController pushViewController:controller animated:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    _strMosque = [MyGlobalData sharedData].donateObj;
    [_txtDonationAmount setText:[NSString stringWithFormat:@"$%@", _giveValue]];
    [_txtOrganization setText:_strMosque.donateName];
    [self setPayPalEnvironment:self.environment];
    switch ([MyGlobalData sharedData].payMode) {
        case 0:
            _txtPaymentMethod.text = @"card";
            break;
        case 1:
            _txtPaymentMethod.text = @"bank";
            break;
        case 2:
            _txtPaymentMethod.text = @"Apple Pay";
            break;
        case 3:
            _txtPaymentMethod.text = @"Paypal";
            break;
        default:
            break;
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPayPalEnvironment:(NSString *)environment {
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//actions

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmClicked:(id)sender {
//    _activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
//    [self.view addSubview:_activityIndicator];
//    [_activityIndicator startAnimating];
    switch ([MyGlobalData sharedData].payMode) {
        case 0: //card
            donatePrice = [_giveValue floatValue];
            //            [self AuthorizeLoginFunction];
//            [self cardPaymentClicked];
            [self cardPaymentWithBackend];
            break;
        case 1: //bank
            donatePrice = [_giveValue floatValue];
            //            [self AuthorizeLoginFunction];
//            [self backPaymentClicked];
            [self bankPaymentWithBackend];
            break;
        case 2: //Apple Pay
            donatePrice = [_giveValue floatValue];
//            [self presentPaymentController];
            [self applepayPaymentWithBackend];
            break;
        case 3: //Paypal
            donatePrice = [_giveValue floatValue];
            [self payPaypal_clicked];
            break;
            
        default:
            break;
    }
}

-(void)cardPaymentWithBackend{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    NSString *strPrice = [NSString stringWithFormat:@"%.2f", donatePrice];
    
    [[HttpApi sharedInstance] PayWithCard:strPrice
                                 DonateID:[MyGlobalData sharedData].donateObj.donateId
                                 Complete:^(NSString *responseData){
                                     NSDictionary *dicResponse = (NSDictionary *)responseData;
                                     NSString *status = [dicResponse objectForKey:@"msg"];
                                     [spinner stopAnimating];
                                     if([status isEqualToString:@"Success"]){
                                         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                         ThankyouViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ThankyouViewControllerIdentity"];
                                         [self.navigationController pushViewController:controller animated:YES];
                                     }
                                     else{
                                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:status delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                         [alert show];
                                     }
                                     
                                 } Failed:^(NSString *strError){
                                     [spinner stopAnimating];
                                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"No network access. please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                     [alert show];
                                     
                                 }];
    
}
-(void)bankPaymentWithBackend{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    NSString *strPrice = [NSString stringWithFormat:@"%.2f", donatePrice];
    
    [[HttpApi sharedInstance] PayWithBank:strPrice
                                 DonateID:[MyGlobalData sharedData].donateObj.donateId
                                 Complete:^(NSString *responseData){
                                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                     ThankyouViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ThankyouViewControllerIdentity"];
                                     [self.navigationController pushViewController:controller animated:YES];
                                     [spinner stopAnimating];
                                     
                                 } Failed:^(NSString *strError){
                                     [spinner stopAnimating];
                                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"No network access. please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                     [alert show];
                                     
                                 }];

    
}
-(void)applepayPaymentWithBackend{
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    NSString *strPrice = [NSString stringWithFormat:@"%.2f", donatePrice];
    
    [[HttpApi sharedInstance] PayWithApplepay:strPrice
                                 DonateID:[MyGlobalData sharedData].donateObj.donateId
                                 Complete:^(NSString *responseData){
                                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                     ThankyouViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ThankyouViewControllerIdentity"];
                                     [self.navigationController pushViewController:controller animated:YES];
                                     [spinner stopAnimating];
                                     
                                 } Failed:^(NSString *strError){
                                     [spinner stopAnimating];
                                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"No network access. please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                     [alert show];
                                     
                                 }];
}

-(void)PayWithPaypal{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    NSString *strPrice = [NSString stringWithFormat:@"%.2f", donatePrice];
    
    [[HttpApi sharedInstance] PayWithPaypal:strPrice
                                   DonateID:[MyGlobalData sharedData].donateObj.donateId
                                                Complete:^(NSString *responseData){
                                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                    ThankyouViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ThankyouViewControllerIdentity"];
                                                    [self.navigationController pushViewController:controller animated:YES];
                                                    [spinner stopAnimating];
                                                    
                                                } Failed:^(NSString *strError){
                                                    [spinner stopAnimating];
                                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                    ThankyouViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ThankyouViewControllerIdentity"];
                                                    [self.navigationController pushViewController:controller animated:YES];
                                                    [spinner stopAnimating];
//                                                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"No network access. please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                                    [alert show];
                                                    
                                                }];
}
- (IBAction)menuClicked:(id)sender {
    [UIView beginAnimations:@"slideLeft" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:(id)self];
    
    [self.menuView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [UIView commitAnimations];
}
- (IBAction)leftMenuClicked:(id)sender {
    [UIView beginAnimations:@"slideRight" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:(id)self];
    
    [self.menuView setCenter:CGPointMake(self.view.frame.size.width*3/2, self.view.frame.size.height/2)];
    [UIView commitAnimations];
}
- (IBAction)rightMenuClicked:(id)sender {
}

- (IBAction)searchMenuClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"searchViewControllerIdentity"];
    [self.navigationController pushViewController:controller animated:YES];
    [self leftMenuClicked:nil];
}
- (IBAction)donateMenuClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DonateViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"donateViewControllerIdentity"];
    [self.navigationController pushViewController:controller animated:YES];
    [self leftMenuClicked:nil];
}
- (IBAction)accountsMenuClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PaymentInfoViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PaymentViewControllerIdentity"];
    controller.initLogin = NO;
    [self.navigationController pushViewController:controller animated:YES];
    [self leftMenuClicked:nil];
}
- (IBAction)profileMenuClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"settingViewControllerIdentity"];
    [self.navigationController pushViewController:controller animated:YES];
    [self leftMenuClicked:nil];
}
- (IBAction)logoutClicked:(id)sender {
    [self LogOut];
}

- (IBAction)termsClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TermsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"termsidentity"];
    controller.index = 0;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)policyClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TermsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"termsidentity"];
    controller.index = 1;
    [self.navigationController pushViewController:controller animated:YES];
    [self leftMenuClicked:nil];
}

-(void)backPaymentClicked{
    AuthNet *an = [AuthNet getInstance];
    
    [an setDelegate:self];
    BankAccountType *ba = [BankAccountType bankAccountType];
    ba.routingNumber = [MyGlobalData sharedData].routingNumber;
    ba.accountNumber = [MyGlobalData sharedData].accountNumber;
//    ba.accountType = [MyGlobalData sharedData].accountType;
//    ba.accountType = @"2";
    ba.echeckType = @"PPD";
  
    ba.nameOnAccount = [MyGlobalData sharedData].accountNickname;
    
    CustomerAddressType *b = [CustomerAddressType customerAddressType];
    b.zip = [MyGlobalData sharedData].zipCode;
    PaymentType *paymentType = [PaymentType paymentType];
    paymentType.bankAccount = ba;
//    paymentType.creditCard = c;
    
    ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeTax.amount = _giveValue;
    extendedAmountTypeTax.name = @"Tax";
    
    LineItemType *lineItem = [LineItemType lineItem];
    lineItem.itemName = @"Donate";
    lineItem.itemDescription = @"Donate";
    lineItem.itemQuantity = @"1";
    lineItem.itemPrice = _giveValue;
    lineItem.itemID = @"1";
    
    TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
    requestType.lineItems = [NSMutableArray arrayWithObject:lineItem];
    requestType.amount = _giveValue;
    requestType.payment = paymentType;
    requestType.tax = extendedAmountTypeTax;
    
    CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
    request.transactionRequest = requestType;
    //    request.anetApiRequest.merchantAuthentication.mobileDeviceId = @"358347040811237";
    //    request.anetApiRequest.merchantAuthentication.sessionToken = _sessionToken;
    
    [an purchaseWithRequest:request];
}
-(void)AuthorizeLoginFunction{
    [_AuthorizeView setHidden:NO];
}
-(IBAction)authoLogin:(id)sender{
    [_autho_username resignFirstResponder];
    [_autho_password resignFirstResponder];
    MobileDeviceLoginRequest *mobileDeviceLoginRequest = [MobileDeviceLoginRequest mobileDeviceLoginRequest];
    
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = _unique;//@"358347040811237";
    
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.name = _autho_username.text;
    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.password = _autho_password.text;
    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    [an mobileDeviceLoginRequest: mobileDeviceLoginRequest];
}
// MOBILE DELEGATE METHODS
/**
 * Optional delegate: method is called when a MobileDeviceLoginResponse response is returned from the server,
 * including MobileDeviceLoginResponse error responses.
 */
- (void) mobileDeviceLoginSucceeded:(MobileDeviceLoginResponse *)response{
    NSLog(@"ViewController : mobileDeviceLoginSucceeded - %@",response);
    _session = response.sessionToken;
    [_AuthorizeView setHidden:YES];
    if([MyGlobalData sharedData].payMode == 0)//card
        [self cardPaymentClicked];
    else if([MyGlobalData sharedData].payMode == 1)
        [self backPaymentClicked];
}/**
  * Optional delegate: method is called when a non is CreateTransactionResponse is returned from the server.
  * The errorType data member of response should indicate TRANSACTION_ERROR or SERVER_ERROR.
  * TRANSACTION_ERROR are non-APRROVED response code.  SERVER_ERROR are due to non
  * non gateway responses.  Typically these are non successful HTTP responses.  The actual
  * HTTP response is returned in the AuthNetResponse object's responseReasonText instance variable.
  */
//- (void) requestFailed:(AuthNetResponse *)response{
//    NSLog(@"ViewController : requestFailed - %@",response);
//    [_activityIndicator stopAnimating];
//    
//    UIAlertView *infoAlertView = [[UIAlertView alloc] initWithTitle:@"Login Error" message:INFORMATION_MESSAGE delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [infoAlertView show];
//    
//}
-(void)cardPaymentClicked{
    // Validate
    NSMutableString *value = [NSMutableString string];
    for (int i = 0; i < [[MyGlobalData sharedData].expirationDate length]; i++) {
        [value appendString:[[MyGlobalData sharedData].expirationDate substringWithRange:NSMakeRange(i,1)]];
        
        // After two characters append a slash.
        if ((i + 1) % 2 == 0 &&
            ([value length] < kExpirationLengthPlusSlash)) {
            [value appendString:kSlash];
        }
    }

    NSArray *components = [value componentsSeparatedByString:@"/"];
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
        
        return;
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
            
            return;
        }
    } else if ([year intValue] < [currentYear intValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:NSLocalizedString(@"Please enter a valid expiration date.", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert setTag:kCardExpirationErrorAlert];
        [alert show];
        
        return;
    }
    [self saveCreditCardInfo];

}

-(void)sendPaymentSuccess{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    NSString *type;
    switch ([MyGlobalData sharedData].payMode) {
        case 0:
            type = @"credit";
            break;
        case 1:
            type = @"bank";
            break;
        case 2:
            type = @"applepay";
            break;
        case 3:
            type = @"paypal";
            break;
        default:
            break;
    }
    NSString *strPrice = [NSString stringWithFormat:@"%.2f", donatePrice];
    
    [[HttpApi sharedInstance] SendDonateWithAmountString:strPrice
                                                DonateID:[MyGlobalData sharedData].donateObj.donateId
                                              DonateType:type
                                                Complete:^(NSString *responseData){
                                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                    ThankyouViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ThankyouViewControllerIdentity"];
                                                    [self.navigationController pushViewController:controller animated:YES];
                                                    [spinner stopAnimating];
                                                    
                                                } Failed:^(NSString *strError){
                                                    [spinner stopAnimating];
                                                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"No network access. please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                    [alert show];
                                                    
                                                }];
}
#pragma mark -
#pragma mark Private Method

- (void) saveCreditCardInfo {
    
    
    
    AuthNet *an = [AuthNet getInstance];
    
    [an setDelegate:self];
    
    CreditCardType *c = [CreditCardType creditCardType];
    c.cardNumber = [MyGlobalData sharedData].carnNumber;
    c.expirationDate = [MyGlobalData sharedData].expirationDate;
    c.cardCode = [MyGlobalData sharedData].cvv;
    CustomerAddressType *b = [CustomerAddressType customerAddressType];
    b.zip = [MyGlobalData sharedData].zipCode;
    
    PaymentType *paymentType = [PaymentType paymentType];
    paymentType.creditCard = c;
    
    ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
    extendedAmountTypeTax.amount = _giveValue;
    extendedAmountTypeTax.name = @"Tax";
    
    LineItemType *lineItem = [LineItemType lineItem];
    lineItem.itemName = @"Donate";
    lineItem.itemDescription = @"Donate";
    lineItem.itemQuantity = @"1";
    lineItem.itemPrice = _giveValue;
    lineItem.itemID = @"1";
    
    TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
    requestType.lineItems = [NSMutableArray arrayWithObject:lineItem];
    requestType.amount = _giveValue;
    requestType.payment = paymentType;
    requestType.tax = extendedAmountTypeTax;
    
    CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
    request.transactionRequest = requestType;
    request.anetApiRequest.merchantAuthentication.name = @"579pVv3RQ2Zk";
    request.anetApiRequest.merchantAuthentication.transactionKey = @"3wJ96zs7E52q4J48";
    
    [an purchaseWithRequest:request];
    //dev
/*    request.transactionType = AUTH_ONLY;
//    device uni
//    request.anetApiRequest.merchantAuthentication.mobileDeviceId = [[UIDevice currentDevice] uniqueIdentifier]
    request.anetApiRequest.merchantAuthentication.mobileDeviceId = _unique;
    //    request.anetApiRequest.merchantAuthentication.sessionToken = _session;
    request.anetApiRequest.merchantAuthentication.name = @"579pVv3RQ2Zk";
    request.anetApiRequest.merchantAuthentication.transactionKey = @"3wJ96zs7E52q4J48";
    request.anetApiRequest.refId = @"123456";
    request.transactionRequest.refTransId = @"22434566";
    
//    [an purchaseWithRequest:request];*/
//    [an voidWithRequest:request];
    
}

///////////////////////////////////

#pragma mark -
#pragma mark - AuthNetDelegate Methods

- (void)paymentSucceeded:(CreateTransactionResponse*)response {
//    [_activityIndicator stopAnimating];
    [self sendPaymentSuccess];
    /*
    NSLog(@"Payment Success ********************** ");
    
    NSString *title = @"Successfull Transaction";
    NSString *alertMsg = nil;
    UIAlertView *PaumentSuccess = nil;
    
//    TransactionResponse *transResponse = response.transactionResponse;
//
    alertMsg = [response responseReasonText];
    NSLog(@"%@",response.responseReasonText);
    PaumentSuccess = [[UIAlertView alloc] initWithTitle:title message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [PaumentSuccess setTag:10];
//    if ([transResponse.responseCode isEqualToString:@"4"])
//    {
//        PaumentSuccess = [[UIAlertView alloc] initWithTitle:title message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"LOGOUT",nil];
//    }
//    else
//    {
//        PaumentSuccess = [[UIAlertView alloc] initWithTitle:title message:PAYMENT_SUCCESSFUL delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"LOGOUT",nil];
//    }
    [PaumentSuccess show];*/
    
}

- (void)paymentCanceled {
    
    NSLog(@"Payment Canceled ********************** ");
    
//    [_activityIndicator stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) requestFailed:(AuthNetResponse *)response {
    
    NSLog(@"Request Failed ********************** ");
    
    NSString *title = nil;
    NSString *alertErrorMsg = nil;
    UIAlertView *alert = nil;

//    [_activityIndicator stopAnimating];
    
    if ( [response errorType] == SERVER_ERROR)
    {
        title = NSLocalizedString(@"Server Error", @"");
        alertErrorMsg = [response responseReasonText];
    }
    else if([response errorType] == TRANSACTION_ERROR)
    {
        title = NSLocalizedString(@"Transaction Error", @"");
        alertErrorMsg = [response responseReasonText];
    }
    else if([response errorType] == CONNECTION_ERROR)
    {
        title = NSLocalizedString(@"Connection Error", @"");
        alertErrorMsg = [response responseReasonText];
    }
    
    Messages *ma = response.anetApiResponse.messages;
    
    AuthNetMessage *m = [ma.messageArray objectAtIndex:0];
    
    NSLog(@"Response Msg Array Count: %lu", (unsigned long)[ma.messageArray count]);
    
    NSLog(@"Response Msg Code %@ ", m.code);
    
    NSString *errorCode = [NSString stringWithFormat:@"%@",m.code];
    NSString *errorText = [NSString stringWithFormat:@"%@",m.text];
    
    NSString *errorMsg = [NSString stringWithFormat:@"%@ : %@", errorCode, errorText];
    
    if (alertErrorMsg == nil) {
        alertErrorMsg = errorText;
    }
    
    NSLog(@"Error Code and Msg %@", errorMsg);
    
    
    if ( ([m.code isEqualToString:@"E00027"]) || ([m.code isEqualToString:@"E00007"]) || ([m.code isEqualToString:@"E00096"]))
    {
        
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:alertErrorMsg
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                 otherButtonTitles:nil];
    }
    else if ([m.code isEqualToString:@"E00008"]) // Finger Print Value is not valid.
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error"
                                           message:errorText
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                 otherButtonTitles:nil];
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:alertErrorMsg
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                 otherButtonTitles:nil];
    }
    [alert show];
    [alert setTag:9];
    return;
}

- (void) connectionFailed:(AuthNetResponse *)response {
    NSLog(@"%@", response.responseReasonText);
    NSLog(@"Connection Failed");
    
    NSString *title = nil;
    NSString *message = nil;
    
    if ([response errorType] == NO_CONNECTION_ERROR)
    {
        title = NSLocalizedString(@"No Signal", @"");
        message = NSLocalizedString(@"Unable to complete your request. No Internet connection.", @"");
    }
    else
    {
        title = NSLocalizedString(@"Connection Error", @"");
        message = NSLocalizedString(@"A connection error occurred.  Please try again.", @"");
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"") otherButtonTitles:nil];
    alert.delegate = self;
    [alert show];
    
}


-(void)logoutSucceeded:(LogoutResponse *)response{
    
    NSLog(@"Logout Success ********************** ");
    
}


-(void) LogoutAction{
    LogoutRequest *logoutRequest = [LogoutRequest logoutRequest];
    logoutRequest.anetApiRequest.merchantAuthentication.name = nil;
    logoutRequest.anetApiRequest.merchantAuthentication.password = nil;
    
    AuthNet *an = [AuthNet getInstance];
    [an setDelegate:self];
    [an LogoutRequest:logoutRequest];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UIAlertView Delegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if(alertView.tag == 10){
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        ThankyouViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ThankyouViewControllerIdentity"];
//        [self.navigationController pushViewController:controller animated:YES];
//    }
}

#pragma mark -
#pragma mark IBAction

- (IBAction)onClickBarItemInfo:(id)sender {
    
    UIAlertView *infoAlertView = [[UIAlertView alloc] initWithTitle:@"Developer Information" message:INFORMATION_MESSAGE delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [infoAlertView show];
}

- (IBAction)buyWithApplePayButtonPressed:(id)sender
{
    // ApplePay with Passkit
    [self presentPaymentController];
    
    
    // ApplePay demo without Passkit using fake FingerPrint and Blob
    //[self createTransactionWithOutPassKit];
}


- (IBAction)onClickLogoutPressed:(id)sender {
    [self LogoutAction];
}

- (IBAction) infoPressed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"The security code (CVV2) is a unique three or four-digit number on the back of a card (on the front for American Express).", @"")
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                          otherButtonTitles:nil];
    [alert show];
    
    return;
}

-(void) _applicationWillGetBackGrounded
{
}

-(void) _applicationWillEnterForeground
{
}

-(CreateTransactionRequest *)createTransactionReqObjectWithApiLoginID:(NSString *) apiLoginID
                                                  fingerPrintHashData:(NSString *) fpHashData
                                                       sequenceNumber:(NSInteger) sequenceNumber
                                                      transactionType:(AUTHNET_ACTION) transactionType
                                                      opaqueDataValue:(NSString*) opaqueDataValue
                                                       dataDescriptor:(NSString *) dataDescriptor
                                                        invoiceNumber:(NSString *) invoiceNumber
                                                          totalAmount:(NSDecimalNumber*) totalAmount
                                                          fpTimeStamp:(NSTimeInterval) fpTimeStamp
{
    // create the transaction.
    CreateTransactionRequest *transactionRequestObj = [CreateTransactionRequest createTransactionRequest];
    TransactionRequestType *transactionRequestType = [TransactionRequestType transactionRequest];
    
    transactionRequestObj.transactionRequest = transactionRequestType;
    transactionRequestObj.transactionType = transactionType;
    
    // Set the fingerprint.
    // Note: Finger print generation requires transaction key.
    // Finger print generation must happen on the server.
    
    FingerPrintObjectType *fpObject = [FingerPrintObjectType fingerPrintObjectType];
    fpObject.hashValue = fpHashData;
    fpObject.sequenceNumber= sequenceNumber;
    fpObject.timeStamp = fpTimeStamp;
    
    transactionRequestObj.anetApiRequest.merchantAuthentication.fingerPrint = fpObject;
    transactionRequestObj.anetApiRequest.merchantAuthentication.name = apiLoginID;
    
    // Set the Opaque data
    OpaqueDataType *opaqueData = [OpaqueDataType opaqueDataType];
    opaqueData.dataValue= opaqueDataValue;
    opaqueData.dataDescriptor = dataDescriptor;
    
    PaymentType *paymentType = [PaymentType paymentType];
    paymentType.creditCard= nil;
    paymentType.bankAccount= nil;
    paymentType.trackData= nil;
    paymentType.swiperData= nil;
    paymentType.opData = opaqueData;
    
    
    transactionRequestType.amount = [NSString stringWithFormat:@"%@",totalAmount];
    transactionRequestType.payment = paymentType;
    transactionRequestType.retail.marketType = @"0"; //0
    transactionRequestType.retail.deviceType = @"7";
    
    OrderType *orderType = [OrderType order];
    orderType.invoiceNumber = invoiceNumber;
    NSLog(@"Invoice Number Before Sending the Request %@", orderType.invoiceNumber);
    
    return transactionRequestObj;
}

// ApplePay demo without Passkit using fake FingerPrint and Blob
-(void) createTransactionWithOutPassKit
{
    
    //-------WARNING!----------------
    // Transaction key should never be stored on the device or embedded in the code.
    // This part of the code that generates the finger print is present here only to make the sample app work.
    // Finger print generation should be done on the server.
    
    NSString *apiLogID                       = @"29XNx9w36";
    NSString *transactionSecretKey           = @"9fF3AVtw6jG8m27R";
    NSString *dataDescriptor                 = @"COMMON.APPLE.INAPP.PAYMENT";
    
    NSInteger sequenceNumber = arc4random() % 100;
    NSLog(@"Invoice Number [Random]: %ld", (long)sequenceNumber);
    
    
    NSNumber *aNumber = [NSNumber numberWithDouble:0.01];
    NSDecimalNumber *totalAmount = [NSDecimalNumber decimalNumberWithDecimal:[aNumber decimalValue]];
    NSLog(@"Total Amount: %@", totalAmount);
    
    //NSDecimalNumber* invoiceNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
    
    NSTimeInterval fingerprintTimestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *nFP = [self prepareFPHashValueWithApiLoginID:apiLogID
                                      transactionSecretKey:transactionSecretKey
                                            sequenceNumber:sequenceNumber
                                               totalAmount:totalAmount
                                                 timeStamp:fingerprintTimestamp];
    
    NSLog(@"Finger Print After New Method %@", nFP);
    
    CreateTransactionRequest *transactionRequestObj = [self createTransactionReqObjectWithApiLoginID:apiLogID
                                                                                 fingerPrintHashData:nFP
                                                                                      sequenceNumber:sequenceNumber
                                                                                     transactionType:AUTH_ONLY
                                                                                     opaqueDataValue:[self getData2]
                                                                                      dataDescriptor:dataDescriptor
                                                                                       invoiceNumber:[NSString stringWithFormat:@"%d", arc4random() % 100]
                                                                                         totalAmount:totalAmount
                                                                                         fpTimeStamp:fingerprintTimestamp];
    if (transactionRequestObj!= nil)
    {
        AuthNet *authNetSDK = [AuthNet getInstance];
        [authNetSDK setDelegate:self];
        
        // Submit the transaction.
        [authNetSDK purchaseWithRequest:transactionRequestObj];
        
        
    }
    
    
    
}


// note: this is a sample blob.


-(NSString* )getData2
{
    return @"eyJkYXRhIjoiVXIxZ2NESnczZDlEc0lkcDBuNlwvUmVSMENTQ3A0KzZNTUkxUlhwOVBjZkgzZDZVTDJtUnRJMGJCS09MMmNrVkluNXhPQkIwZmxUQkdEUmFGZGp2OTRPUklRVHdsM0VaWEI4cWxCZFl6UGQ1WFhNTU81MGVSR1NQTlwvUEdqeDA2WVRmMlhUMnI4ZzZZamZlSDdob3ZsNmR4Nk9JV1llM0NDSGhYSlFzSkpZWUpUb2RZZlp0b1BRKzd3VFBiR05Bbll0NElESk4xYkJDMXJSQnRrTHBvUE9ZUk1mWXRqSHVkYWVwOG9SbzZaWFRRVVBmdkVXdVY2S01EVzlKTzhsbjlUTE1Nak9PYVwvVXRQZ3JTeTA1WU42RE4xT1wvS2JyeisrY01CeHRlSjBuODg3U2JLZ3cyVUczSDI1UG96bkpocUNOMjlPNTVFZ2FoRlZ1NmszVHQ4aXNTK3dMT3pOa21xeFlrUytUWlEwT3RWWkU4XC84bWRUa3NLVTIwWXRBXC9yZ3p4cE94N2g1MkhTOXBiZ0ducXBSYnB0SWJBRUpITk4yZHRXQ25TUk9Zc0pjSW9YXC9zPSIsInZlcnNpb24iOiJFQ192MSIsImhlYWRlciI6eyJhcHBsaWNhdGlvbkRhdGEiOiI5NGVlMDU5MzM1ZTU4N2U1MDFjYzRiZjkwNjEzZTA4MTRmMDBhN2IwOGJjN2M2NDhmZDg2NWEyYWY2YTIyY2MyIiwidHJhbnNhY3Rpb25JZCI6ImMxY2FmNWFlNzJmMDAzOWE4MmJhZDkyYjgyODM2MzczNGY4NWJmMmY5Y2FkZjE5M2QxYmFkOWRkY2I2MGE3OTUiLCJlcGhlbWVyYWxQdWJsaWNLZXkiOiJNSUlCU3pDQ0FRTUdCeXFHU000OUFnRXdnZmNDQVFFd0xBWUhLb1pJemowQkFRSWhBUFwvXC9cL1wvOEFBQUFCQUFBQUFBQUFBQUFBQUFBQVwvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvTUZzRUlQXC9cL1wvXC84QUFBQUJBQUFBQUFBQUFBQUFBQUFBXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvXC9cL1wvOEJDQmF4alhZcWpxVDU3UHJ2VlYybUlhOFpSMEdzTXhUc1BZN3pqdytKOUpnU3dNVkFNU2ROZ2lHNXdTVGFtWjQ0Uk9kSnJlQm4zNlFCRUVFYXhmUjh1RXNRa2Y0dk9ibFk2UkE4bmNEZllFdDZ6T2c5S0U1UmRpWXdwWlA0MExpXC9ocFwvbTQ3bjYwcDhENTRXSzg0elYyc3hYczdMdGtCb043OVI5UUloQVBcL1wvXC9cLzhBQUFBQVwvXC9cL1wvXC9cL1wvXC9cL1wvKzg1dnF0cHhlZWhQTzV5c0w4WXlWUkFnRUJBMElBQk1jWk5BSDVtY2ZDVXdRT3JycDM1dkpJazBJMU92RXQrUkJaVFlmdFhiSXZjYjdYQzJnK3pMMkFzYWpcL3o2TWxJa0p0OVRPTVl2VVU4ZGJneE01S3gxbz0iLCJwdWJsaWNLZXlIYXNoIjoidDZtRHdrc3dqSEU3YnV0TWFCTmpZMGVzTDVtbGV4aFB6dHVcL3ppQWJCMWc9In0sInNpZ25hdHVyZSI6Ik1JSURRZ1lKS29aSWh2Y05BUWNDb0lJRE16Q0NBeThDQVFFeEN6QUpCZ1VyRGdNQ0dnVUFNQXNHQ1NxR1NJYjNEUUVIQWFDQ0Fpc3dnZ0luTUlJQmxLQURBZ0VDQWhCY2wrUGYzK1U0cGsxM25WRDlud1FRTUFrR0JTc09Bd0lkQlFBd0p6RWxNQ01HQTFVRUF4NGNBR01BYUFCdEFHRUFhUUJBQUhZQWFRQnpBR0VBTGdCakFHOEFiVEFlRncweE5EQXhNREV3TmpBd01EQmFGdzB5TkRBeE1ERXdOakF3TURCYU1DY3hKVEFqQmdOVkJBTWVIQUJqQUdnQWJRQmhBR2tBUUFCMkFHa0Fjd0JoQUM0QVl3QnZBRzB3Z1o4d0RRWUpLb1pJaHZjTkFRRUJCUUFEZ1kwQU1JR0pBb0dCQU5DOCtrZ3RnbXZXRjFPempnRE5yalRFQlJ1b1wvNU1LdmxNMTQ2cEFmN0d4NDFibEU5dzRmSVhKQUQ3RmZPN1FLaklYWU50MzlyTHl5N3hEd2JcLzVJa1pNNjBUWjJpSTFwajU1VWM4ZmQ0ZnpPcGszZnRaYVFHWE5MWXB0RzFkOVY3SVM4Mk91cDlNTW8xQlBWclhUUEhOY3NNOTlFUFVuUHFkYmVHYzg3bTByQWdNQkFBR2pYREJhTUZnR0ExVWRBUVJSTUUrQUVIWldQcld0SmQ3WVo0MzFoQ2c3WUZTaEtUQW5NU1V3SXdZRFZRUURIaHdBWXdCb0FHMEFZUUJwQUVBQWRnQnBBSE1BWVFBdUFHTUFid0J0Z2hCY2wrUGYzK1U0cGsxM25WRDlud1FRTUFrR0JTc09Bd0lkQlFBRGdZRUFiVUtZQ2t1SUtTOVFRMm1GY01ZUkVJbTJsK1hnOFwvSlh2K0dCVlFKa09Lb3NjWTRpTkRGQVwvYlFsb2dmOUxMVTg0VEh3TlJuc3ZWM1BydjdSVFk4MWdxMGR0Qzh6WWNBYUFrQ0hJSTN5cU1uSjRBT3U2RU9XOWtKazIzMmdTRTdXbEN0SGJmTFNLZnVTZ1FYOEtYUVl1WkxrMlJyNjNOOEFwWHNYd0JMM2NKMHhnZUF3Z2QwQ0FRRXdPekFuTVNVd0l3WURWUVFESGh3QVl3Qm9BRzBBWVFCcEFFQUFkZ0JwQUhNQVlRQXVBR01BYndCdEFoQmNsK1BmMytVNHBrMTNuVkQ5bndRUU1Ba0dCU3NPQXdJYUJRQXdEUVlKS29aSWh2Y05BUUVCQlFBRWdZQ29lMm5iTVhoRG9lUlVGTkJJd1lhUlwvVzYyXC9PMitrem1iSVM2VmVOTzRWWStXQlZYN0ZWMEVqMGtZYWM3QUViSFpKUzhMc2VCeTZjTFFMYzNESkM4WElpTXo1a3NhUEtraFBBbElFbWVZU3plWXdMOVNNOGptQW9KQ0VVakVHU1N2anVPSkh6WlJ3TjZxRHAyS0RPUVY0N3RlUFJyT3NzN3hxMld5dnJxeXlRPT0ifQ==";
}

// ApplyPay demo section

- (void) performTransactionWithEncryptedPaymentData: (NSString*) encryptedPaymentData withPaymentAmount: (NSString*) paymnetAmount
{
    
    NSDecimalNumber* amount = [NSDecimalNumber decimalNumberWithString:paymnetAmount];
    NSDecimalNumber* invoiceNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
    NSTimeInterval fingerprintTimestamp = [[NSDate date] timeIntervalSince1970];
    
    //-------WARNING!----------------
    // Transaction key should never be stored on the device or embedded in the code.
    // Replace with Your Api log in ID and Transacation Secret Key.
    // This is a test merchant credentials to demo the capability, this would work with Visa cards only. Add a valid Visa card in the Passbook and make a sample transaction.
//    
//    NSString *apiLogInID                     = @"579pVv3RQ2Zk";//@"8Pvp4T5R";      // replace with YOUR_APILOGIN_ID
//    NSString *transactionSecretKey           = @"2Rm7EUdB9q8y2946"; // replace with YOUR_TRANSACTION_SECRET_KEY
    
    NSString *apiLogInID                     = @"579pVv3RQ2Zk";
    NSString *transactionSecretKey           = @"3wJ96zs7E52q4J48";
    
    NSString *dataDescriptor                 = @"FID=COMMON.APPLE.INAPP.PAYMENT";
    
    //-------WARNING!----------------
    // Transaction key should never be stored on the device or embedded in the code.
    // This part of the code that generates the finger print is present here only to make the sample app work.
    // Finger print generation should be done on the server.
    
    NSString *fingerprintHashValue = [self prepareFPHashValueWithApiLoginID:apiLogInID
                                                       transactionSecretKey:transactionSecretKey
                                                             sequenceNumber:invoiceNumber.longValue
                                                                totalAmount:amount
                                                                  timeStamp:fingerprintTimestamp];
    
    CreateTransactionRequest * transactionRequestObj = [self createTransactionReqObjectWithApiLoginID:apiLogInID
                                                                                  fingerPrintHashData:fingerprintHashValue
                                                                                       sequenceNumber:invoiceNumber.intValue
                                                                                      transactionType:AUTH_ONLY
                                                                                      opaqueDataValue:encryptedPaymentData
                                                                                       dataDescriptor:dataDescriptor
                                                                                        invoiceNumber:invoiceNumber.stringValue
                                                                                          totalAmount:amount
                                                                                          fpTimeStamp:fingerprintTimestamp];
    if (transactionRequestObj != nil)
    {
        
        AuthNet *authNet = [AuthNet getInstance];
        [authNet setDelegate:self];
        
        authNet.environment = ENV_TEST;
        // Submit the transaction for AUTH_CAPTURE.
        [authNet purchaseWithRequest:transactionRequestObj];
        
        // Submit the transaction for AUTH_ONLY.
        //[authNet authorizeWithRequest:transactionRequestObj];
    }
    
    
}

/*
 Example Fingerprint Input Field Order
 "authnettest^789^67897654^10.50^"
 
 ----------WARNING!----------------
 Finger print generation requires the transaction key. This should
 be done at the server. It is shown here only for Demo purposes.
 http://www.authorize.net/support/DirectPost_guide.pdf p22-23
 */

-(NSString*) prepareFPHashValueWithApiLoginID:(NSString*) apiLoginID
                         transactionSecretKey:(NSString*) transactionSecretKey
                               sequenceNumber:(NSInteger) sequenceNumber
                                  totalAmount:(NSDecimalNumber*) totalAmount
                                    timeStamp:(NSTimeInterval) timeStamp
{
    NSString *fpHashValue = nil;
    
    fpHashValue =[NSString stringWithFormat:@"%@^%ld^%lld^%@^", apiLoginID, (long)sequenceNumber, (long long)timeStamp, totalAmount];
    
    
    NSLog(@"Finger Print Before HMAC_MD5: %@", fpHashValue);
    
    return [NSString HMAC_MD5_WithTransactionKey:transactionSecretKey fromValue:fpHashValue];
}


+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] ;
}

// PassKit Delegate handlers

#pragma mark - Authorization delegate methods

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    if (payment)
    {
        // Go off and auth the card
        
        NSString *base64string = [ConfirmPaymentViewController  base64forData:payment.token.paymentData];
        
        [self performTransactionWithEncryptedPaymentData:base64string withPaymentAmount:_giveValue];
        
        completion(PKPaymentAuthorizationStatusSuccess);
    }
    else
    {
        completion(PKPaymentAuthorizationStatusFailure);
    }
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    
}












// ApplePay with Passkit
-(void )presentPaymentController
{
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    
    request.currencyCode = @"USD";
    request.countryCode = @"US";
    // This is a test merchant id to demo the capability, this would work with Visa cards only.
    request.merchantIdentifier = @"merchant.com.deedio.donate";  // replace with YOUR_APPLE_MERCHANT_ID
    request.applicationData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    request.merchantCapabilities = PKMerchantCapability3DS;
    request.supportedNetworks = @[PKPaymentNetworkMasterCard, PKPaymentNetworkVisa, PKPaymentNetworkAmex];
//    request.requiredBillingAddressFields = PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldEmail;
//    request.requiredShippingAddressFields = PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldEmail;
//    request.requiredBillingAddressFields = PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldEmail;
//    request.requiredShippingAddressFields = PKAddressFieldPostalAddress|PKAddressFieldPhone|PKAddressFieldEmail;
    
    ///Set amount here
//    NSString *amountText =  @"0.01"; // Get the payment amount
    NSDecimalNumber *amountValue = [NSDecimalNumber decimalNumberWithString:_giveValue];
    
    PKPaymentSummaryItem *item = [[PKPaymentSummaryItem alloc] init];
    item.amount = amountValue;
    //item.amount = [[NSDecimalNumber alloc] initWithInt:20];
    item.label = @"Donate";
    
    request.paymentSummaryItems = @[item];
    
    PKPaymentAuthorizationViewController *vc = nil;
    
    // need to setup correct entitlement to make the view to show
    @try
    {
        vc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    }
    
    @catch (NSException *e)
    {
        NSLog(@"Exception %@", e);
    }
    
    if (vc != nil)
    {
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:CompletionBlock];
    }
    else
    {
        //The device cannot make payments. Please make sure Passbook has valid Credit Card added.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PassKit Payment Error"
                                                        message:NSLocalizedString(@"The device cannot make payment at this time. Please check Passbook has Valid Credit Card and Payment Request has Valid Currency & Apple MerchantID.", @"")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }
    
}

void (^CompletionBlock)(void) = ^
{
    NSLog(@"This is Completion block");
    
};

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)initPaypal
{
    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
#if HAS_CARDIO
    // You should use the PayPal-iOS-SDK+card-Sample-App target to enable this setting.
    // For your apps, you will need to link to the libCardIO and dependent libraries. Please read the README.md
    // for more details.
    _payPalConfig.acceptCreditCards = YES;
#else
    _payPalConfig.acceptCreditCards = NO;
#endif
    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    
    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.
    
    //    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    self.environment = kPayPalEnvironment;
}

#pragma mark - Receive Single Payment

- (void)payPaypal_clicked{
    
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    PayPalItem *item1;
    item1 = [PayPalItem itemWithName:[NSString stringWithFormat:@"%@ donate is %.2f", _strMosque.donateName, donatePrice]
                        withQuantity:1
                           withPrice:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", donatePrice]]
                        withCurrency:@"USD"
                             withSku:@""];

    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0"];
    //    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
    //                                                                               withShipping:shipping
    //                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"DONATE";
    payment.items = items;  // if not including multiple items, then leave payment.items as nil
    //    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
//    transaction
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    //    [self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    //    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
//    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
//    float amount = [completedPayment.amount floatValue];
//    NSString *strAmount = [NSString stringWithFormat:@"%f",amount];
//    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
//    [self.view addSubview:spinner];
//    [spinner startAnimating];
//    
//    [spinner stopAnimating];
    [self PayWithPaypal];
//    [self sendPaymentSuccess];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ThankyouViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ThankyouViewControllerIdentity"];
//    [self.navigationController pushViewController:controller animated:YES];
//    
//    [[HttpApi sharedInstance] SendDonateWithAmountString:strAmount DonateID:_strMosque.donateId
//                                       Complete:^(NSString *responseObject){
//                                           NSDictionary *dicResponse = (NSDictionary *)responseObject;
//                                           NSString *status = [dicResponse objectForKey:@"msg"];
//                                           if([status isEqualToString:@"Success"]){
//                                               [spinner stopAnimating];
//                                               UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                                               ThankyouViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ThankyouViewControllerIdentity"];
//                                               [self.navigationController pushViewController:controller animated:YES];
//                                           }else{
//                                               [spinner stopAnimating];
//                                               UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"payment failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                               [alert show];
//                                               
//                                           }
//                                       } Failed:^(NSString *strError) {
//                                           [spinner stopAnimating];
//                                           UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"No network access. please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                                           [alert show];
//                                       }];   

}


#pragma mark - Authorize Future Payments

- (IBAction)getUserAuthorizationForFuturePayments:(id)sender {
    
    PayPalFuturePaymentViewController *futurePaymentViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:self.payPalConfig delegate:self];
    [self presentViewController:futurePaymentViewController animated:YES completion:nil];
}


#pragma mark PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
    NSLog(@"PayPal Future Payment Authorization Success!");
    self.resultText = [futurePaymentAuthorization description];
    //    [self showSuccess];
    
    [self sendFuturePaymentAuthorizationToServer:futurePaymentAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    NSLog(@"PayPal Future Payment Authorization Canceled");
    //    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendFuturePaymentAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete future payment setup.", authorization);
}

#pragma mark - Authorize Profile Sharing

- (IBAction)getUserAuthorizationForProfileSharing:(id)sender {
    
    NSSet *scopeValues = [NSSet setWithArray:@[kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]];
    
    PayPalProfileSharingViewController *profileSharingPaymentViewController = [[PayPalProfileSharingViewController alloc] initWithScopeValues:scopeValues configuration:self.payPalConfig delegate:self];
    [self presentViewController:profileSharingPaymentViewController animated:YES completion:nil];
}


#pragma mark PayPalProfileSharingDelegate methods

- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
    NSLog(@"PayPal Profile Sharing Authorization Success!");
    self.resultText = [profileSharingAuthorization description];
    //    [self showSuccess];
    
    [self sendProfileSharingAuthorizationToServer:profileSharingAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController {
    NSLog(@"PayPal Profile Sharing Authorization Canceled");
    //    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendProfileSharingAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete profile sharing setup.", authorization);
}
- (IBAction)backgroundClicked:(id)sender {
    [[MyGlobalData sharedData] resetTimer];
}

@end
