//
//  CLBuffer.h
//  OpenCLKit
//
//  Created by Jan-Gerd Tenberge on 14.05.15.
//  Copyright (c) 2015 Jan-Gerd Tenberge. All rights reserved.
//

@import Foundation;
@import OpenCL;

@class CLContext;

@interface CLBuffer : NSObject

@property (readonly) cl_mem buffer;
@property (readonly) size_t length;
@property (readonly) void *bytes;

- (instancetype)initWithContext:(CLContext *)context flags:(cl_mem_flags)flags data:(NSData *)data NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithContext:(CLContext *)context length:(NSUInteger)length NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithContext:(CLContext *)context data:(NSData *)data;
@end
