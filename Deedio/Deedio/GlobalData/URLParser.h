//
//  URLParser.h
//  Deedio
//
//  Created by dev on 6/29/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLParser : NSObject{
    NSArray *variables;
}
@property (nonatomic, retain) NSArray *variables;

-(id)initWithURLString:(NSString *)url;
-(NSString *)valueForVariable:(NSString *)varName;

@end
