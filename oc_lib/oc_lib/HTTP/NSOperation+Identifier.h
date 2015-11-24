//
//  NSOperation+Identifier.h
//  PMS
//
//  Created by ligh on 15/10/23.
//
//

#import <Foundation/Foundation.h>

@interface NSOperation (Identifier)

/**
 *  定义operation的标示符 会根据此标示符 取消request
 *
 */
- (NSString *) identifier;
- (void)setIdentifier:(NSString *)identifier;

@end
