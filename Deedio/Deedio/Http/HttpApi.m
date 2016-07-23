//
//  HttpApi.m
//  Deedio
//
//  Created by dev on 6/16/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "HttpApi.h"
#import "MyGlobalData.h"
#import <AFHTTPRequestOperationManager.h>

@implementation HttpApi
HttpApi *sharedObj = nil;
AFHTTPRequestOperationManager *manager;

+(id) sharedInstance{
    if(!sharedObj){
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            sharedObj = [[self alloc] init];
            manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
        });
    }
    return sharedObj;
}

-(void)SignUpWithFirstName:(NSString *) firstname
                  LastName:(NSString *) lastname
                  UserName:(NSString *) username
                     Email:(NSString *) email
                    Mobile:(NSString *) mobile
                  Passwork:(NSString *) password
             Complete:(void (^)(NSString *))completed
               Failed:(void (^) (NSString *))failed{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, @"signup.php"];
    NSDictionary *dicParams = @{
                                @"firstname":firstname,
                                @"lastname":lastname,
                                @"username":username,
                                @"email":email,
                                @"phone":mobile,
                                @"password":password};
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url
       parameters:dicParams
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              completed(responseObject);
              
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              failed(@"Network error!!!");
          }
     ];
}

-(void)LoginWithUserName:(NSString *) username
                Password:(NSString *) password
                Complete:(void (^)(NSString *))completed
                  Failed:(void (^) (NSString *))failed{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, @"login.php"];
    NSDictionary *dicParams = @{
                                @"email":username,
                                @"password":password};
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url
       parameters:dicParams
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              completed(responseObject);
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              failed(@"Network error!!!");
          }
     ];
}

-(void)ForgetPasswordWithEmail:(NSString *) email
                      Complete:(void (^)(NSString *))completed
                        Failed:(void (^) (NSString *))failed{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, @"forget.php"];
    NSDictionary *dicParams = @{
                                @"email":email};
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url
       parameters:dicParams
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              completed(responseObject);
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              failed(@"Network error!!!");
          }
     ];
}
-(void)ResetPasswordWithEmail:(NSString *) email
                     Password:(NSString *) password
                     Complete:(void (^)(NSString *))completed
                       Failed:(void (^) (NSString *))failed{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, @"forget_verify.php"];
    NSDictionary *dicParams = @{
                                @"email":email,
                                @"password":password,
                                @"hash":[MyGlobalData sharedData].deviceToken
                                };
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url
       parameters:dicParams
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              completed(responseObject);
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              failed(@"Network error!!!");
          }
     ];
}
-(void)VerifyWithEmail:(NSString *) email
                     Complete:(void (^)(NSString *))completed
                       Failed:(void (^) (NSString *))failed{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, @"verify.php"];
    NSDictionary *dicParams = @{
                                @"email":email,
                                @"hash":[MyGlobalData sharedData].deviceToken
                                };
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url
       parameters:dicParams
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              completed(responseObject);
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              failed(@"Network error!!!");
          }
     ];
}

-(void)GetDonatesWithString:(NSString *) search
                     Complete:(void (^)(NSString *))completed
                       Failed:(void (^) (NSString *))failed{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, @"get_institutionlist.php"];
    NSDictionary *dicParams = @{
                                @"user_id":[MyGlobalData sharedData].userID,
                                @"hash":[MyGlobalData sharedData].deviceToken,
                                @"keyword":search};
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url
       parameters:dicParams
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              completed(responseObject);
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              failed(@"Network error!!!");
          }
     ];
}

-(void)UpdateWithFirstName:(NSString *) firstname
                  LastName:(NSString *) lastname
                  UserName:(NSString *) username
                     Email:(NSString *) email
                    Mobile:(NSString *) mobile
                  OldPasswork:(NSString *) oldpassword
               NewPassword:(NSString *) newPassword
                  Complete:(void (^)(NSString *))completed
                    Failed:(void (^) (NSString *))failed{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, @"update_profile.php"];
    NSDictionary *dicParams = @{
                                @"firstname":firstname,
                                @"lastname":lastname,
                                @"username":username,
                                @"email":email,
                                @"phone":mobile,
                                @"user_id":[MyGlobalData sharedData].userID,
                                @"hash":[MyGlobalData sharedData].deviceToken,
                                @"old_password":oldpassword,
                                @"new_password":newPassword};
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url
       parameters:dicParams
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              completed(responseObject);
              
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              failed(@"Network error!!!");
          }
     ];
}


-(void)SendDonateWithAmountString:(NSString *) amount
                         DonateID:(NSString *) donateid
                       DonateType:(NSString *) donateType
                   Complete:(void (^)(NSString *))completed
                     Failed:(void (^) (NSString *))failed{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, @"pay_deedio2inst.php"];
    NSDictionary *dicParams = @{
                                @"user_id":[MyGlobalData sharedData].userID,
                                @"hash":[MyGlobalData sharedData].deviceToken,
                                @"inst_id":donateid,
                                @"pay_type":donateType,
                                @"amount":amount};
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url
       parameters:dicParams
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              completed(responseObject);
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              failed(@"Network error!!!");
          }
     ];
}



-(void)PayWithCard:(NSString *) amount
          DonateID:(NSString *) donateid
          Complete:(void (^)(NSString *))completed
            Failed:(void (^) (NSString *))failed{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, @"pay_deedio2inst.php"];
    NSString *expireDate = [MyGlobalData sharedData].expirationDate;
    
    NSMutableString *value = [NSMutableString string];
    for (int i = 0; i < [expireDate length]; i++) {
        [value appendString:[expireDate substringWithRange:NSMakeRange(i,1)]];
        
        // After two characters append a slash.
        if ((i + 1) % 2 == 0 &&
            ([value length] < 3)) {
            [value appendString:@"/"];
        }
    }
    NSString *tmp = value;
    NSArray *components = [tmp componentsSeparatedByString:@"/"];
    NSString *month = [components objectAtIndex:0];
    NSString *year = [components objectAtIndex:1];
    NSString *aaa = [NSString stringWithFormat:@"20%@-%@", year, month];
    NSDictionary *dicParams = @{
                                @"user_id":[MyGlobalData sharedData].userID,
                                @"hash":[MyGlobalData sharedData].deviceToken,
                                @"inst_id":donateid,
                                @"pay_type":@"credit",
                                @"amount":amount,
                                @"card_number":[MyGlobalData sharedData].carnNumber,
                                @"exp_date":aaa,
                                @"card_code":[MyGlobalData sharedData].cvv
                                };
    NSLog(@"userid = %@", [MyGlobalData sharedData].userID);
    NSLog(@"carnNumber = %@", [MyGlobalData sharedData].carnNumber);
    NSLog(@"expirationDate = %@", aaa);
    NSLog(@"cvv = %@", [MyGlobalData sharedData].cvv);
    NSLog(@"donateid = %@", donateid);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url
       parameters:dicParams
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              completed(responseObject);
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              failed(@"Network error!!!");
          }
     ];
}


-(void)PayWithBank:(NSString *) amount
          DonateID:(NSString *) donateid
          Complete:(void (^)(NSString *))completed
            Failed:(void (^) (NSString *))failed{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, @"pay_deedio2inst.php"];
    NSDictionary *dicParams = @{
                                @"user_id":[MyGlobalData sharedData].userID,
                                @"hash":[MyGlobalData sharedData].deviceToken,
                                @"inst_id":donateid,
                                @"pay_type":@"bank",
                                @"amount":amount,
                                @"routing_no":[MyGlobalData sharedData].routingNumber,
                                @"account_no":[MyGlobalData sharedData].accountNumber,
                                @"bank_name":@"bank",
                                @"name_on_account":[MyGlobalData sharedData].accountNickname
                                };
    NSLog(@"userid = %@", [MyGlobalData sharedData].userID);
    NSLog(@"routing = %@", [MyGlobalData sharedData].routingNumber);
    NSLog(@"number = %@", [MyGlobalData sharedData].accountNumber);
    NSLog(@"nickname = %@", [MyGlobalData sharedData].accountNickname);
    NSLog(@"donateid = %@", donateid);
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url
       parameters:dicParams
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              completed(responseObject);
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              failed(@"Network error!!!");
          }
     ];
}

-(void)PayWithApplepay:(NSString *) amount
          DonateID:(NSString *) donateid
          Complete:(void (^)(NSString *))completed
            Failed:(void (^) (NSString *))failed{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, @"pay_deedio2inst.php"];
    NSDictionary *dicParams = @{
                                @"user_id":[MyGlobalData sharedData].userID,
                                @"hash":[MyGlobalData sharedData].deviceToken,
                                @"inst_id":donateid,
                                @"pay_type":@"applepay",
                                @"amount":amount,
                                @"card_number":[MyGlobalData sharedData].carnNumber,
                                @"exp_date":[MyGlobalData sharedData].expirationDate,
                                @"card_code":[MyGlobalData sharedData].cvv
                                };
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url
       parameters:dicParams
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              completed(responseObject);
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              failed(@"Network error!!!");
          }
     ];
}


-(void)PayWithPaypal:(NSString *) amount
          DonateID:(NSString *) donateid
          Complete:(void (^)(NSString *))completed
            Failed:(void (^) (NSString *))failed{
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, @"pay_deedio2inst.php"];
    NSDictionary *dicParams = @{
                                @"user_id":[MyGlobalData sharedData].userID,
                                @"hash":[MyGlobalData sharedData].deviceToken,
                                @"inst_id":donateid,
                                @"pay_type":@"paypal",
                                @"amount":amount
                                };
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:url
       parameters:dicParams
          success:^(AFHTTPRequestOperation *operation, id responseObject){
              completed(responseObject);
          }failure:^(AFHTTPRequestOperation *operation, NSError *error){
              failed(@"Network error!!!");
          }
     ];
}





@end
