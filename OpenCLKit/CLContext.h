//
//  CLContext.h
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

@import Foundation;
@import OpenCL;

@class CLDevice;
@class CLCommandQueue;

@interface CLContext : NSObject

@property (readonly) cl_context context;
@property (readonly) NSArray *devices;

- (instancetype)initWithDevice:(CLDevice *)device;

/**
 *  Create a OpenCL context for the given devices. All devices must belong to
 *  the same platform.
 *
 *  @param devices An array of CLDevice objects form a single CLPlatform
 *  instance.
 *
 *  @return A CLContext instance.
 */
- (instancetype)initWithDevices:(NSArray *)devices NS_DESIGNATED_INITIALIZER;
- (CLCommandQueue *)commandQueueForDevice:(CLDevice *)device;

@end
