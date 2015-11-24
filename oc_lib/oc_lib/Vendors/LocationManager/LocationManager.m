
//
//  LocationManager.m
//  iSchool
//
//  Created by ligh on 13-10-14.
//
//

#import "LocationManager.h"
#import "MessageAlertView.h"

@interface LocationManager () <CLLocationManagerDelegate>
{
    UpdateToLocationBlock       _locationBlock;
    LocationFailBlock           _locationFailBlock;
}
@end

@implementation LocationManager


- (void)dealloc
{
    RELEASE_SAFELY(_locationBlock);
    RELEASE_SAFELY(_locationFailBlock);
}


/***
 火星坐标转换为百度坐标
 **/
-(CLLocation *) bd_decrypt:(CLLocation *) location
{
    double bd_lat = location.coordinate.latitude;
    double bd_lon = location.coordinate.longitude;
    const  double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    double gg_lon = z * cos(theta);
    double gg_lat = z * sin(theta);
    
    
    return [[CLLocation alloc] initWithLatitude:gg_lat longitude:gg_lon];
    
}


static id instance;
+ (id)defaultInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

-(void)startUpdatingLocationWithUpdateToLocationBlock:(UpdateToLocationBlock)locationBlock errorBlock:(LocationFailBlock)errorBlock
{
    
    [self startUpdatingLocationWithUpdateToLocationBlock:locationBlock errorBlock:errorBlock activityIndicator:NO];
  
}

-(void)startUpdatingLocationWithUpdateToLocationBlock:(UpdateToLocationBlock)locationBlock errorBlock:(LocationFailBlock)errorBlock activityIndicator:(BOOL)isShow
{
//    //如果已经定位到则使用上次定位的位置 因为只是使用城市信息  所以不必太精确
//    if(self.location)
//    {
//        locationBlock(self.location,nil);
//        return;
//    }
    
   
    RELEASE_SAFELY(_locationBlock);
    RELEASE_SAFELY(_locationFailBlock);
    _locationBlock = [locationBlock copy];
    _locationFailBlock = [errorBlock copy];
    
    //强制将delegate 置为自身 只有这样才能监听位置变化 并且调用block
    self.delegate = self;
    [self setDesiredAccuracy:kCLLocationAccuracyBest];
    [self startUpdatingLocation];
    
    

}

//SDK默认定位方法
-(void)startUpdatingLocation
{

    if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        if(_locationFailBlock)
        {
            _locationFailBlock(nil);
        }
        [BDKNotifyHUD showCryingHUDWithText:@"请启用定位服务"];
        //如果用户禁用了定位服务则定位失败直接返回
        return;
    }
   
    //IOS8定位 需要调用此方法
    if ([self respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self requestWhenInUseAuthorization];
    }
    
    [super startUpdatingLocation];
   
    if(!self.delegate)
    {
        self.delegate = self;
    }

}

//重写SDK停止定位方法 将block置为NULL 回收资源
-(void)stopUpdatingLocation
{
    [super stopUpdatingLocation];
    RELEASE_SAFELY(_locationBlock);
    RELEASE_SAFELY(_locationFailBlock);
}

/////////////////////////////////////////////////////////////////////////
#pragma mark CLLocationManagerDelegate
/////////////////////////////////////////////////////////////////////////\
//IOS8回调此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

    CLLocation *newLocation = [locations lastObject];
    newLocation = [self bd_decrypt:newLocation];
    
    if(_locationBlock)
    {
        _locationBlock(newLocation,newLocation);
    }
    
    [self stopUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
 

    if(_locationBlock)
    {
        _locationBlock([self bd_decrypt:newLocation],[self bd_decrypt:oldLocation]);
    }
    
    [self stopUpdatingLocation];
    
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    //定位失败
    if(_locationFailBlock)
    {
        _locationFailBlock(error);
    }
    [self stopUpdatingLocation];

    
}

- (void)locationManager:(CLLocationManager *)manager
monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error
{

    //定位失败
    if(_locationFailBlock)
    {
        _locationFailBlock(error);
    }
    [self stopUpdatingLocation];
}



- (void)locationManager:(CLLocationManager *)manager
didFinishDeferredUpdatesWithError:(NSError *)error
{
    
   
}

@end
