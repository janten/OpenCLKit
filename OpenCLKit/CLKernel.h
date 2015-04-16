//
//  CLKernel.h
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

@import Foundation;
@import OpenCL;

@class CLProgram;
@class CLKernelArgument;

@interface CLKernel : NSObject

@property (readonly) cl_kernel kernel;
@property (readonly) CLProgram *program;
@property (readonly) NSString *name;
@property (readonly) NSArray *arguments;

- (instancetype)initWithProgram:(CLProgram *)program kernel:(cl_kernel)kernel NS_DESIGNATED_INITIALIZER;
- (CLKernelArgument *)argumentNamed:(NSString *)name;

@end
