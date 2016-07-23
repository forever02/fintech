//
//  DonateObject.m
//  Deedio
//
//  Created by dev on 6/16/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import "DonateObject.h"

@implementation DonateObject

-(id)initWithDictionary:(NSDictionary *)dicParams{
    DonateObject *donateitem = [[DonateObject alloc] init];
    donateitem.donateId = [dicParams objectForKey:@"id"];
    donateitem.donateName = [dicParams objectForKey:@"legal_name"];
    return donateitem;
}
-(id)initWithString:(NSString *)value{
    DonateObject *donateitem = [[DonateObject alloc] init];
    return donateitem;
}
-(NSString *)getStringOfItem{
    return @"";
}

@end
