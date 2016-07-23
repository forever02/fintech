//
//  ThankyouViewController.m
//  Deedio
//
//  Created by dev on 6/1/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "ThankyouViewController.h"
#import "SearchViewController.h"
#import "PaymentInfoViewController.h"
#import "SettingViewController.h"
#import "DonateViewController.h"
#import "LoginViewController.h"
#import "TermsViewController.h"
#import "MyGlobalData.h"

@interface ThankyouViewController ()

@end

@implementation ThankyouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LogOut) name:@"logout" object:nil];
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
//actions
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backtoSearchClicked:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"searchViewControllerIdentity"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)menuClicked:(id)sender {
    [UIView beginAnimations:@"slideLeft" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:(id)self];
    
    [self.menuView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [UIView commitAnimations];
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
- (IBAction)backgroundClicked:(id)sender {
    [[MyGlobalData sharedData] resetTimer];
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
