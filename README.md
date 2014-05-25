DTLocationManager
=================

DTLocationManager is simple and lightweight wrapper for CLLocationManager API. It encapsulates filters for 

* Horizontal accuracy
* Location timestamp

### Where am I?

Often you'll need to get current user location *once*. You can use `DTMomentaryLocationManager` for this:

```objective-c
    self.locationManager = [DTMomentaryLocationManager new];
    __weak typeof(self) weakSelf = self;
    [self.locationManager startWithBlock:^(CLLocation *location, LocationResultType result) {
        switch (result) {
            case LocationResultTypeFailure:
                // Failed to get location, presumably services disabled, or hardware does not have GPS
                break;
            case LocationResultTypeTimedOut:
                // Criterias were not met in the desired time, but best location we got is in location variable
                break;
            case LocationResultTypeSuccess:
                // Got location
                break;
        }
    }];
```

Defaults used:

* horizontalAccuracy - 100 meters
* maximum timestamp age - 5 minutes

You can change them, however you like

```objective-c
self.locationManager.desiredHorizontalAccuracy = 50;
self.locationManager.timestampMaxAge = 120;
```

### Where am I over time?

Sometimes you'll want location updates to be received over time. The API is similar, but we'll use `DTPeriodicLocationManager` for this.

```objective-c
    self.locationManager = [DTPeriodicLocationManager new];
    __weak typeof(self) weakSelf = self;
    [self.locationManager startWithBlock:^(CLLocation *location, LocationResultType result) {
        switch (result) {
            case LocationResultTypeFailure:
                // Failed to get location, presumably services disabled, or hardware does not have GPS
                break;
            case LocationResultTypeSuccess:
                // Got location
                break;
        }
    }];
```

Completion block will be called continuously, until you stop location updates by calling
```objective-c
[self.locationManager stop];
```

### Design decisions

Most of location managers available on GitHub are cumbersome, or are built using Singleton pattern. The pattern is fine, but CLLocationManager was never meant to be used as a singleton. Which is why this location manager does not force you to use singleton pattern, if you need to get location updates.

Another thing to note is that all CLLocationManagerDelegate methods are trampolined to optional delegate property on DTBaseLocationManager. So if you need heading, iBeacon, or some other delegate methods, you'll be able to implement them in another object without any trouble.

### Requirements

* iOS 6 and higher
* Mac OS Mavericks (10.9) and higher
* ARC

### Installation

Install using Cocoapods,

    pod 'DTLocationManager', '~> 0.1.0'
