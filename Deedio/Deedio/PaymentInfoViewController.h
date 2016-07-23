//
//  PaymentInfoViewController.h
//  Deedio
//
//  Created by dev on 6/1/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentInfoViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *bttCard;
@property (weak, nonatomic) IBOutlet UIButton *bttBank;

@property (weak, nonatomic) IBOutlet UITextField *txt1;

@property (weak, nonatomic) IBOutlet UITextField *txt2;

@property (weak, nonatomic) IBOutlet UITextField *txt3;

@property (weak, nonatomic) IBOutlet UITextField *txt4;

@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (weak, nonatomic) IBOutlet UIView *txtfieldView;
@property (weak, nonatomic) IBOutlet UIButton *bttback;

@property int cardselected;
@property bool initLogin;
@property (nonatomic, strong) NSString *creditCardBuf;
@property (nonatomic, strong) NSString *expirationBuf;
@property (nonatomic, strong) NSString *cvvBuf;
@property (nonatomic, strong) NSString *zipBuf;
@end
