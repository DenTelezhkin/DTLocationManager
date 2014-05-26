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
    if (self.completion)
    {
       self.completion(location,LocationResultTypeSuccess);
    }
    [self stop];
}

-(void)timeoutReached
{
    if (self.completion)
    {
       self.completion(self.location,LocationResultTypeTimedOut);
    }
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