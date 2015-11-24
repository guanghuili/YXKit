//
//  ITTBaseModelObject.m
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseModelObject.h"
#import <objc/runtime.h>

@implementation BaseModelObject


-(id)initWithDataDic:(NSDictionary*)data{
    if (self = [super init])
    {
        [self parseJSONDic:data];
    }
    return self;
}


//解析json数据将json数据封装成model
-(void) parseJSONDic:(NSDictionary *) data
{
    
    NSArray *keys = [data allKeys];
    
    for(NSString *key in keys)
    {
        SEL sel = [self getSetterSelWithAttibuteName:key];
        
        if ([self respondsToSelector:sel])
        {
            id value = data[key];
            if ([value isKindOfClass:[NSNumber class]]) {
                value = [value stringValue];
            }else if([value isKindOfClass:[NSNull class]]){
                value = nil;
            }
            
            [self performSelectorOnMainThread:sel
                                   withObject:value
                                waitUntilDone:[NSThread isMainThread]];
        }
    }
}

-(NSArray *)attributeKeys
{
    unsigned count;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        //读取列名即属性名
        NSString *column = [NSString stringWithUTF8String:property_getName(properties[i])];
        [keys addObject:column];
        
    }
    
    return keys;
}



-(SEL) getSetterSelWithAttibuteName:(NSString*)attributeName
{
    NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
    NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
    return NSSelectorFromString(setterSelStr);
}

- (NSString *)customDescription
{
    return nil;
}

- (NSString *)description
{
    NSMutableString *attrsDesc = [NSMutableString stringWithCapacity:100];
    
    NSArray *keys = [self attributeKeys];
    if (keys == nil) {
        return@"empty desc";
    }
    
    for (id attributeName in keys)
    {
        SEL getSel = NSSelectorFromString(attributeName);
        if ([self respondsToSelector:getSel]) {
            NSMethodSignature *signature = nil;
            signature = [self methodSignatureForSelector:getSel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:getSel];
            NSObject *valueObj = nil;
            [invocation invoke];
            [invocation getReturnValue:&valueObj];
            if (valueObj) {
                [attrsDesc appendFormat:@" [%@=%@] ",attributeName,valueObj];
            }else {
                [attrsDesc appendFormat:@" [%@=nil] ",attributeName];
            }
            
        }
        
    }
    
    NSString *customDesc = [self customDescription];
    NSString *desc;
    
    if (customDesc && [customDesc length] > 0 ) {
        desc = [NSString stringWithFormat:@"%@:{%@,%@}",[self class],attrsDesc,customDesc];
    }else {
        desc = [NSString stringWithFormat:@"%@:{%@}",[self class],attrsDesc];
    }
    
    return desc;
}


- (id)initWithCoder:(NSCoder *)decoder
{
    if( self = [super init] )
    {
        NSArray *keys = [self attributeKeys];
        if (keys == nil) {
            return self;
        }
        
        for (id attributeName in keys) {
            
            SEL sel = [self getSetterSelWithAttibuteName:attributeName];
            if ([self respondsToSelector:sel]) {
                id obj = [decoder decodeObjectForKey:attributeName];
                [self performSelectorOnMainThread:sel
                                       withObject:obj
                                    waitUntilDone:[NSThread isMainThread]];
            }
        }
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSArray *keys = [self attributeKeys];
    if (keys == nil)
    {
        return;
    }
    
    for (id attributeName in keys)
    {
        SEL getSel = NSSelectorFromString(attributeName);
        if ([self respondsToSelector:getSel]) {
            NSMethodSignature *signature = nil;
            signature = [self methodSignatureForSelector:getSel];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:getSel];
            NSObject *valueObj = nil;
            [invocation invoke];
            [invocation getReturnValue:&valueObj];
            
            if (valueObj) {
                [encoder encodeObject:valueObj forKey:attributeName];
            }
            
        }
    }
    
}
- (NSData*)getArchivedData
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}
@end
