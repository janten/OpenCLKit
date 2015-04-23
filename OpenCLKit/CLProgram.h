//
//  CLProgram.h
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

@import Foundation;
@import OpenCL;

@class CLContext;
@class CLDevice;
@class CLKernel;

@interface CLProgram : NSObject

@property (readonly) CLContext *context;
@property (readonly) NSArray *kernels;

/**
 *  Creates a program from the given source code by compiling and building all
 *  kernels found in the code for all devices in the given context.
 *
 *  @param context A context containing all the devices you want to run this
 *  program on.
 *  @param source  The program source in OpenCL C.
 *
 *  @return A properly initialized CLProgram instance.
 */
- (instancetype)initWithContext:(CLContext *)context source:(NSString *)source NS_DESIGNATED_INITIALIZER;

/**
 *  Convenince method to load source code from a given URL. This method calls
 *  through to initWithContext:source:
 */
- (instancetype)initWithContext:(CLContext *)context URL:(NSURL *)URL;

/**
 *  Returns the compiler and linker output for this program on the given device.
 *  The device must be associated with this program's context.
 *
 *  @param device The device for which to fetch the build log.
 *
 *  @return The build log as returned by the OpenCL implementation.
 */
- (NSString *)buildLogForDevice:(CLDevice *)device;
- (cl_build_status)buildStatusForDevice:(CLDevice *)device;

/**
 *  Returns a single kernel with the given name from this program or nil if no
 *  kernel matching the name could be found.
 *
 *  @param name The kernel's name as found in the source code with all 
 *  whitespace removed.
 *
 *  @return The kernel.
 */
- (CLKernel *)kernelNamed:(NSString *)name;

@end
