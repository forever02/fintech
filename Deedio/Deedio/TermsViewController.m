//
//  TermsViewController.m
//  Deedio
//
//  Created by dev on 6/20/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "TermsViewController.h"
#import "MyGlobalData.h"

@interface TermsViewController ()

@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [self.view addGestureRecognizer:tap];
    [self viewPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewPage
{
    NSString *name;
    if(_index ==0){
        name = @"tos";
    }else{
        name = @"pp";
    }
    NSURL *rtfUrl = [[NSBundle mainBundle] URLForResource:name withExtension:@"rtf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:rtfUrl];
    
    [_webView loadRequest:request];
}
-(void)singleTap:(UITapGestureRecognizer *)recognizer{
    
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
