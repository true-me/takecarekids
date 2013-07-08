//
//  DataCheck.m
//  Discuz2
//
//  Created by rexshi on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataCheck.h"

@implementation DataCheck

+ (BOOL) isValidString:(id)input
{
    if (!input) {
        return NO;
    }
    
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    
    if (![input isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ([input isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL) isValidDictionary:(id)input
{
    if (!input) {
        return NO;
    }
    
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    
    if (![input isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    
    if ([input count] <= 0) {
        return NO;
    }
    
    return YES;
}

+ (BOOL) isValidArray:(id)input
{
    if (!input) {
        return NO;
    }
    
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    
    if (![input isKindOfClass:[NSArray class]]) {
        return NO;
    }
    
    if ([input count] <= 0) {
        return NO;
    }
    
    return YES;
}

//利用正则表达式验证

+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
@end
