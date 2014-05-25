//
//  BaseLocationManager.h
//  GeoTourist
//
//  Created by Denys Telezhkin on 16.05.14.
//  Copyright (c) 2014 MLSDev. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@protocol LocationUpdating <NSObject>

-(void)processNewLocation:(CLLocation *)location;

@end

typedef NS_ENUM(NSInteger,LocationResultType)
{
    LocationResultTypeFailure = 1, // Unavailable or denied access to location services
    LocationResultTypeTimedOut,
    LocationResultTypeSuccess
};

typedef void (^LocationManagerCompletionBlock)(CLLocation * location, LocationResultType result);

@interface DTBaseLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager * manager;
@property (nonatomic, assign) CLLocationAccuracy desiredHorizontalAccuracy;
@property (nonatomic, assign) NSTimeInterval timestampMaxAge;
@property (nonatomic, copy) LocationManagerCompletionBlock completion;
@property (nonatomic, weak) id <CLLocationManagerDelegate> delegate;

-(void)startWithBlock:(LocationManagerCompletionBlock)completion;

-(void)stop;

@end
