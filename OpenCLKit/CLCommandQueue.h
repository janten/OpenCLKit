//
//  CLCommandQueue.h
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 15.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

@import Foundation;
@import OpenCL;

@class CLKernel;
@class CLKernelArgument;

@interface CLCommandQueue : NSObject

@property (readonly) cl_command_queue commandQueue;

- (instancetype)initWithCommandQueue:(cl_command_queue)queue NS_DESIGNATED_INITIALIZER;
- (void)enqueueKernel:(CLKernel *)kernel globalDimensions:(NSArray *)globalDimensions;
- (void)readDataForArgument:(CLKernelArgument *)argument;

@end
