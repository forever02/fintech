//
//  MyGlobalData.h
//  Deedio
//
//  Created by dev on 6/16/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DonateObject.h"

@interface MyGlobalData : NSObject
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, strong) NSString *userPassword;
@property (nonatomic, strong) NSString *userFirstName;
@property (nonatomic, strong) NSString *userLastName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userPhone;
@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) NSString *carnNumber;
@property (nonatomic, strong) NSString *expirationDate;
@property (nonatomic, strong) NSString *cvv;
@property (nonatomic, strong) NSString *zipCode;

@property (nonatomic, strong) NSString *routingNumber;
@property (nonatomic, strong) NSString *accountNumber;
@property (nonatomic, strong) NSString *accountType;
@property (nonatomic, strong) NSString *accountNickname;
@property int payMode;
@property NSTimer *timer;
@property bool resetPassword;
@property bool verify;

@property DonateObject *donateObj;

+ (MyGlobalData *)sharedData;
-(void)initialize;
- (void)setUserFirstName:(NSString *)userFirstName
            UserLastName:(NSString *)userLastName
            UserPassword:(NSString *)userPassword
               UserEmail:(NSString *)userEmail
         UserPhoneNumber:(NSString *)userPhone
                  UserID:(NSString *)userID;
- (void)setDeviceToken:(NSString *)deviceToken;
- (void)setUserID:(NSString *)userID;

- (void)setCardWithNumber:(NSString *)cardnumber
               expireDate:(NSString *)expiredate
                      cvv:(NSString *)cvv
                      zip:(NSString *)zip;
- (void)setBankWithNumber:(NSString *)routing
                  account:(NSString *)account
                     type:(NSString *)type
                 nickname:(NSString *)nick;
- (NSString *) md5:(NSString *) input;
-(void)setRememver:(int)isremember;
-(int)getRemember;
-(void)startTimer;
-(void)resetTimer;
@end
