//
//  SearchViewController.m
//  Deedio
//
//  Created by dev on 6/1/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "SearchViewController.h"
#import "DonateViewController.h"
#import "PaymentInfoViewController.h"
#import "SettingViewController.h"
#import "HttpApi.h"
#import "DonateObject.h"
#import "MyGlobalData.h"
#import "LoginViewController.h"
#import "TermsViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
    [self.txtSearch setDelegate:self];
    self.searchBuf = @"";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(LogOut) name:@"logout" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    _resultrray = [[NSMutableArray alloc] init];
    [self.tblSearch reloadData];
    [self getAlldata];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)LogOut{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"loginidentity"];
    [self.navigationController pushViewController:controller animated:NO];
}
-(void)initViews
{
    UIColor *color = [UIColor colorWithRed:162 green:161 blue:184 alpha:0.5];
    if([self.txtSearch respondsToSelector:@selector(setAttributedPlaceholder:)]){
        self.txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search for your organization." attributes:@{NSForegroundColorAttributeName: color}];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backgroundClicked:(id)sender {
    [self resignKeyboard];
    [[MyGlobalData sharedData] resetTimer];
}
-(void)getAlldata{
    
    _dataArray = [[NSMutableArray alloc] init];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    [[HttpApi sharedInstance] GetDonatesWithString:@""
                                          Complete:^(NSString *responseObject){
                                              NSDictionary *dicResponse = (NSDictionary *)responseObject;
                                              NSString *status = [dicResponse objectForKey:@"msg"];
                                              if([status isEqualToString:@"Success"]){
                                                  //                                               self.dataArray
                                                  [self getResponseData:dicResponse];
                                                  [spinner stopAnimating];
                                                  
                                              }else{
                                                  [spinner stopAnimating];
                                                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"name or password incorrect!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                  [alert show];
                                                  
                                              }
                                          } Failed:^(NSString *strError) {
                                              [spinner stopAnimating];
                                              UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"No network access. please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                              [alert show];
                                          }];
}
-(void)searchResult{
    NSString *srtString = [_txtSearch.text lowercaseString];
    NSString *drtString;
    _resultrray = [[NSMutableArray alloc] init];
    DonateObject *item;
    if([srtString isEqualToString:@""]){
        for(int i = 0; i < _dataArray.count; i++){
            item = _dataArray[i];
            drtString = item.donateName;
            [_resultrray addObject:item];
        }
    }else{
        for(int i = 0; i < _dataArray.count; i++){
            item = _dataArray[i];
            drtString = [item.donateName lowercaseString];
            if([drtString containsString:srtString]){
                [_resultrray addObject:item];
            }
        }
    }
    
    [self.tblSearch reloadData];
}
//textField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    float delta = 0;
    if(textField.frame.origin.y > self.view.frame.size.height/2){
        delta = textField.frame.origin.y - self.view.frame.size.height/2;
        [UIView beginAnimations: @"moveUp" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: 0.3f];
        [self.view setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - delta)];
        //    self.view.frame = CGRectOffset(self.inputView.frame, 0, movement);
        [UIView commitAnimations];
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string length] > 0) { //NOT A BACK SPACE Add it
        self.searchBuf  = [NSString stringWithFormat:@"%@%@", self.searchBuf, string];
    } else {
        if ([self.searchBuf length] > 1) {
            self.searchBuf = [self.searchBuf substringWithRange:NSMakeRange(0, [self.searchBuf length] - 1)];
        } else {
            self.searchBuf = @"";
        }
    }
    [_txtSearch setText:_searchBuf];
    [self searchResult];
    
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self resignKeyboard];
//    [self searchClicked:nil];
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
    [self.txtSearch resignFirstResponder];
}

//Menu Actions
- (IBAction)menuClicked:(id)sender {
    [UIView beginAnimations:@"slideLeft" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:(id)self];
    
    [self.menuView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [UIView commitAnimations];
    [self.view bringSubviewToFront:self.menuView];
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
    [self leftgroundClicked:nil];
}
- (IBAction)donateMenuClicked:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DonateViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"donateViewControllerIdentity"];
    [self.navigationController pushViewController:controller animated:YES];

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

//search action
- (IBAction)searchClicked:(id)sender {
    
//    _dataArray = [[NSMutableArray alloc] init];
    _resultrray = [[NSMutableArray alloc] init];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    [[HttpApi sharedInstance] GetDonatesWithString:_txtSearch.text
                                       Complete:^(NSString *responseObject){
                                           NSDictionary *dicResponse = (NSDictionary *)responseObject;
                                           NSString *status = [dicResponse objectForKey:@"msg"];
                                           if([status isEqualToString:@"Success"]){
//                                               self.dataArray
                                               [self getResponseData1:dicResponse];
                                               [self.tblSearch reloadData];
                                               [spinner stopAnimating];
                                               
                                           }else{
                                               [spinner stopAnimating];
                                               UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"name or password incorrect!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                               [alert show];
                                               
                                           }
                                       } Failed:^(NSString *strError) {
                                           [spinner stopAnimating];
                                           UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"No network access. please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                           [alert show];
                                       }];
    

//    self.dataArray = [NSArray arrayWithObjects:@"King Fahad Mosque, Culver City. CA",@"ICSC, Los Angeles, CA",@"Masjid Ibaadillah, Los Angeles, CA",@"Masjid AI Mumin, Los Angeles, CA",@"ICSC, Los Angeles, CA", nil];
//    [self.tblSearch reloadData];
}
-(void)getResponseData:(NSDictionary *)dic{
    NSArray *tmpList = (NSArray*)[dic objectForKey:@"contents"];
    for(int nIndex = 0; nIndex < tmpList.count; nIndex++){
        DonateObject *Item = [[DonateObject alloc] initWithDictionary:[tmpList objectAtIndex:nIndex]];
        [_dataArray addObject:Item];
        [_resultrray addObject:Item];
    }
    if(_dataArray.count == 0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"No such institution are found!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    //    [self.tblSearch reloadData];
}

-(void)getResponseData1:(NSDictionary *)dic{
    NSArray *tmpList = (NSArray*)[dic objectForKey:@"contents"];
    for(int nIndex = 0; nIndex < tmpList.count; nIndex++){
        DonateObject *Item = [[DonateObject alloc] initWithDictionary:[tmpList objectAtIndex:nIndex]];
//        [_dataArray addObject:Item];
        [_resultrray addObject:Item];
    }
    if(_resultrray.count == 0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Deedio" message:@"No such institution are found!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    //    [self.tblSearch reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return _resultrray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"searchTableCell";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    UITextView *txtCell = [cell viewWithTag:101];
    DonateObject *item = _resultrray[indexPath.row];
    txtCell.text = item.donateName;
    
    return cell;
}

#pragma mark UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    int a;
    [_txtSearch resignFirstResponder];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DonateViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"donateViewControllerIdentity"];
    if(indexPath.row > _resultrray.count){
        return;
    }
    DonateObject *item = _resultrray[indexPath.row];
    [MyGlobalData sharedData].donateObj = item;
    [self.navigationController pushViewController:controller animated:YES];
    
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
