//
//  NSOperation+Identifier.m
//  PMS
//
//  Created by ligh on 15/10/23.
//
//

#import "NSOperation+Identifier.h"

@implementation NSOperation (Identifier)

- (NSString *) identifier {
    
    return (NSString *)objc_getAssociatedObject(self, @selector(identifier));
}

- (void)setIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, @selector(identifier), identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
