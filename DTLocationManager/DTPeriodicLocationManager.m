//
//  DTPeriodicLocationManager.m
//  GeoTourist
//
//  Created by Denys Telezhkin on 16.05.14.
//  Copyright (c) 2014 MLSDev. All rights reserved.
//

#import "DTPeriodicLocationManager.h"

@implementation DTPeriodicLocationManager

-(void)processNewLocation:(CLLocation *)location
{
    self.completion(location,LocationResultTypeSuccess);
}

@end
