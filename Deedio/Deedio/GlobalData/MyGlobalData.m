//
//  MyGlobalData.m
//  Deedio
//
//  Created by dev on 6/16/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "MyGlobalData.h"
#import <CommonCrypto/CommonDigest.h>

#define kLoginRemember      @"loginremember"
#define kDeviceToken        @"devicetoken"
#define kUserFirstName      @"ufirst"
#define kUserLastName       @"ulast"
#define kUserName           @"uname"
#define kUserPassword       @"upassword"
#define kUserEmail          @"uemail"
#define kUserPhoneNumber    @"uphone"
#define kUserID             @"uid"

#define kCardNumber         @"cardnumber"
#define kCardDate           @"carddate"
#define kCardcvv            @"cardcvv"
#define kCardNzip           @"cardzip"
#define kBankRouting        @"bankrouting"
#define kBankAccount        @"bankaccount"
#define kBankType           @"banktype"
#define kBankNickname       @"banknickname"

static MyGlobalData *_sharedData;
@implementation MyGlobalData

+ (MyGlobalData *)sharedData {
    if (_sharedData == nil)
        _sharedData = [[MyGlobalData alloc] init];
    return _sharedData;
}
//
//@property (nonatomic, strong) NSString *deviceToken;
//@property (nonatomic, strong) NSString *userPassword;
//@property (nonatomic, strong) NSString *userFirstName;
//@property (nonatomic, strong) NSString *userLastName;
//@property (nonatomic, strong) NSString *userName;
//@property (nonatomic, strong) NSString *userEmail;
//@property (nonatomic, strong) NSString *userPhone;
- (id)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *userName = [userDefault objectForKey:kUserName];
        if (userName != nil && ![userName isEqualToString:@""])
        {
            _userName = [NSString stringWithFormat:@"%@", userName];
        }
        
        NSString *firstName = [userDefault objectForKey:kUserFirstName];
        if (firstName != nil && ![firstName isEqualToString:@""])
        {
            _userFirstName = [NSString stringWithFormat:@"%@", firstName];
        }
        
        NSString *lastName = [userDefault objectForKey:kUserLastName];
        if (lastName != nil && ![lastName isEqualToString:@""])
        {
            _userLastName = [NSString stringWithFormat:@"%@", lastName];
        }
        
        NSString *password = [userDefault objectForKey:kUserPassword];
        if (password != nil && ![password isEqualToString:@""])
        {
            _userPassword = [NSString stringWithFormat:@"%@", password];
        }
        
        NSString *email = [userDefault objectForKey:kUserEmail];
        if (email != nil && ![email isEqualToString:@""])
        {
            _userEmail = [NSString stringWithFormat:@"%@", email];
        }
        NSString *phone = [userDefault objectForKey:kUserPhoneNumber];
        if (phone != nil && ![phone isEqualToString:@""])
        {
            _userPhone = [NSString stringWithFormat:@"%@", phone];
        }
        NSString *devicetoken = [userDefault objectForKey:kDeviceToken];
        if (devicetoken != nil && ![devicetoken isEqualToString:@""])
        {
            _deviceToken = [NSString stringWithFormat:@"%@", devicetoken];
        }
        NSString *userid = [userDefault objectForKey:kUserID];
        if (userid != nil && ![userid isEqualToString:@""])
        {
            _userID = [NSString stringWithFormat:@"%@", userid];
        }
        
        NSString *cardnum = [userDefault objectForKey:kCardNumber];
        if (cardnum != nil && ![cardnum isEqualToString:@""])
        {
            _carnNumber = [NSString stringWithFormat:@"%@", cardnum];
        }else{
            _carnNumber = @"";
        }
        
        NSString *carddate = [userDefault objectForKey:kCardDate];
        if (carddate != nil && ![carddate isEqualToString:@""])
        {
            _expirationDate = [NSString stringWithFormat:@"%@", carddate];
        }
        
        NSString *cvv = [userDefault objectForKey:kCardcvv];
        if (cvv != nil && ![cvv isEqualToString:@""])
        {
            _cvv = [NSString stringWithFormat:@"%@", cvv];
        }
        
        NSString *zip = [userDefault objectForKey:kCardNzip];
        if (zip != nil && ![zip isEqualToString:@""])
        {
            _zipCode = [NSString stringWithFormat:@"%@", zip];
        }
        
        
        NSString *routing = [userDefault objectForKey:kBankRouting];
        if (routing != nil && ![routing isEqualToString:@""])
        {
            _routingNumber = [NSString stringWithFormat:@"%@", routing];
        }else{
            _routingNumber = @"";
        }
        
        NSString *account = [userDefault objectForKey:kBankAccount];
        if (account != nil && ![account isEqualToString:@""])
        {
            _accountNumber = [NSString stringWithFormat:@"%@", account];
        }else{
            _accountNumber = @"";
        }
        
        NSString *type = [userDefault objectForKey:kBankType];
        if (type != nil && ![type isEqualToString:@""])
        {
            _accountType = [NSString stringWithFormat:@"%@", type];
        }
        
        NSString *nickname = [userDefault objectForKey:kBankNickname];
        if (nickname != nil && ![nickname isEqualToString:@""])
        {
            _accountNickname = [NSString stringWithFormat:@"%@", nickname];
        }

    }
    return self;
}
-(void)initialize
{
    _carnNumber = @"";
    _expirationDate = @"";
    _cvv = @"";
    _zipCode = @"";
    _routingNumber = @"";
    _accountNumber = @"";
    _accountType = @"";
    _accountNickname = @"";
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _carnNumber] forKey:kCardNumber];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _expirationDate] forKey:kCardDate];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _cvv] forKey:kCardcvv];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _zipCode] forKey:kCardNzip];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _routingNumber] forKey:kBankRouting];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _accountNumber] forKey:kBankAccount];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _accountType] forKey:kBankType];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _accountNickname] forKey:kBankNickname];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setUserFirstName:(NSString *)userFirstName
            UserLastName:(NSString *)userLastName
            UserPassword:(NSString *)userPassword
               UserEmail:(NSString *)userEmail
         UserPhoneNumber:(NSString *)userPhone
                  UserID:(NSString *)userID
{
    _userFirstName = userFirstName;
    _userLastName = userLastName;
    _userEmail = userEmail;
    _userPhone = userPhone;
    _userPassword = userPassword;
    _userID = userID;
    _userName = [NSString stringWithFormat:@"%@%@", userFirstName, userLastName];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _userFirstName] forKey:kUserFirstName];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _userLastName] forKey:kUserLastName];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _userName] forKey:kUserName];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _userEmail] forKey:kUserEmail];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _userPassword] forKey:kUserPassword];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _userPhone] forKey:kUserPhoneNumber];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _userID] forKey:kUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setRememver:(int)isremember
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", isremember] forKey:kLoginRemember];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(int)getRemember{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    int isrember = [[userDefault objectForKey:kLoginRemember] intValue];
    return isrember;
}
- (void)setDeviceToken:(NSString *)deviceToken
{
    _deviceToken = deviceToken;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _deviceToken] forKey:kDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setUserID:(NSString *)userID
{
    _userID = userID;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _userID] forKey:kUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setCardWithNumber:(NSString *)cardnumber
               expireDate:(NSString *)expiredate
                      cvv:(NSString *)cvv
                      zip:(NSString *)zip
{
    _carnNumber = cardnumber;
    _expirationDate = expiredate;
    _cvv = cvv;
    _zipCode = zip;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _carnNumber] forKey:kCardNumber];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _expirationDate] forKey:kCardDate];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _cvv] forKey:kCardcvv];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _zipCode] forKey:kCardNzip];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setBankWithNumber:(NSString *)routing
               account:(NSString *)account
                      type:(NSString *)type
                      nickname:(NSString *)nick
{
    _routingNumber = routing;
    _accountNumber = account;
    _accountType = type;
    _accountNickname = nick;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _routingNumber] forKey:kBankRouting];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _accountNumber] forKey:kBankAccount];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _accountType] forKey:kBankType];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", _accountNickname] forKey:kBankNickname];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


-(void)startTimer{    
    _timer = [NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(myTicker) userInfo:nil repeats:NO];
}
-(void)myTicker{
    [[NSNotificationCenter defaultCenter ]postNotificationName:@"logout" object:nil];
}
-(void)resetTimer{
    if(_timer){
        [_timer invalidate];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(myTicker) userInfo:nil repeats:NO];
}
@end
