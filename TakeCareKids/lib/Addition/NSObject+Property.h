//
//  NSObject+Property.h
//   
//
//  Created on 12-12-15.
//
//
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

@interface NSObject (Property)
- (NSArray *)  getPropertyList;
- (NSArray *)  getPropertyList: (Class)clazz;
- (NSString *) tableSql:(NSString *)tablename;
- (NSString *) tableSql:(NSString *)tablename withPriKey:(NSString *) priKey;
- (NSString *) tableSql;
- (NSDictionary *)dictionaryFromProperties;
- (id)initWithDictionary:(NSDictionary *)dict;
- (NSString *) getClassName;
@end
