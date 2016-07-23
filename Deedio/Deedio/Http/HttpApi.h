//
//  HttpApi.h
//  Deedio
//
//  Created by dev on 6/16/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define SERVER_API_URL @"http://192.168.3.60/deedio/api/"
//#define SERVER_API_URL @"http://52.37.98.78/deedio/api/"
#define SERVER_API_URL @"http://52.37.98.78/deedio/api_new/"
@interface HttpApi : NSObject

+(id)sharedInstance;
-(void)SignUpWithFirstName:(NSString *) firstname
                  LastName:(NSString *) lastname
                  UserName:(NSString *) username
                     Email:(NSString *) email
                    Mobile:(NSString *) mobile
                  Passwork:(NSString *) password
                  Complete:(void (^)(NSString *))completed
                    Failed:(void (^) (NSString *))failed;


-(void)LoginWithUserName:(NSString *) username
                Password:(NSString *) password
                Complete:(void (^)(NSString *))completed
                  Failed:(void (^) (NSString *))failed;

-(void)ForgetPasswordWithEmail:(NSString *) email
                      Complete:(void (^)(NSString *))completed
                        Failed:(void (^) (NSString *))failed;
-(void)ResetPasswordWithEmail:(NSString *) email
                     Password:(NSString *) password
                     Complete:(void (^)(NSString *))completed
                       Failed:(void (^) (NSString *))failed;

-(void)VerifyWithEmail:(NSString *) email
              Complete:(void (^)(NSString *))completed
                Failed:(void (^) (NSString *))failed;
-(void)GetDonatesWithString:(NSString *) search
                   Complete:(void (^)(NSString *))completed
                     Failed:(void (^) (NSString *))failed;

-(void)UpdateWithFirstName:(NSString *) firstname
                  LastName:(NSString *) lastname
                  UserName:(NSString *) username
                     Email:(NSString *) email
                    Mobile:(NSString *) mobile
               OldPasswork:(NSString *) oldpassword
               NewPassword:(NSString *) newPassword
                  Complete:(void (^)(NSString *))completed
                    Failed:(void (^) (NSString *))failed;

-(void)SendDonateWithAmountString:(NSString *) amount
                         DonateID:(NSString *) donateid
                       DonateType:(NSString *) donateType
                         Complete:(void (^)(NSString *))completed
                           Failed:(void (^) (NSString *))failed;

//card

-(void)PayWithCard:(NSString *) amount
          DonateID:(NSString *) donateid
          Complete:(void (^)(NSString *))completed
            Failed:(void (^) (NSString *))failed;

//bank
-(void)PayWithBank:(NSString *) amount
          DonateID:(NSString *) donateid
          Complete:(void (^)(NSString *))completed
            Failed:(void (^) (NSString *))failed;

//applepay
-(void)PayWithApplepay:(NSString *) amount
              DonateID:(NSString *) donateid
              Complete:(void (^)(NSString *))completed
                Failed:(void (^) (NSString *))failed;

//paypal

-(void)PayWithPaypal:(NSString *) amount
            DonateID:(NSString *) donateid
            Complete:(void (^)(NSString *))completed
              Failed:(void (^) (NSString *))failed;
@end
