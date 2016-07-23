//
//  DonateViewController.h
//  Deedio
//
//  Created by dev on 6/1/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DonateObject.h"

@interface DonateViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *bttCard;
@property (weak, nonatomic) IBOutlet UIButton *bttBank;
@property (weak, nonatomic) IBOutlet UIButton *bttApple;
@property (weak, nonatomic) IBOutlet UIButton *bttPaypal;



@property (weak, nonatomic) IBOutlet UIButton *bttGive;

@property (weak, nonatomic) IBOutlet UITextField *txtDonate;

@property (weak, nonatomic) IBOutlet UIImageView *imgConfirm;

@property (weak, nonatomic) IBOutlet UILabel *txtMosque;

@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (weak, nonatomic) IBOutlet UIImageView *imgBank;
@property (weak, nonatomic) IBOutlet UIImageView *imgCard;
@property (weak, nonatomic) IBOutlet UIImageView *imgApple;
@property (weak, nonatomic) IBOutlet UIImageView *imgPaypal;


@property DonateObject *strMosque;
@end
//FF4E4A/d9d9d9