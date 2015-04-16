//
//  CLKernelArgument.h
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 16.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

@import Foundation;
@import OpenCL;

@class CLKernel;

@interface CLKernelArgument : NSObject

@property (readonly) cl_mem buffer;
@property (readonly) cl_uint index;
@property (readonly) cl_kernel_arg_access_qualifier accessQualifier;
@property (readonly) cl_kernel_arg_address_qualifier addressQualifier;
@property (readonly) cl_kernel_arg_type_qualifier typeQualifier;
@property (readonly) CLKernel *kernel;
@property NSData *data;
@property (readonly) NSString *typeName;
@property (readonly) NSString *name;

- (instancetype)initWithKernel:(CLKernel *)kernel argumentIndex:(cl_uint)index NS_DESIGNATED_INITIALIZER;

@end
