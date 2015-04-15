//
//  CLKernel.m
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

#import "CLKernel.h"

@implementation CLKernel
@synthesize name = _name;
@synthesize arguments = _arguments;

- (instancetype)initWithProgram:(CLProgram *)program kernel:(cl_kernel)kernel {
	self = [super init];
	_program = program;
	_kernel = kernel;
	return self;
}

- (void)dealloc {
	clReleaseKernel(self.kernel);
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ (%@)", [super description], self.name];
}

#pragma mark - Properties
- (NSString *)name {
	if (_name == nil) {
		const int name_max = 1024;
		char name[name_max];
		clGetKernelInfo(self.kernel, CL_KERNEL_FUNCTION_NAME, name_max, name, NULL);
		_name = [NSString stringWithUTF8String:name];
	}
	
	return _name;
}

- (NSArray *)arguments {
	if (_arguments == nil) {
		cl_uint args_count;
		clGetKernelInfo(self.kernel, CL_KERNEL_NUM_ARGS, sizeof(args_count), &args_count, NULL);
		NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:args_count];
		
		for (cl_uint i = 0; i < args_count; i++) {
			const int arg_name_max = 1024;
			char arg_name[arg_name_max];
			clGetKernelArgInfo(self.kernel, i, CL_KERNEL_ARG_NAME, arg_name_max, arg_name, NULL);
			NSString *argumentName = [NSString stringWithUTF8String:arg_name];
			[arguments addObject:argumentName];
		}
		
		_arguments = [NSArray arrayWithArray:arguments];
	}
	
	return _arguments;
}



@end
