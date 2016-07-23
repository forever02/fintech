//
//  ConfirmPaymentViewController.h
//  Deedio
//
//  Created by dev on 6/1/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DonateObject.h"
#import "PayPalMobile.h"
#import <PassKit/PKPaymentRequest.h>
#import <PassKit/PKPaymentToken.h>
#import <PassKit/PKPayment.h>
#import <PassKit/PKConstants.h>
#import <PassKit/PKPaymentAuthorizationViewController.h>


#import "AuthNet.h"

@interface ConfirmPaymentViewController : UIViewController<AuthNetDelegate,UIAlertViewDelegate,PKPaymentAuthorizationViewControllerDelegate,PayPalPaymentDelegate, PayPalFuturePaymentDelegate, PayPalProfileSharingDelegate>
@property (weak, nonatomic) IBOutlet UILabel *txtDonationAmount;
@property (weak, nonatomic) IBOutlet UILabel *txtPaymentMethod;

@property (weak, nonatomic) IBOutlet UILabel *txtOrganization;

@property (weak, nonatomic) IBOutlet UIView *menuView;

@property DonateObject *strMosque;
@property NSString *unique;
@property NSString *giveValue;
@property (nonatomic, assign) UIActivityIndicatorView *activityIndicator;

//for Authorize

@property (weak, nonatomic) IBOutlet UIView *AuthorizeView;
@property (weak, nonatomic) IBOutlet UITextField *autho_username;
@property (weak, nonatomic) IBOutlet UITextField *autho_password;
@property NSString *session;
- (IBAction)authoLogin:(id)sender;

//for paypal

@property(readwrite) float price;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@end
