//
//  ITTBaseModelObject.h
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataCacheManager.h"

@interface BaseModelObject :NSObject <NSCoding> {
    
}


/**
 *  根据json
 *
 *  @param data <#data description#>
 *
 *  @return <#return value description#>
 */
-(id)initWithDataDic:(NSDictionary*)data;

- (NSArray *) attributeKeys;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;
@end
