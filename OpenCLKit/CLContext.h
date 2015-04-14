//
//  CLContext.h
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

#import <Foundation/Foundation.h>
@import OpenCL;

@class CLDevice;

@interface CLContext : NSObject

@property (readonly) cl_context context;
@property (readonly) NSArray *devices;

- (instancetype)initWithDevice:(CLDevice *)device;
- (instancetype)initWithDevices:(NSArray *)devices NS_DESIGNATED_INITIALIZER;

@end