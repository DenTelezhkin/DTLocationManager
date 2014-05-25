//
// Created by Denys Telezhkin on 24.04.14.
// Copyright (c) 2014 MLSDev. All rights reserved.
//

#import "DTMomentaryLocationManager.h"

@interface DTMomentaryLocationManager () <CLLocationManagerDelegate>
@property (nonatomic, copy) LocationManagerCompletionBlock completion;
@property (nonatomic, strong) CLLocation * location;
@end

@implementation DTMomentaryLocationManager

- (id)init
{
    self = [super init];
    if (self)
    {
        self.timeout = 15;
    }
    return self;
}

- (void)startWithBlock:(LocationManagerCompletionBlock)completion
{
    [super startWithBlock:completion];

    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
    {
        if (self.timeout>0)
        {
            [self performSelector:@selector(timeoutReached)
                       withObject:nil
                       afterDelay:self.timeout];
        }
    }
}

-(void)processNewLocation:(CLLocation *)location
{
    self.completion(location,LocationResultTypeSuccess);
    [self stop];
}

-(void)timeoutReached
{
    self.completion(self.location,LocationResultTypeTimedOut);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [super locationManager:manager
didChangeAuthorizationStatus:status];
    
    if (status == kCLAuthorizationStatusAuthorized)
    {
        if (self.timeout>0)
        {
            [self performSelector:@selector(timeoutReached)
                       withObject:nil
                       afterDelay:self.timeout];
        }
    }
}

@end