//
//  ResetPasswordViewController.m
//  Deedio
//
//  Created by dev on 6/30/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "MyGlobalData.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "HttpApi.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.txtNewPW setDelegate:self];
    [self.txtConfirmPW setDelegate:self];
    [self.userEmail setText:[MyGlobalData sharedData].userEmail];
    [self initViews];
}
-(void)initViews{
    UIColor *color = [UIColor colorWithRed:162 green:161 blue:184 alpha:0.5];
    if([self.txtNewPW respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txtNewPW.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"New Password" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([self.txtConfirmPW respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txtConfirmPW.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm  Password" attributes:@{NSForegroundColorAttributeName: color}];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (IBAction)okClicked:(id)sender {
    
    if(![self validatePassword:_txtNewPW.text]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"Password need to have 7 or more characters, containing letters and minimum one number!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(![_txtNewPW.text isEqualToString:_txtConfirmPW.text]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"Password is not match!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    NSString *pw = _txtNewPW.text;
    [[HttpApi sharedInstance] ResetPasswordWithEmail:[MyGlobalData sharedData].userEmail Password:pw
                                       Complete:^(NSString *responseObject){
                                           NSDictionary *dicResponse = (NSDictionary *)responseObject;
                                           NSString *status = [dicResponse objectForKey:@"msg"];
                                           [spinner stopAnimating];
                                           if([status isEqualToString:@"Success"]){
                                               UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                               LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"loginidentity"];
                                               [self.navigationController pushViewController:controller animated:YES];
                                           }else{
                                               UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:status delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                               [alert show];
                                               
                                           }
                                       } Failed:^(NSString *strError) {
                                           [spinner stopAnimating];
                                           UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"No network access. please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                           [alert show];
                                       }];

}

- (IBAction)cancelClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"loginidentity"];
    [self.navigationController pushViewController:controller animated:YES];
}


- (IBAction)backgroundClicked:(id)sender {
    [_txtNewPW resignFirstResponder];
    [_txtConfirmPW resignFirstResponder];
}

@end
