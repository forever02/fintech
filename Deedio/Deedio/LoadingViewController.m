//
//  LoadingViewController.m
//  Deedio
//
//  Created by dev on 6/20/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "LoadingViewController.h"
#import "MyGlobalData.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "ResetPasswordViewController.h"
#import "HttpApi.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden: YES animated:YES];
//    [self checkValue];
}
-(void)viewWillAppear:(BOOL)animated{
    [self checkValue];
}
-(void)checkValue
{
    if([MyGlobalData sharedData].resetPassword){
        [MyGlobalData sharedData].resetPassword = false;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ResetPasswordViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"resetpasswordIdentity"];
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    if([MyGlobalData sharedData].verify){
        [MyGlobalData sharedData].verify = false;
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        [self.view addSubview:spinner];
        [spinner startAnimating];
        
        [[HttpApi sharedInstance] VerifyWithEmail:[MyGlobalData sharedData].userEmail
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
    if(![[MyGlobalData sharedData].userName isEqualToString:@""]){
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"loginidentity"];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"signupidentity"];
        [self.navigationController pushViewController:controller animated:YES];
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

@end
