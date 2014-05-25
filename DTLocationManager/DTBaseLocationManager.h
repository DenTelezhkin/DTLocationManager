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

#import <CoreLocation/CoreLocation.h>

/**
 Protocol to receive location updates, that meet criteria.
 */
@protocol LocationUpdating <NSObject>

/**
 Process location, that meets predefined criteria.
 
 @param location CLLocation object.
 */
-(void)processNewLocation:(CLLocation *)location;

@end

typedef NS_ENUM(NSInteger,LocationResultType)
{
    LocationResultTypeFailure = 1, // Unavailable or denied access to location services
    LocationResultTypeTimedOut,
    LocationResultTypeSuccess
};

typedef void (^LocationManagerCompletionBlock)(CLLocation * location, LocationResultType result);

/**
 `DTBaseLocationManager` is a base class, that receives location updates and filters them by precision and timestamps. It then calls processNewLocation: method, that is expected to be overridden in subclasses.
 */

@interface DTBaseLocationManager : NSObject <CLLocationManagerDelegate>

/**
 Location manager, that is used. Default accuracy - kCLLocationAccuracyBest.
 */
@property (nonatomic, strong) CLLocationManager * manager;

/**
 Horizontal accuracy to achieve, in meters. Default value is 100 meters.
 */
@property (nonatomic, assign) CLLocationAccuracy desiredHorizontalAccuracy;

/**
 Maximum age of CLLocation timestamp. Default value is 300 seconds (5 minutes).
 */
@property (nonatomic, assign) NSTimeInterval timestampMaxAge;

/**
 Completion block to be called, when location is identified. It is also called with nil result, when location services are disabled or not available on the device.
 */
@property (nonatomic, copy) LocationManagerCompletionBlock completion;

/**
 Optional delegate, that gets all `CLLocationManagerDelegate` methods trampolined.
 */
@property (nonatomic, weak) id <CLLocationManagerDelegate> delegate;

/**
 Start updating location with completion block.
 
 @param completion completion block to call
 */
-(void)startWithBlock:(LocationManagerCompletionBlock)completion;

/**
 Stop location updates.
 */
-(void)stop;

@end
