//
//  CLBuffer.m
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.05.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

#import "CLBuffer.h"
#import "CLUtilities.h"
#import "CLContext.h"

@interface CLBuffer ()
@property (readwrite) cl_mem buffer;
@property (readwrite) NSData *data;
@end

@implementation CLBuffer

@synthesize length = _length;
@synthesize data = _data;

- (instancetype)initWithContext:(CLContext *)context flags:(cl_mem_flags)flags data:(NSData *)data {
    NSAssert(!(flags & CL_MEM_ALLOC_HOST_PTR), @"Memory allocation on host not yet supported");
    
    if (flags & (CL_MEM_WRITE_ONLY|CL_MEM_READ_WRITE)) {
        NSAssert([data isKindOfClass:[NSMutableData class]], @"Writeable buffer must be backed by an instance of NSMutableData");
    }
    
    self = [super init];
    void *bytes = NULL;
    size_t size = 0;
    
    if (flags & (CL_MEM_USE_HOST_PTR|CL_MEM_COPY_HOST_PTR)) {
        size = data.length;
        
        if ([data isKindOfClass:[NSMutableData class]]) {
            bytes = ((NSMutableData *)data).mutableBytes;
        } else {
            bytes = (void *)data.bytes;
        }
    }
    
    cl_int error = CL_SUCCESS;
    _buffer = clCreateBuffer(context.context, flags, size, bytes, &error);
    _data = data;
    [CLUtilities checkError:error message:@"Create buffer"];
    return self;
}

- (instancetype)initWithContext:(CLContext *)context length:(NSUInteger)length {
    self = [super init];
    cl_mem_flags flags = CL_MEM_WRITE_ONLY;
    cl_int error = CL_SUCCESS;
    _buffer = clCreateBuffer(context.context, flags, length, NULL, &error);
    [CLUtilities checkError:error message:@"Create buffer"];
    return self;
}

- (instancetype)initWithContext:(CLContext *)context data:(NSData *)data {
    cl_mem_flags flags = CL_MEM_READ_ONLY;

    if ([data isKindOfClass:[NSMutableData class]]) {
        flags = CL_MEM_READ_WRITE;
    }
    
    flags |= CL_MEM_COPY_HOST_PTR;
    
    return [self initWithContext:context flags:flags data:data];
}

- (void)dealloc {
    clReleaseMemObject(self.buffer);
}

#pragma mark - Properties
- (size_t)length {
    clGetMemObjectInfo(self.buffer, CL_MEM_SIZE, sizeof(size_t), &_length, NULL);
    return _length;
}

- (void *)bytes {
    return self.data.bytes;
}

@end
