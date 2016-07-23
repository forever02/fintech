//
//  DonateObject.h
//  Deedio
//
//  Created by dev on 6/16/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DonateObject : NSObject

@property (nonatomic, strong) NSString *donateName;
@property (nonatomic, strong) NSString *donateId;
-(id)initWithDictionary:(NSDictionary *)dicParams;
-(id)initWithString:(NSString *)value;
-(NSString *)getStringOfItem;
@end
