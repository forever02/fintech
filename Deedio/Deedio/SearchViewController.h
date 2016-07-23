//
//  SearchViewController.h
//  Deedio
//
//  Created by dev on 6/1/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblSearch;
@property NSMutableArray *dataArray;
@property NSMutableArray *resultrray;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;

@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (nonatomic, strong) NSString *searchBuf;


@end
