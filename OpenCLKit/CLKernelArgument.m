//
//  CLKernelArgument.m
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 16.04.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

#import "CLKernelArgument.h"
#import "CLKernel.h"
#import "CLProgram.h"
#import "CLContext.h"
#import "CLUtilities.h"
#import "CLBuffer.h"

@interface CLKernelArgument ()

@property (readwrite, strong) CLBuffer *buffer;

@end

@implementation CLKernelArgument

@synthesize index = _index;
@synthesize kernel = _kernel;
@synthesize name = _name;
@synthesize typeName = _typeName;

- (instancetype)initWithKernel:(CLKernel *)kernel argumentIndex:(cl_uint)index {
	self = [super init];
	_kernel = kernel;
	_index = index;
	return self;
}

- (void)dealloc {
	NSLog(@"Dealloc: %@", [self description]);
}

- (NSString *)description {
	NSString *addressQualifierString = nil;
	
	switch (self.addressQualifier) {
		case CL_KERNEL_ARG_ADDRESS_CONSTANT:
			addressQualifierString = @"constant";
			break;
		case CL_KERNEL_ARG_ADDRESS_GLOBAL:
			addressQualifierString = @"global";
			break;
		case CL_KERNEL_ARG_ADDRESS_LOCAL:
			addressQualifierString = @"local";
			break;
		case CL_KERNEL_ARG_ADDRESS_PRIVATE:
		default:
			addressQualifierString = @"private";
			break;
	}
	
	NSString *accessQualifierString = nil;

	switch (self.accessQualifier) {
		case CL_KERNEL_ARG_ACCESS_NONE:
			accessQualifierString = @"";
			break;
		case CL_KERNEL_ARG_ACCESS_READ_ONLY:
			accessQualifierString = @"readonly";
			break;
		case CL_KERNEL_ARG_ACCESS_READ_WRITE:
			accessQualifierString = @"readwrite";
			break;
		case CL_KERNEL_ARG_ACCESS_WRITE_ONLY:
			accessQualifierString = @"writeonly";
			break;
		default:
			accessQualifierString = @"";
			break;
	}
	
	NSMutableArray *typeQualifierStrings = [NSMutableArray arrayWithCapacity:4];

	if (self.typeQualifier & CL_KERNEL_ARG_TYPE_CONST) {
		[typeQualifierStrings addObject:@"const"];
	}

	if (self.typeQualifier & CL_KERNEL_ARG_TYPE_VOLATILE) {
		[typeQualifierStrings addObject:@"volatile"];
	}

	if (self.typeQualifier & CL_KERNEL_ARG_TYPE_RESTRICT) {
		[typeQualifierStrings addObject:@"restrict"];
	}

	NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	NSString *typeQualifierString = [[typeQualifierStrings componentsJoinedByString:@" "] stringByTrimmingCharactersInSet:whitespaceSet];
	NSArray *typeParts = @[accessQualifierString, addressQualifierString, typeQualifierString, self.typeName, self.name];
	NSString *typeString = [[typeParts componentsJoinedByString:@" "] stringByTrimmingCharactersInSet:whitespaceSet];
	return [NSString stringWithFormat:@"%@ (%@)", [super description], typeString];
}

#pragma mark - Value handling
- (void)setValueWithBuffer:(CLBuffer *)buffer {
    self.buffer = buffer;
    cl_mem cl_buffer = self.buffer.buffer;
    cl_int error = clSetKernelArg(self.kernel.kernel, self.index, sizeof(cl_mem), &cl_buffer);
    [CLUtilities checkError:error message:@"Set kernel argument with buffer"];
}

- (void)setValueWithData:(NSData *)data {
    CLBuffer *buffer = [[CLBuffer alloc] initWithContext:self.kernel.program.context
                                                    data:data];
    [self setValueWithBuffer:buffer];
}

- (void)setValueWithBytes:(const void *)value length:(NSUInteger)length {
    self.buffer = nil;
    cl_int error = clSetKernelArg(self.kernel.kernel, self.index, length, value);
    [CLUtilities checkError:error message:@"Set kernel argument with bytes"];
}

#pragma mark - Properties
- (cl_kernel_arg_access_qualifier)accessQualifier {
	cl_kernel_arg_access_qualifier qualifier;
	clGetKernelArgInfo(self.kernel.kernel,
					   self.index,
					   CL_KERNEL_ARG_ACCESS_QUALIFIER,
					   sizeof(qualifier),
					   &qualifier,
					   NULL);
	return qualifier;
}

- (cl_kernel_arg_address_qualifier)addressQualifier {
	cl_kernel_arg_address_qualifier qualifier;
	clGetKernelArgInfo(self.kernel.kernel,
					   self.index,
					   CL_KERNEL_ARG_ADDRESS_QUALIFIER,
					   sizeof(qualifier),
					   &qualifier,
					   NULL);
	return qualifier;
}

- (cl_kernel_arg_type_qualifier)typeQualifier {
	cl_kernel_arg_type_qualifier qualifier;
	clGetKernelArgInfo(self.kernel.kernel,
					   self.index,
					   CL_KERNEL_ARG_TYPE_QUALIFIER,
					   sizeof(qualifier),
					   &qualifier,
					   NULL);
	return qualifier;
}

- (NSString *)typeName {
	if (_typeName == nil) {
		const int arg_name_max = 1024;
		char arg_name[arg_name_max];
		clGetKernelArgInfo(self.kernel.kernel, self.index, CL_KERNEL_ARG_TYPE_NAME, arg_name_max, arg_name, NULL);
		_typeName = [NSString stringWithUTF8String:arg_name];
	}
	
	return _typeName;
}

- (NSString *)name {
	if (_name == nil) {
		const int arg_name_max = 1024;
		char arg_name[arg_name_max];
		clGetKernelArgInfo(self.kernel.kernel,
						   self.index,
						   CL_KERNEL_ARG_NAME,
						   arg_name_max,
						   arg_name,
						   NULL);
		_name = [NSString stringWithUTF8String:arg_name];
	}
	
	return _name;
}

@end
