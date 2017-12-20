//
//  CLCommandQueue.h
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 15.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

@import Foundation;
@import OpenCL;

@class CLContext;
@class CLDevice;
@class CLKernel;
@class CLKernelArgument;
@class CLBuffer;

/**
 *  Use CLCommandQueue to execute execute operations on a CLDevice. Multiple
 *  command queues can exists for a single device but only one device can be
 *  attached to each command queue. The CLKernel and CLBuffer objects you use
 *  on a command queue must belong to the same CLContext as the device.
 *
 *  Kernels and data transfer tasks in the same CLCommandQueue will always be
 *  executed in the same order they were enqueued, i.e. each operation waits for
 *  the preceding operation to finish. Multiple command queues using the same
 *  device may be executed in parallel, depending on the device hardware
 *  capabilities and OpenCL implementation.
 */
@interface CLCommandQueue : NSObject

@property (readonly) cl_command_queue commandQueue;
@property (readonly) CLDevice *device;
@property (readonly, weak) CLContext *context;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithDevice:(CLDevice *)device context:(CLContext *)context NS_DESIGNATED_INITIALIZER;

/**
 *  A convenience method for calling 
 *  enqueueKernel:globalDimensions:localDimensions: without a local work size.
 */
- (void)enqueueKernel:(CLKernel *)kernel globalDimensions:(NSArray *)globalDimensions;

/**
 *  Enqueue a kernel for execution. All arguments of the kernel need to be set
 *  before calling this method. This is a non-blocking call that will return
 *  immediately, execution of the kernel will happen in the background. This
 *  call also triggers the copying of argument data to the compute device.
 *
 *  @param kernel           The kernel to execute.
 *  @param globalDimensions Global work size. Must be an array of 1…3 NSNumbers.
 *  @param localDimensions  Local work size or nil. OpenCL will automatically
 *  determine a local work size if this is nil. If you specify an explicit local
 *  work size it must be an array of the same amount of NSNumbers as 
 *  globalDimensions.
 */
- (void)enqueueKernel:(CLKernel *)kernel globalDimensions:(NSArray *)globalDimensions localDimensions:(NSArray *)localDimensions;

/**
 *  Perform a blocking read of the data associated with the given buffer. Will
 *  block until all previously enqueued operations are finished and the data has
 *  been copied back to the host.
 *
 *  @param buffer The buffer for which to fetch data from the compute device.
 */
- (NSData *)dataFromBuffer:(CLBuffer *)buffer;

@end
