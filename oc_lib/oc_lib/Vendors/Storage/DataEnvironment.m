//
//  DataEnvironment.m
//  
//
//  Copyright 2010 itotem. All rights reserved.
//


#import "DataEnvironment.h"
#import "DataCacheManager.h"

@interface DataEnvironment()
- (void)restore;
- (void)registerMemoryWarningNotification;
@end
@implementation DataEnvironment

SINGLETON_M_ARC(DataEnvironment)

#pragma mark - lifecycle methods
- (id)init{
    self = [super init];
	if ( self) {
		[self restore];
        [self registerMemoryWarningNotification];
	}
	return self;
}

-(void)clearNetworkData{
    [[DataCacheManager sharedDataCacheManager] clearAllCache];
}


#pragma mark - public methods
- (void)clearCacheData{
    //clear cache data if needed
}

#pragma mark - private methods
- (void)restore{
    _urlRequestHost = Host_Url;
}
- (void)registerMemoryWarningNotification{
#if TARGET_OS_IPHONE
    // Subscribe to app events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clearCacheData)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];    
#ifdef __IPHONE_4_0
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] && device.multitaskingSupported){
        // When in background, clean memory in order to have less chance to be killed
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCacheData)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
#endif
#endif        
}

@end