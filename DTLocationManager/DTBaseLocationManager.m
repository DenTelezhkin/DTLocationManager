//  DTLocationManager
//
//  Created by Denys Telezhkin on 16.05.14.
//  Copyright (c) 2014 MLSDev. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "DTBaseLocationManager.h"

@interface DTBaseLocationManager ()
@property (nonatomic, strong) CLLocation * location;
@end

@implementation DTBaseLocationManager

- (id)init
{
    self = [super init];
    if (self)
    {
        self.desiredHorizontalAccuracy = 100;
        self.timestampMaxAge = 300;
    }
    return self;
}

-(void)dealloc
{
    [self stop];
}

- (CLLocationManager *)manager
{
    if (!_manager)
    {
        _manager = [CLLocationManager new];
        _manager.delegate = self;
    }
    return _manager;
}

#pragma mark - location authorization

-(BOOL)locationAuthorized
{
#if TARGET_OS_IPHONE
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
            [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse);  
#elif TARGET_OS_MAC
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
#endif
}

#pragma mark - location processing

- (void)startWithBlock:(LocationManagerCompletionBlock)completion
{
    NSParameterAssert(completion);
    
    self.completion = completion;
    if ([CLLocationManager locationServicesEnabled]){
        [self.manager startUpdatingLocation];
    }
    else {
        completion(nil,LocationResultTypeFailure);
    }
}

-(void)stop
{
    [self.manager stopUpdatingLocation];
    self.completion = nil;
}

- (void)processNewLocation:(CLLocation *)location
{
    // Implement in subclasses
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate locationManager:manager didUpdateLocations:locations];
    }
    
    CLLocation * location = locations.lastObject;
    if (location.horizontalAccuracy < 0)
    {
        //invalid location
        return;
    }
    
    if (!self.location)
    {
        self.location = location;
    }
    
    if (self.location.horizontalAccuracy > location.horizontalAccuracy)
    {
        // New location is more precise
        self.location = location;
    }
    
    NSTimeInterval timestamp = -[[location timestamp] timeIntervalSinceNow];
    if (self.desiredHorizontalAccuracy>=location.horizontalAccuracy && self.timestampMaxAge>=timestamp)
    {
        [self processNewLocation:location];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate locationManager:manager didFailWithError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate locationManager:manager didChangeAuthorizationStatus:status];
    }
    switch(status){
        case kCLAuthorizationStatusNotDetermined:break;
            
        case kCLAuthorizationStatusRestricted:
            self.completion(nil,LocationResultTypeFailure);
            [self stop];
            break;
        case kCLAuthorizationStatusDenied:
            self.completion(nil,LocationResultTypeFailure);
            [self stop];
            break;
            
#if TARGET_OS_IPHONE
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
#elif TARGET_OS_MAC
        case kCLAuthorizationStatusAuthorized:
#endif
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate locationManager:manager didUpdateHeading:newHeading];
    }
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    if ([self.delegate respondsToSelector:_cmd])
    {
        return [self.delegate locationManagerShouldDisplayHeadingCalibration:manager];
    }
    return NO;
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate locationManager:manager didEnterRegion:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate locationManager:manager didExitRegion:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate locationManager:manager monitoringDidFailForRegion:region withError:error];
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate locationManager:manager didStartMonitoringForRegion:region];
    }
}

- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate locationManagerDidPauseLocationUpdates:manager];
    }
}

- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate locationManagerDidResumeLocationUpdates:manager];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate locationManager:manager didFinishDeferredUpdatesWithError:error];
    }
}

#if TARGET_OS_IPHONE

// These methods are only available for iOS

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate locationManager:manager
                     didDetermineState:state
                             forRegion:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate locationManager:manager didRangeBeacons:beacons inRegion:region];
    }
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate locationManager:manager rangingBeaconsDidFailForRegion:region withError:error];
    }
}
#endif

@end
