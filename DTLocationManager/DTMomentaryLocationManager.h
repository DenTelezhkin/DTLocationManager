//
// Created by Denys Telezhkin on 24.04.14.
// Copyright (c) 2014 MLSDev. All rights reserved.
//

#import "DTBaseLocationManager.h"

@interface DTMomentaryLocationManager : DTBaseLocationManager <LocationUpdating>

@property (nonatomic, assign) NSTimeInterval timeout;

@end